//
//  NSObject+DBInsert.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/16.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#if !__has_feature(objc_arc)
#error  does not support Objective-C Automatic Reference Counting (ARC)
#endif

#import "NSObject+DBInsert.h"
#import "FMDatabase.h"
#import "DBProperty.h"
#import "NSObject+DbObject.h"
#import "NSObject+DBProtocol.h"
#import "DBDatabaseQueue.h"
#import "NSObject+DBCreate.h"
#import "NSObject+DBPropertys.h"

@implementation NSObject (DBInsert)

#pragma mark Insert model

- (void)insertToDBFinished:(DBSuccess)block {
    
    NSString *tableName = [self.class ORMDBTableName];
    
    [self insertToDB:tableName finished:block];
}

-(void)insertToDB:(NSString *)tableName finished:(DBSuccess)block
{
    self.primaryKey = [self.class ORMDBprimaryKey];
    
    [self.class setDBtableName:tableName];
    
    if (self.primaryKey) {
        [self insertUpdateToDB:block];
    }
    else{
        [self.class.dbQueue inDatabaseAsync:^(FMDatabase *db) {
            [self executeInsertToDB:db result:block];
        }];
    }
}

#pragma mark Private mothod

- (void)insertUpdateToDB:(DBSuccess)block {
    
    if ([self.class ORMDBTableName]) {
        [self.class setDBtableName:[self.class ORMDBTableName]];
    }
    
    self.primaryKey = [self.class ORMDBprimaryKey];
    [self.class.dbQueue inDatabaseAsync:^(FMDatabase *db) {
        BOOL isExists = [self executeIsExistsToDB:db result:nil];
        if (isExists) {
            [self executeUpdateToDB:db result:block];
        }
        else {
            [self executeInsertToDB:db result:block];
        }
        
    }];
}

#pragma mark - Insert

- (void)executeInsertToDB:(FMDatabase *)db result:(DBSuccess)block
{
    //    NSLog(@"=========================");
    //    NSLog(@"开始插入数据");
    NSMutableString *insertKey = [NSMutableString stringWithCapacity:0];
    NSMutableString *insertValuesStr = [NSMutableString stringWithCapacity:0];
    NSMutableArray *insertValues = [NSMutableArray arrayWithCapacity:0];
    
    [self.class createInsertKey:insertKey insertValuesStr:insertValuesStr insertValues:insertValues model:self];
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@)", self.class.DBtableName, insertKey, insertValuesStr];
    NSArray *insertValuesArray = [NSArray arrayWithArray:insertValues];
    
    BOOL execute = [db executeUpdate:insertSQL withArgumentsInArray:insertValuesArray];
    self.rowid = db.lastInsertRowId;
    
    if (block) {
        block(execute);
    }
    
    if (execute == NO) {
        NSLog(@"database insert fail %@",NSStringFromClass(self.class));
    }
}

#pragma mark - Update

- (void)executeUpdateToDB:(FMDatabase *)db result:(DBSuccess)block
{
    [self executeUpdateToDB:db where:nil result:block];
}

- (void)executeUpdateToDB:(FMDatabase *)db where:(NSString *)where result:(DBSuccess)block
{
    NSMutableString *updateKey = [NSMutableString stringWithCapacity:0];
    NSMutableArray *updateValues = [NSMutableArray arrayWithCapacity:0];
    
    //创建updateKey 和 UpdateValues
    [self.class createSetKey:updateKey andSetValues:updateValues withModel:self];
    
    NSString *updateSQL = nil;
    if (where) {
        updateSQL = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@", self.class.DBtableName, updateKey, where];
    }
    else {
        //通过rowid来更新数据
        if (self.rowid > 0) {
            updateSQL = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE rowid=%lld",self.class.DBtableName, updateKey, self.rowid];
        }
        else {
            if (!self.primaryKey) {
                if (block) {
                    block(NO);
                }
                return ;
            }
            
            //通过primarykey来更新数据
            updateSQL = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@=?",self.class.DBtableName, updateKey, self.primaryKey];
            
            [updateValues addObject:[self valueForKey:self.primaryKey]];
        }
    }
    
    BOOL execute = [db executeUpdate:updateSQL withArgumentsInArray:updateValues];
    
    if (block) {
        block(execute);
    }
}

#pragma mark - isExist

- (BOOL)executeIsExistsToDB:(FMDatabase *)db result:(DBSuccess)block
{
    if (!self.primaryKey) {
        if (block) {
            block(NO);
        }
        return NO;
    }
    
    NSString *where = [NSString stringWithFormat:@"%@='%@'", [self.class ORMDBprimaryKey],[self valueForKey:[self.class ORMDBprimaryKey]]];
    
    BOOL isExists = [self executeIsExistsToDB:where db:db result:block];
    
    return isExists;
}

- (BOOL)executeIsExistsToDB:(NSString *)where db:(FMDatabase *)db result:(DBSuccess)block {
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",self.class.DBtableName,where];
    FMResultSet *resultSet = [db executeQuery:querySQL];
    
    //结果有多少个
    //int resultNum =  [resultSet intForColumnIndex:0];
    
    BOOL isExists = [resultSet next];
    
    [resultSet close];
    
    if (block) {
        block(isExists);
    }
    
    return isExists;
}

/**
 *  根据model创建插入语句
 *
 *  @param insertKey       例:(name,age,height,weight)
 *  @param insertValuesStr 例:(?,?,?,?)
 *  @param insertValues    @[@"Jay", @18, @1.8, @60]
 *  @param model           model
 */
+ (void)createInsertKey:(NSMutableString *)insertKey insertValuesStr:(NSMutableString *)insertValuesStr insertValues:(NSMutableArray *)insertValues model:(NSObject *)model {
    
    for (int i=0; i<self.propertys.count; i++) {
        DBProperty *property = [self.propertys objectAtIndex:i];
        
        id value = nil;
        
        if (property.relationType == RelationType_array) {
            
            NSArray *relationArray = [model valueForKey:property.name];
            if (relationArray && [relationArray count]) {
                
                NSMutableArray *valuesArray = [[NSMutableArray alloc]initWithCapacity:[relationArray count]];
                NSString *itemType = [[model.class ORMDBArrayProperties] objectForKey:property.name];
                
                if ([NSClassFromString(itemType) ORMDBNeedBeLinked]) {
                    
                    if (itemType) {
                        
                        NSString *primeKey = [NSClassFromString(itemType) ORMDBprimaryKey];
                        
                        for (NSObject *relationModel in relationArray){
                            
                            [self executeRelationShipTableInsertUpdate:relationModel];
                            
                            value = [relationModel valueForKey:primeKey];
                            
                            [valuesArray addObject:value];
                        }
                    }
                    else{
                        NSLog(@"warning：协议中的函数+(NSDictionary *)DBArrayProperties缺失NSArray中的类型...");
                    }
                    
                }
                else{
                    valuesArray = [relationArray mutableCopy];
                }
                
                
                
                NSData *objSerialize = nil;
                if (valuesArray && [valuesArray count] > 0) {
                    objSerialize = [NSKeyedArchiver archivedDataWithRootObject:valuesArray];
                }
                
                NSString *name = [NSString stringWithFormat:@"%@",property.name];
                
                if (name && objSerialize) {
                    [insertKey appendFormat:@"%@,", name];
                    [insertValuesStr appendString:@"?,"];
                    [insertValues addObject:objSerialize];
                }
                else{
                    NSLog(@"value字段值为空...");
                }
            }
        }
        else if (property.relationType == RelationType_link) {
            id relationClass = NSClassFromString(property.orignType);
            NSString *primeKey = [relationClass ORMDBprimaryKey];
            id relationModel = [model valueForKey:property.name];
            
            if (relationModel) {
                value = [relationModel valueForKey:primeKey];
                [self executeRelationShipTableInsertUpdate:relationModel];
            }
            
            NSString *name = [NSString stringWithFormat:@"%@%@",property.name,primeKey];
            
            if (name && value) {
                [insertKey appendFormat:@"%@,", name];
                [insertValuesStr appendString:@"?,"];
                [insertValues addObject:value];
            }
            else{
                NSLog(@"value字段值为空...");
            }
        }
        else if (property.relationType == RelationType_expand){
            
            id relationModel = [model valueForKey:property.name];
            NSString *name = property.name;
            
            NSData *objSerialize = nil;
            if (relationModel) {
                objSerialize = [NSKeyedArchiver archivedDataWithRootObject:relationModel];
            }
            value = objSerialize;
            if (value) {
                [insertKey appendFormat:@"%@,", name];
                [insertValuesStr appendString:@"?,"];
                [insertValues addObject:value];
            }
            else{
                NSLog(@"value字段值为空...");
            }
        }
        else{
            value = [model valueForKey:property.name];
            value = [self valueForFileName:value];
            
            if (value) {
                [insertKey appendFormat:@"%@,", property.name];
                [insertValuesStr appendString:@"?,"];
                [insertValues addObject:value];
            }
            else{
                NSLog(@"value字段值为空...");
            }
        }
    }
    
    if (insertKey.length > 0) {
        [insertKey deleteCharactersInRange:NSMakeRange(insertKey.length - 1, 1)];
    }
    if (insertValuesStr.length > 0) {
        [insertValuesStr deleteCharactersInRange:NSMakeRange(insertValuesStr.length - 1, 1)];
    }
}

/**
 *  通过model创建setKey和setValues
 *
 *  @param setKey    SQL语句中的"SET %@"这个%@,例:@"name=?,age=?"
 *  @param setValues 要更新的值,例:@[@"Jay", @18]
 *  @param model        model
 */
+ (void)createSetKey:(NSMutableString *)setKey andSetValues:(NSMutableArray *)setValues withModel:(NSObject *)model {
    
    for (int i=0; i<self.propertys.count; i++) {
        DBProperty *property = [self.propertys objectAtIndex:i];
        
        id value = nil;
        
        if (property.relationType == RelationType_array) {
            
            NSArray *relationArray = [model valueForKey:property.name];
            if (relationArray && [relationArray count]) {
                
                NSMutableArray *valuesArray = [[NSMutableArray alloc]initWithCapacity:[relationArray count]];
                NSString *itemType = [[model.class ORMDBArrayProperties] objectForKey:property.name];
                
                if ([NSClassFromString(itemType) ORMDBNeedBeLinked]) {
                    
                    if (itemType) {
                        
                        NSString *primeKey = [NSClassFromString(itemType) ORMDBprimaryKey];
                        
                        for (NSObject *relationModel in relationArray){
                            
                            [self executeRelationShipTableInsertUpdate:relationModel];
                            
                            value = [relationModel valueForKey:primeKey];
                            
                            [valuesArray addObject:value];
                        }
                    }
                    else{
                        NSLog(@"warning：协议中的函数+(NSDictionary *)DBArrayProperties缺失NSArray中的类型...");
                    }
                    
                }
                else{
                    valuesArray = [relationArray mutableCopy];
                }
                
                NSData *objSerialize = nil;
                if (valuesArray && [valuesArray count] > 0) {
                    objSerialize = [NSKeyedArchiver archivedDataWithRootObject:valuesArray];
                }
                
                NSString *name = [NSString stringWithFormat:@"%@",property.name];
                
                if (name && objSerialize) {
                    
                    [setKey appendFormat:@"%@=?,", name];
                    [setValues addObject:objSerialize];
                }
                else{
                    NSLog(@"value字段值为空...");
                }
            }
        }
        else if (property.relationType == RelationType_link) {
            
            id relationClass = NSClassFromString(property.orignType);
            NSString *primeKey = [relationClass ORMDBprimaryKey];
            id relationModel = [model valueForKey:property.name];
            
            if (relationModel) {
                
                value = [relationModel valueForKey:primeKey];
                [self executeRelationShipTableInsertUpdate:relationModel];
            }
            
            
            NSString *name = [NSString stringWithFormat:@"%@%@",property.name,primeKey];
            
            if (name && value) {
                [setKey appendFormat:@"%@=?,", name];
                [setValues addObject:value];
            }
            else{
                NSLog(@"value字段值为空...");
            }
        }
        else if (property.relationType == RelationType_expand){
            
            id relationModel = [model valueForKey:property.name];
            NSString *name = property.name;
            
            NSData *objSerialize = nil;
            if (relationModel) {
                objSerialize = [NSKeyedArchiver archivedDataWithRootObject:relationModel];
            }
            value = objSerialize;
            
            if (name && value) {
                [setKey appendFormat:@"%@=?,", name];
                [setValues addObject:value];
            }
            else{
                NSLog(@"value字段值为空...");
            }
        }
        else{
            NSString *name = [NSString stringWithFormat:@"%@",property.name];
            value = [model valueForKey:property.name];
            value = [self valueForFileName:value];
            
            if (name && value) {
                [setKey appendFormat:@"%@=?,", name];
                [setValues addObject:value];
            }
            else{
                NSLog(@"value字段值为空...");
            }
        }
    }
    if (setKey.length > 0) {
        [setKey deleteCharactersInRange:NSMakeRange(setKey.length - 1, 1)];
    }
}

+ (void) executeRelationShipTableInsertUpdate:(id)model
{
    if (model) {
        
        [model insertToDBFinished:^(BOOL isSuccess) {
            
            if (isSuccess) {
                NSLog(@"link relation Tale insertToDB isSuccess");
            }
            else {
                NSLog(@"link relation Tale insertToDB failed");
            }
            
        }];
    }
}

@end

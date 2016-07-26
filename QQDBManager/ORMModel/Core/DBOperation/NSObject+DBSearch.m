//
//  NSObject+Search.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/17.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#if !__has_feature(objc_arc)
#error  does not support Objective-C Automatic Reference Counting (ARC)
#endif

#import "NSObject+DBSearch.h"
#import "NSObject+DBProtocol.h"
#import "NSString+DBModel.h"
#import "FMDatabase.h"
#import "DBProperty.h"
#import "DBDatabaseQueue.h"
#import "NSObject+DbObject.h"
#import "NSObject+DBPropertys.h"
#import "FMDatabaseQueue.h"

@implementation NSObject (DBSearch)

#pragma mark -- Search All
+ (NSArray *)searchAll
{
    return [self searchTable:self.DBtableName Where:nil orderBy:nil offset:0 count:0];
}

+ (NSArray *)searchAllWhere:(NSString *)where
{
    return [self searchTable:self.DBtableName Where:where orderBy:nil offset:0 count:0];
}

+(NSArray *)searchAllInTable:(NSString *)tableName
{
    return [self searchTable:tableName Where:nil orderBy:nil offset:0 count:0];
}

+(NSArray *)searchAllInTable:(NSString *)tableName Where:(NSString *)where
{
    return [self searchTable:tableName Where:where orderBy:nil offset:0 count:0];
}

#pragma mark -- Private Mothod
+ (NSArray *)searchTable:(NSString *)tableName Where:(NSString *)where orderBy:(NSString *)orderBy offset:(int)offset count:(int)count
{
    __block NSArray* results = nil;
    
    [self.class.dbQueue inDatabaseSync:^(FMDatabase *db) {
        
        NSMutableString *searchSQL = [NSMutableString stringWithFormat:@"SELECT * FROM %@ ", tableName];
        if (where != nil && ![where isEmptyWithTrim]) {
            [searchSQL appendFormat:@"WHERE %@ ",where];
        }
        NSString *tmpStr = [self SQLString:searchSQL AddOder:orderBy offset:offset count:count];
        FMResultSet *set =[db executeQuery:tmpStr];
        
        results = [self executeResult:set];
        [set close];
        
    }];
    
    return results;
}

#pragma mark Search All
+ (void)searchAll:(DBResults)block {
    [self searchWhere:nil orderBy:nil offset:0 count:0 results:block];
}

+ (void)searchAllWhere:(NSString *)where results:(DBResults)block {
    [self searchWhere:where orderBy:nil offset:0 count:0 results:block];
}

+ (void)searchWhere:(NSString *)where orderBy:(NSString *)orderBy offset:(int)offset count:(int)count results:(DBResults)block
{
    [self.dbQueue inDatabaseAsync:^(FMDatabase *db) {
        
        NSMutableString *searchSQL = [NSMutableString stringWithFormat:@"SELECT * FROM %@ ", self.DBtableName];
        if (where != nil && ![where isEmptyWithTrim]) {
            [searchSQL appendFormat:@"WHERE %@ ",where];
        }
        [self SQLString:searchSQL AddOder:orderBy offset:offset count:count];
        FMResultSet *set =[db executeQuery:searchSQL];
        
        [self executeResult:set block:block];
        [set close];
    }];
}


#pragma mark - Search

+ (void)executeResult:(FMResultSet *)set block:(DBResults)block {
    
    NSArray *array = [self executeResult:set];
    
    if (block) {
        block(array);
    }
}

+ (NSArray *)executeResult:(FMResultSet *)set{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    while ([set next]) {
        NSObject *model = [[self alloc] init];
        model.rowid = [set intForColumnIndex:0];
        if (self.propertys == nil) {
            [self loadProtypes];
        }
        
        for (int i=0; i<self.propertys.count; i++) {
            DBProperty *property = [self.propertys objectAtIndex:i];
            
            if (property.relationType == RelationType_array){
                
                [self setValueWithModel:model set:set columeName:property.name propertyName:property.name columeType:property.orignType];
                
                NSString *itemType = [[model.class ORMDBArrayProperties] objectForKey:property.name];
                id relationClass = NSClassFromString(itemType);
                
                if ([relationClass ORMDBNeedBeLinked]){
                    NSArray *tmpList = [model valueForKey:property.name];
                    
                    if (tmpList && [tmpList count] > 0) {
                        NSMutableArray *itemList = [[NSMutableArray alloc]initWithCapacity:[tmpList count]];
                        NSString *primeKey = [relationClass ORMDBprimaryKey];
                        
                        for (id item in tmpList) {
                            id itemModel = [relationClass new];
                            [itemModel setValue:item forKey:primeKey];
                            
                            itemModel = [self executeRelationShipTableSearch:itemModel];
                            
                            [itemList addObject:itemModel];
                        }
                        
                        [model setValue:itemList forKey:property.name];
                    }
                    
                }
            }
            else if (property.relationType == RelationType_link) {
                id relationClass = NSClassFromString(property.orignType);
                NSString *primeKey = [relationClass ORMDBprimaryKey];
                NSObject *relationModel = [model valueForKey:property.name];
                
                DBProperty *relationProperty = nil;
                if (primeKey) {
                    for (DBProperty *rProperty in property.relationProperty){
                        if ([rProperty.name isEqualToString:primeKey]) {
                            relationProperty = rProperty;
                            break;
                        }
                    }
                }
                
                if (relationProperty) {
                    
                    if (relationModel == nil) {
                        relationModel = [[NSClassFromString(property.orignType) alloc] init];
                    }
                    NSString *name = [NSString stringWithFormat:@"%@%@",property.name,primeKey];
                    [self setValueWithModel:relationModel set:set columeName:name propertyName:relationProperty.name columeType:relationProperty.orignType];//先设置主键的值
                }
                
                relationModel = [self executeRelationShipTableSearch:relationModel];
                
                [model setValue:relationModel forKey:property.name];
            }
            else if (property.relationType == RelationType_expand){

                NSData *data = [set dataForColumn:property.name];
                
                id relationModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                
                [model setValue:relationModel forKey:property.name];
                
                /*
                NSObject *relationModel = [model valueForKey:property.name];
                if (relationModel == nil) {
                    relationModel = [[NSClassFromString(property.orignType) alloc] init];
                }
                
                for (DBProperty *relationProperty in property.relationProperty){
                    NSString *name = [NSString stringWithFormat:@"%@%@",property.name,relationProperty.name];
                    
                    [self setValueWithModel:relationModel set:set columeName:name propertyName:relationProperty.name columeType:relationProperty.orignType];
                }
                
                [model setValue:relationModel forKey:property.name];
                 */
            }
            else{
                [self setValueWithModel:model set:set columeName:property.name propertyName:property.name columeType:property.orignType];
            }
            
        }
        [array addObject:model];
    }
    [set close];
    
    return array;

}

+ (id)executeRelationShipTableSearch:(NSObject *)model
{
    NSString *where = [NSString stringWithFormat:@"%@='%@'", [model.class ORMDBprimaryKey],[model valueForKey:[model.class ORMDBprimaryKey]]];
    
    NSMutableString *searchSQL = [NSMutableString stringWithFormat:@"SELECT * FROM %@ ", model.class.DBtableName];
    if (where != nil && ![where isEmptyWithTrim]) {
        [searchSQL appendFormat:@"WHERE %@ ",where];
    }
    [model.class SQLString:searchSQL AddOder:nil offset:0 count:0];
    
    __block NSArray *array = nil;
    [self.dbQueue inDatabaseSync:^(FMDatabase *db) {
        FMResultSet *set =[db executeQuery:searchSQL];
        array = [model.class executeResult:set];
    }];
    
    
    if (array && array.count > 0) {
        return [array firstObject];
    }
    return nil;
}

/**
 *  拼接SQL语句的条件,例:@"ORDER BY %@ LIMIT %d OFFSET %d "
 *
 *  @param SQL     SQL
 *  @param orderby orderby
 *  @param offset  offset
 *  @param count   count
 */
+ (NSString *)SQLString:(NSMutableString *)SQL AddOder:(NSString *)orderby offset:(int)offset count:(int)count
{
    if (!SQL || !count) {
        return SQL;
    }
    
    if (orderby != nil && ![orderby isEmptyWithTrim]) {
        [SQL appendFormat:@"ORDER BY %@ ",orderby];
    }
    [SQL appendFormat:@"LIMIT %d OFFSET %d ",count, offset];
    
    return SQL;
}

@end

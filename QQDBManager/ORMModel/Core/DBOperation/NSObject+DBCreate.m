//
//  NSObject+DBMethods.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/11.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#if !__has_feature(objc_arc)
#error  does not support Objective-C Automatic Reference Counting (ARC)
#endif

#import "NSObject+DBCreate.h"

#import "QQFileHandler.h"
#import "FMDatabase.h"
#import "DBDatabaseQueue.h"
#import "DBProperty.h"
#import "NSObject+DBPropertys.h"
#import "NSObject+DBProtocol.h"
#import "NSString+DBModel.h"
#import "FMDatabaseAdditions.h"

/** system */
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation NSObject (DBCreate)

#pragma mark - Init

+ (void)DBInit {
    [self loadProtypes];
    [self createTable];
}

#pragma mark - Table
/** 创建表 */
+ (void)createTable
{
    if ([self.DBtableName isEmptyWithTrim]) {
        NSLog(@"TableName is None!");
        return;
    }
    
    [self.dbQueue inDatabaseSync:^(FMDatabase *db) {
        NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,%@)",self.DBtableName,[self appendTableSQL]];
        [db executeUpdate:createTableSQL];
        
    }];
    
    [self addColomnsIfNoExist];
}

/** 添加数据库表中不存在的列*/
+ (void)addColomnsIfNoExist
{
    [self.dbQueue inDatabaseSync:^(FMDatabase *db) {
        for (int i=0; i<self.propertys.count; i++) {
            DBProperty *property = [self.propertys objectAtIndex:i];
            
            NSString *name = property.name;
            
            if (property.relationType == RelationType_array){
                if ([db columnExists:name inTableWithName:self.DBtableName] == NO) {
                    
                    NSLog(@"NO ColumnExists： %@ ",name);
                    
                    if ([self addColumn:name toTable:self.DBtableName withType:property.dbType inDatabase:db]) {
                        NSLog(@"addColum： %@ success",name);
                    }
                    else{
                        NSLog(@"addColum： %@ failed",name);
                    }
                }
            }
            else if (property.relationType == RelationType_link){
                id relationClass = NSClassFromString(property.orignType);
                NSString *primeKey = [relationClass ORMDBprimaryKey];
                if (primeKey) {
                    name = [NSString stringWithFormat:@"%@%@",property.name,primeKey];
                }
                
                if ([db columnExists:name inTableWithName:[self DBtableName]] == NO) {
                    
                    NSLog(@"NO ColumnExists： %@ ",name);
                    
                    if ([self addColumn:name toTable:[self DBtableName] withType:property.dbType inDatabase:db]) {
                        NSLog(@"addColum： %@ success",name);
                    }
                    else{
                        NSLog(@"addColum： %@ failed",name);
                    }
                }
            }
            else if (property.relationType == RelationType_expand){
                
                if ([db columnExists:name inTableWithName:[self DBtableName]] == NO) {
                    
                    NSLog(@"NO ColumnExists： %@ ",name);
                    
                    if ([self addColumn:name toTable:[self DBtableName] withType:property.dbType inDatabase:db]) {
                        NSLog(@"addColum： %@ success",name);
                    }
                    else{
                        NSLog(@"addColum： %@ failed",name);
                    }
                }
                
            }
        }
    }];
}

+ (BOOL)addColumn:(NSString*)columnName toTable:(NSString *)tableName withType:(NSString *)type inDatabase:(FMDatabase *)db
{
    return [self addColumn:columnName toTable:tableName withType:type defaultValue:nil inDatabase:db];
}

+ (BOOL)addColumn:(NSString*)columnName toTable:(NSString*)tableName withType:(NSString*)type defaultValue:(NSString*)value inDatabase:(FMDatabase*)db
{
    if (!columnName || !tableName || !type || !db)
        return NO;
    
    //    if (![db isTable:tableName hasColumn:columnName]) {
    NSString* addColSql = [NSString stringWithFormat:@"alter table %@ add %@ %@ ",tableName,columnName,type];
    
    if (value.length > 0)
        addColSql = [NSString stringWithFormat:@"%@ default %@",addColSql,value];
    if (![db executeUpdate:addColSql]) {
        return NO;
    }
    return YES;
}

#pragma mark - Append SQL
/**
 *  根据modle,返回创建表SQL,例:@"name TEXT,age INTEGER,height BIGINT"
 *
 *  @return NSString
 */
+ (NSString *)appendTableSQL {
    NSMutableString *tableSQL = [NSMutableString string];
    for (int i=0; i<self.propertys.count; i++) {
        
        NSString *name = nil;
        NSString *dbType = nil;
        
        DBProperty *property = [self.propertys objectAtIndex:i];
        
        if (property.relationType == RelationType_array){
            
            name = property.name;
            dbType = property.dbType;
            
            if (name && dbType) {
                [tableSQL appendFormat:@"%@ %@", name, dbType];
            }
            
            if (self.propertys.count != i+1) {
                [tableSQL appendString:@","];
            }
            
        }
        else if (property.relationType == RelationType_link) {
            id relationClass = NSClassFromString(property.orignType);
             NSString *primeKey = [relationClass ORMDBprimaryKey];
            
            DBProperty *relationProperty = nil;
            if (primeKey) {
                for (DBProperty *rProperty in property.relationProperty) {
                    if ([primeKey isEqualToString:rProperty.name]) {
                        relationProperty = rProperty;
                        break;
                    }
                }
            }
            
            if (relationProperty) {
                name = [NSString stringWithFormat:@"%@%@",property.name,primeKey];
                dbType = relationProperty.dbType;
            }
            
            if (name && dbType) {
                [tableSQL appendFormat:@"%@ %@", name, dbType];
            }
            
            if (self.propertys.count != i+1) {
                [tableSQL appendString:@","];
            }
        }
        else if (property.relationType == RelationType_expand){
            
            name = property.name;
            dbType = property.dbType;
            
            if (name && dbType) {
                [tableSQL appendFormat:@"%@ %@", name, dbType];
            }
            
            if (self.propertys.count != i+1) {
                [tableSQL appendString:@","];
            }
            /*
            for (DBProperty *relationProperty in property.relationProperty) {
                name = [NSString stringWithFormat:@"%@%@",property.name,relationProperty.name];
                dbType = relationProperty.dbType;
                
                if (name && dbType) {
                    [tableSQL appendFormat:@"%@ %@", name, dbType];
                }
                
                if (self.propertys.count != i+1) {
                    [tableSQL appendString:@","];
                }
            }
             */
            
        }
        else{
            name = property.name;
            dbType = property.dbType;
            
            if (name && dbType) {
                [tableSQL appendFormat:@"%@ %@", name, dbType];
            }
            
            if (self.propertys.count != i+1) {
                [tableSQL appendString:@","];
            }
        }
    }
    return tableSQL;
}

@end

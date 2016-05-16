//
//  NSObject+DBMethods.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/11.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "NSObject+DBCreate.h"

#import "QQFileHandler.h"
#import <FMDB/FMDB.h>
#import "DBDatabaseQueue.h"
#import "DBProperty.h"
#import "NSObject+DBPropertys.h"
#import "NSObject+DBProtocol.h"
#import "NSString+DBModel.h"

/** system */
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation NSObject (DBCreate)

#pragma mark - Init

+ (void)DBInit {
    [self loadProtypes];
    [self createTable];
    
    [self addTableColomns];
}

#pragma mark - Table
/** 创建表 */
+ (void)createTable
{
    if ([self.DBtableName isEmptyWithTrim]) {
        NSLog(@"TableName is None!");
        return;
    }
    
    [self.dbQueue inDatabaseAsync:^(FMDatabase *db) {
        NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,%@)",self.DBtableName,[self appendTableSQL]];
        [db executeUpdate:createTableSQL];
    }];
}

+ (void)addTableColomns
{
    [self.dbQueue inDatabaseAsync:^(FMDatabase *db){
       
        for (int i=0; i<self.propertys.count; i++) {
            DBProperty *property = [self.propertys objectAtIndex:i];
            
            if ([db columnExists:property.name inTableWithName:[self DBtableName]] == NO) {
                if ([self addColumn:property.name toTable:[self DBtableName] withType:property.dbType inDatabase:db]) {
                    NSLog(@"addColum %@ success",property.name);
                }
                else{
                    NSLog(@"addColum %@ failed",property.name);
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
        DBProperty *property = [self.propertys objectAtIndex:i];
        [tableSQL appendFormat:@"%@ %@", property.name, property.dbType];
        if (self.propertys.count != i+1) {
            [tableSQL appendString:@","];
        }
    }
    return tableSQL;
}

@end

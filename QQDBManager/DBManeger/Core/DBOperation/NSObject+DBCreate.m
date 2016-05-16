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

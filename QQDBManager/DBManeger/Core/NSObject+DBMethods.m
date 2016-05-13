//
//  NSObject+DBMethods.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/11.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "NSObject+DBMethods.h"
#import "NSObject+DBPropertys.h"
#import "NSObject+DBProtocol.h"
#import "QQFileHandler.h"
#import <FMDB/FMDB.h>
#import "NSString+DB.h"
#import "DBProperty.h"
#import "DBDatabaseQueue.h"
#import "NSObject+DbObject.h"

/** system */
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void(^DBResults)(NSArray *results);
typedef void(^DBSuccess)(BOOL isSuccess);

@implementation NSObject (DBMethods)

#pragma mark - Init

+ (void)DBInit {
    [self loadProtypes];
    [self createTable];
}

#pragma mark - Private Methods

/** 加载JJProperty数组 */
+ (void)loadProtypes {
    self.propertys = [self properties];
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
    BOOL execute = [db executeUpdate:insertSQL withArgumentsInArray:insertValues];
    self.rowid = db.lastInsertRowId;
    
    if (block) {
        block(execute);
    }
    
    if (execute == NO) {
        NSLog(@"database insert fail %@",NSStringFromClass(self.class));
    }
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
        [insertKey appendFormat:@"%@,", property.name];
        [insertValuesStr appendString:@"?,"];
        id value = [model valueForKey:property.name];
        [self valueForFileName:value];
        [insertValues addObject:value];
    }
    
    if (insertKey.length > 0) {
        [insertKey deleteCharactersInRange:NSMakeRange(insertKey.length - 1, 1)];
    }
    if (insertValuesStr.length > 0) {
        [insertValuesStr deleteCharactersInRange:NSMakeRange(insertValuesStr.length - 1, 1)];
    }
}

/**
 *  数据库value存文件对应的名字使用(UIImage, NSData, NSDate)
 *
 *  @param value 文件的名字
 */
+ (void)valueForFileName:(id)value
{
    if (!value) {
        return ;
    }
    
    NSDate *date = [NSDate date];
    
    if ([value isKindOfClass:[UIImage class]])
    {
        NSString *filename = [NSString stringWithFormat:@"img%f",[date timeIntervalSince1970]];
        [UIImageJPEGRepresentation(value, 1) writeToFile:[QQFileHandler getPathForDocuments:filename inDir:@"dbImages"] atomically:YES];
        value = filename;
    }
    else if ([value isKindOfClass:[NSData class]])
    {
        NSString *filename = [NSString stringWithFormat:@"data%f",[date timeIntervalSince1970]];
        [value writeToFile:[QQFileHandler getPathForDocuments:filename inDir:@"dbdata"] atomically:YES];
        value = filename;
    }
    else if ([value isKindOfClass:[NSDate class]])
    {
        //value = [NSDate stringWithDate:value];
    }
}

#pragma mark - Property

static char *kDBPropertysKey;
+ (void)setPropertys:(NSMutableArray *)propertys {
    objc_setAssociatedObject(self, &kDBPropertysKey, propertys, OBJC_ASSOCIATION_RETAIN);
}

+ (NSMutableArray *)propertys {
    return objc_getAssociatedObject(self, &kDBPropertysKey);
}
@end

//
//  NSObject+DbObject.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <FMDB/FMDB.h>

@class DBProperty;

@interface NSObject (DbObject)

/**
 *  主键名称,如果没有rowid,则必须要初始化,跟据此名称update和delete
 *  例:self.primaryKey = @"属性的名称";
 */
@property (nonatomic, copy) NSString *primaryKey;

/** 数据库的rowid */
@property (nonatomic, assign) sqlite_int64 rowid;

+ (void)setValueWithModel:(id)model set:(FMResultSet *)set columeName:(NSString *)columeName columeType:(NSString *)columeType property:(DBProperty *)property;

+ (void)valueForFileName:(id)value;

@end

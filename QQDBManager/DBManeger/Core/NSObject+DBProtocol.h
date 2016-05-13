//
//  NSObject+DBProtocol.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBDatabaseQueue;

@protocol DBProtocol <NSObject>

@optional

/** 返回表名 */
+ (const NSString *)DBtableName;

/** 返回数据库路径 */
+ (NSString *)DBdatabasePath;

+ (NSArray *)DBIgnoredProperties;

@end

@interface NSObject (DBProtocol) <DBProtocol>

/** 数据库操作队列 */
+ (DBDatabaseQueue *)dbQueue;

/** 设置数据库操作队列 */
+ (void)setDbQueue:(DBDatabaseQueue *)dbQueue;

@end

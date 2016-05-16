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
+ (NSString *)DBtableName;

/** 返回数据库路径 */
+ (NSString *)DBdatabasePath;

/** 不需要入库的字段*/
+ (NSArray *)DBIgnoredProperties;

/** 设定主键,返回属性名组成的NSString*/
+ (NSString *)DBprimaryKey;

/** 是否被其他model 链接 */
+ (BOOL)DBNeedBeLinked;

/** 被其他model链接的属性*/
+ (NSDictionary *)DBBeLinkedProperties;

@end

@interface NSObject (DBProtocol) <DBProtocol>

/** 数据库操作队列 */
+ (DBDatabaseQueue *)dbQueue;

/** 设置数据库操作队列 */
+ (void)setDbQueue:(DBDatabaseQueue *)dbQueue;

@end

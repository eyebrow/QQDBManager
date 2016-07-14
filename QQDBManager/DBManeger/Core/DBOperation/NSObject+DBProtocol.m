//
//  NSObject+DBProtocol.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "NSObject+DBProtocol.h"
#import "DBDatabaseQueue.h"
#import "QQFileHandler.h"
/** system */
#import <objc/runtime.h>
#import "NSObject+DBCreate.h"
#import "DBDatabaseQueue.h"

@implementation NSObject (DBProtocol)

#pragma mark - DBProtocol
/** 返回表名(默认) */
+ (const NSString *)DBtableName {
    return NSStringFromClass([self class]);
}

/** 获取数据库路径(默认) */
+ (NSString *)DBdatabasePath {
    return [QQFileHandler getPathForDocuments:[NSString stringWithFormat:@"database.db"] inDir:@"DataBase"];
}

/** 获取不存储的字段(默认) */
+(NSArray *)DBIgnoredProperties
{
    return nil;
}

/** 设定主键*/
+ (NSString *)DBprimaryKey
{
    return nil;
}

/** 是否被其他model 链接 */
+ (BOOL)DBNeedBeLinked
{
    return NO;
}

/** 被其他库链接的属性(默认) */
+(NSDictionary *)DBBeLinkedProperties
{
    return nil;
}

/** 数组中model的类型*/
+ (NSDictionary *)DBArrayProperties
{
    return nil;
}

#pragma mark - Property

static char *kDbQueueKey;
+ (void)setDbQueue:(DBDatabaseQueue *)dbQueue {
    objc_setAssociatedObject(self, &kDbQueueKey, dbQueue, OBJC_ASSOCIATION_RETAIN);
}

+ (DBDatabaseQueue *)dbQueue {
    DBDatabaseQueue *queue = objc_getAssociatedObject(self, &kDbQueueKey);
    if (!queue) {
        queue = [[DBDatabaseQueue alloc] initWithPath:[self DBdatabasePath]];
        objc_setAssociatedObject(self, &kDbQueueKey, queue, OBJC_ASSOCIATION_RETAIN);
        
        [self DBInit];
    }
    return queue;
}


@end

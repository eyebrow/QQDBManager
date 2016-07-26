//
//  NSObject+DBProtocol.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#if !__has_feature(objc_arc)
#error  does not support Objective-C Automatic Reference Counting (ARC)
#endif

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
+ (const NSString *)ORMDBTableName {
    return NSStringFromClass([self class]);
}

/** 获取数据库路径(默认) */
+ (NSString *)ORMDBPath {
    return [QQFileHandler getPathForDocuments:[NSString stringWithFormat:@"database.db"] inDir:ORMModelDataBaseDir];
}

/** 获取不存储的字段(默认) */
+(NSArray *)ORMDBIgnoredProperties
{
    return nil;
}

/** 设定主键*/
+ (NSString *)ORMDBprimaryKey
{
    return nil;
}

/** 是否被其他model 链接 */
+ (BOOL)ORMDBNeedBeLinked
{
    return NO;
}

/** 被其他库链接的属性(默认) */
+(NSDictionary *)ORMDBBeLinkedProperties
{
    return nil;
}

/** 数组中model的类型*/
+ (NSDictionary *)ORMDBArrayProperties
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
        queue = [[DBDatabaseQueue alloc] initWithPath:[self ORMDBPath]];
        objc_setAssociatedObject(self, &kDbQueueKey, queue, OBJC_ASSOCIATION_RETAIN);
        
        [self DBInit];
    }
    return queue;
}

static char *kDBtableName;
+ (void)setDBtableName:(const NSString *)name {
    objc_setAssociatedObject(self, &kDBtableName, name, OBJC_ASSOCIATION_RETAIN);
}

+ (NSString *)DBtableName {
    NSString *name = objc_getAssociatedObject(self, &kDBtableName);
    if (name == nil) {
        name = [self ORMDBTableName];
    }
    return name;
}


@end

//
//  DBDatabaseQueue.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <FMDB/FMDB.h>

typedef enum
{
    OperationType_Async,
    OperationType_Sync,
    
}OperationType;

@interface DBDatabaseQueue : FMDatabaseQueue

- (void)inDatabase:(OperationType)type block:(void (^)(FMDatabase *db))block;

#pragma mark - Async
/**
 *  异步操作,在线程里面执行(后台执行)
 *
 *  @param block block
 */
- (void)inDatabaseAsync:(void (^)(FMDatabase *db))block;

#pragma mark - Sync
/**
 *  同步操作,在当前线程里面执行(后台执行)
 *
 *  @param block block
 */
- (void)inDatabaseSync:(void (^)(FMDatabase *db))block;

@property(nonatomic,readonly)FMDatabase *database;

@end

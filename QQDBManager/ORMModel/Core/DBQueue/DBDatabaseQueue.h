//
//  DBDatabaseQueue.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "FMDatabaseQueue.h"

typedef enum
{
    OperationType_Async,
    OperationType_Sync,
    
}OperationType;

typedef void (^FMDBblock)(FMDatabase *);

@interface DBDatabaseQueue : FMDatabaseQueue
@property(nonatomic,readonly)FMDatabase *fmdb;

#pragma mark - Async
/**
 *  异步操作,在线程里面执行(后台执行)
 *
 *  @param block block
 */
- (void)inDatabaseAsync:(FMDBblock)block;

/**
 *  同步操作,在线程里面执行
 *
 *  @param block block
 */
- (void)inDatabaseSync:(FMDBblock)block;

@end

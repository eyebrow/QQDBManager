//
//  DBDatabaseQueue.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <FMDB/FMDB.h>

@interface DBDatabaseQueue : FMDatabaseQueue

#pragma mark - Async

/**
 *  异步操作,在线程里面执行(后台执行)
 *
 *  @param block block
 */
- (void)inDatabaseAsync:(void (^)(FMDatabase *db))block;

@end

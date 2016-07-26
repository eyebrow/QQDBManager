//
//  DBDatabaseQueue.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#if !__has_feature(objc_arc)
#error  does not support Objective-C Automatic Reference Counting (ARC)
#endif

#import "DBDatabaseQueue.h"
#import "FMDatabase.h"
#import "DBDefine.h"

@implementation DBDatabaseQueue

-(FMDatabase *)fmdb
{
    return _db;
}

#pragma mark - Async

- (void)inDatabaseAsync:(FMDBblock)block {
    
//    FMDBRetain(self);
//    
//    __block FMDBblock bblock = block;
//    __weak __typeof(self) weakSelf = self;
//    dispatch_async(_queue, ^() {
//        //        NSLog(@"数据库执行的线程:%@", [NSThread currentThread]);
//        __strong __typeof(weakSelf) strongSelf = weakSelf;
//        FMDatabase *db = [strongSelf fmdb];
//        bblock(db);
//        
//    });
//    
//    FMDBRelease(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self inDatabase:block];
    });
}

-(void)inDatabaseSync:(FMDBblock)block
{
    [self inDatabase:block];
}

@end

//
//  DBDatabaseQueue.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "DBDatabaseQueue.h"
#import "FMDatabase.h"

@implementation DBDatabaseQueue

#pragma mark - Async

- (void)inDatabaseAsync:(void (^)(FMDatabase *db))block {
    
    FMDBRetain(self);
    dispatch_async(_queue, ^() {
        //        NSLog(@"数据库执行的线程:%@", [NSThread currentThread]);
        
        FMDatabase *db = [self database];
        block(db);
        
        if ([db hasOpenResultSets]) {
            NSLog(@"Warning: there is at least one open result set around after performing [FMDatabaseQueue inDatabase:]");
            
#if defined(DEBUG) && DEBUG
            NSSet *openSetCopy = FMDBReturnAutoreleased([[db valueForKey:@"_openResultSets"] copy]);
            for (NSValue *rsInWrappedInATastyValueMeal in openSetCopy) {
                FMResultSet *rs = (FMResultSet *)[rsInWrappedInATastyValueMeal pointerValue];
                NSLog(@"query: '%@'", [rs query]);
            }
#endif
        }
    });
    
    FMDBRelease(self);
}

/**
 *  重写父类的方法,和父类一样
 *  注意:如果FMDBDataBaseQueue这个方法有更新,再Copy过来
 *
 *  @return FMDatabase
 */
- (FMDatabase *)database {
    if (!_db) {
        _db = FMDBReturnRetained([FMDatabase databaseWithPath:_path]);
        
#if SQLITE_VERSION_NUMBER >= 3005000
        BOOL success = [_db openWithFlags:_openFlags];
#else
        BOOL success = [_db open];
#endif
        if (!success) {
            NSLog(@"FMDatabaseQueue could not reopen database for path %@", _path);
            FMDBRelease(_db);
            _db  = 0x00;
            return 0x00;
        }
    }
    return _db;
}

@end

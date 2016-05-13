//
//  NSObject+DbObject.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "NSObject+DbObject.h"
#import <objc/runtime.h>

@implementation NSObject (DbObject)

#pragma mark - Property

static char *kPrimaryKeyKey;
- (void)setPrimaryKey:(NSString *)primaryKey {
    objc_setAssociatedObject(self, &kPrimaryKeyKey, primaryKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)primaryKey {
    NSString *primaryKey = objc_getAssociatedObject(self, &kPrimaryKeyKey);
    return primaryKey;
}

static char *kRowidKey;
- (void)setRowid:(sqlite_int64)rowid {
    objc_setAssociatedObject(self, &kRowidKey, @(rowid), OBJC_ASSOCIATION_ASSIGN);
}

- (sqlite_int64)rowid {
    NSNumber *rowidNum = objc_getAssociatedObject(self, &kRowidKey);
    sqlite_int64 rowid = rowidNum.longLongValue;
    return rowid;
}

@end

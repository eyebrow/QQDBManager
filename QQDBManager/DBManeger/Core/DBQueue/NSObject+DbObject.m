//
//  NSObject+DbObject.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "NSObject+DbObject.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "NSDate+DBModel.h"
#import "NSString+DBModel.h"
#import "QQFileHandler.h"

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

/**
 *  数据库value存文件对应的名字使用(UIImage, NSData, NSDate)
 *
 *  @param value 文件的名字
 */
+ (void)valueForFileName:(id)value
{
    if (!value) {
        return ;
    }
    
    NSDate *date = [NSDate date];
    
    if ([value isKindOfClass:[UIImage class]])
    {
        NSString *filename = [NSString stringWithFormat:@"img%f",[date timeIntervalSince1970]];
        [UIImageJPEGRepresentation(value, 1) writeToFile:[QQFileHandler getPathForDocuments:filename inDir:@"dbImages"] atomically:YES];
        value = filename;
    }
    else if ([value isKindOfClass:[NSData class]])
    {
        NSString *filename = [NSString stringWithFormat:@"data%f",[date timeIntervalSince1970]];
        [value writeToFile:[QQFileHandler getPathForDocuments:filename inDir:@"dbdata"] atomically:YES];
        value = filename;
    }
    else if ([value isKindOfClass:[NSDate class]])
    {
        value = [NSDate stringWithDate:value];
    }
}

@end

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
#import "DBProperty.h"
#import "NSObject+DBProtocol.h"

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

#pragma mark - Methods

/**
 *  根据bindingModel的类型,把数据库的值转换过来
 *
 *  @param bindingModel 继承DBModel
 *  @param set          FMResultSet
 *  @param columeName   属性的Name
 *  @param columeType   属性的类型
 */
+ (void)setValueWithModel:(id)model set:(FMResultSet *)set columeName:(NSString *)columeName propertyName:(NSString *)propertyName columeType:(NSString *)columeType{
    
    if ([columeType isEqualToString:@"NSString"]) {
        [model setValue:[set stringForColumn:columeName] forKey:propertyName];
    }
    else if ([columeType isEqualToString:@"int"] ||
             [columeType isEqualToString:@"long"] ||
             [columeType isEqualToString:@"long long"]) {
        [model setValue:[NSNumber numberWithLongLong:[set longLongIntForColumn:columeName]] forKey:propertyName];
    }
    else if ([columeType isEqualToString:@"BOOL"] ||
             [columeType isEqualToString:@"bool"]) {
        [model setValue:[NSNumber numberWithBool:[set boolForColumn:columeName]] forKey:propertyName];
    }
    else if ([columeType isEqualToString:@"char"]) {
        [model setValue:[NSNumber numberWithInt:[set intForColumn:columeName]] forKey:propertyName];
    }
    else if ([columeType isEqualToString:@"float"] ||
             [columeType isEqualToString:@"double"]) {
        [model setValue:[NSNumber numberWithDouble:[set doubleForColumn:columeName]] forKey:propertyName];
    }
    else if ([columeType isEqualToString:@"NSNumber"]) {
        [model setValue:[NSNumber numberWithLongLong:[set stringForColumn:columeName].longLongValue] forKey:propertyName];
    }
    else if ([columeType isEqualToString:@"UIImage"]) {
        NSString* filename = [set stringForColumn:columeName];
        if ([QQFileHandler isFileExists:[QQFileHandler getPathForDocuments:filename inDir:@"dbImages"]]) {
            UIImage *img = [UIImage imageWithContentsOfFile:[QQFileHandler getPathForDocuments:filename inDir:@"dbImages"]];
            [model setValue:img forKey:propertyName];
        }
    }
    else if ([columeType isEqualToString:@"NSDate"]) {
        NSString* datestr = [set stringForColumn:columeName];
        [model setValue:[NSDate dateWithString:datestr] forKey:propertyName];
    }
    else if ([columeType isEqualToString:@"NSData"]) {
        NSString *filename = [set stringForColumn:columeName];
        if ([QQFileHandler isFileExists:[QQFileHandler getPathForDocuments:filename inDir:@"dbData"]]) {
            NSData* data = [NSData dataWithContentsOfFile:[QQFileHandler getPathForDocuments:filename inDir:@"dbData"]];
            [model setValue:data forKey:propertyName];
        }
    }
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

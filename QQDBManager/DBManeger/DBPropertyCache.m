//
//  DBPropertyCache.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/6.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "DBPropertyCache.h"
/** system */
#import <objc/runtime.h>

@implementation DBPropertyCache

+ (id)setObject:(id)object forKey:(id<NSCopying>)key forDictId:(const void *)dictId
{
    // 获得字典
    NSMutableDictionary *dict = [self dictWithDictId:dictId];
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, dictId, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // 存储数据
    dict[key] = object;
    
    return dict;
}

+ (id)objectForKey:(id<NSCopying>)key forDictId:(const void *)dictId
{
    return [self dictWithDictId:dictId][key];
}


+ (id)dictWithDictId:(const void *)dictId
{
    return objc_getAssociatedObject(self, dictId);
}

@end

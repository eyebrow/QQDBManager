//
//  NSObject+DBPropertys.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/6.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "NSObject+DBPropertys.h"
#import "DBProperty.h"
#import "DBPropertyCache.h"
#import "NSObject+DBClass.h"
#import "DBDefine.h"

static const char DBCachedPropertiesKey = '\0';

@implementation NSObject (DBPropertys)

#pragma mark - Property

/** 加载Property数组 */
+ (void)loadProtypes
{
    self.propertys = [self properties];
}

static char *kDBPropertysKey;
+ (void)setPropertys:(NSMutableArray *)propertys {
    objc_setAssociatedObject(self, &kDBPropertysKey, propertys, OBJC_ASSOCIATION_RETAIN);
}

+ (NSMutableArray *)propertys {
    return objc_getAssociatedObject(self, &kDBPropertysKey);
}

#pragma mark - Public Methods
/**
 *  遍历所有的成员
 */
+ (void)enumerateProperties:(DBPropertysEnumeration)enumeration
{
    // 获得成员变量
    NSArray *properties = [self properties];
    
    // 遍历成员变量
    BOOL stop = NO;
    for (DBProperty *property in properties) {
        enumeration(property, &stop);
        if (stop) break;
    }
}

/**
 *  成员变量转换成DBProperty数组
 */
+ (NSMutableArray *)properties
{
    NSMutableArray *cachedProperties = [DBPropertyCache objectForKey:NSStringFromClass(self) forDictId:&DBCachedPropertiesKey];
    
    if (cachedProperties == nil) {
        cachedProperties = [NSMutableArray array];
        
        [self enumerateClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            // 1.获得所有的成员变量
            unsigned int outCount = 0;
            objc_property_t *properties = class_copyPropertyList(c, &outCount);
            
            // 2.遍历每一个成员变量
            for (unsigned int i = 0; i<outCount; i++) {
                DBProperty *property = [DBProperty addProperty:properties[i]];
                // 过滤掉系统自动添加的元素
                if ([property.name isEqualToString:@"hash"]
                    || [property.name isEqualToString:@"superclass"]
                    || [property.name isEqualToString:@"description"]
                    || [property.name isEqualToString:@"debugDescription"]) {
                    continue;
                }
                
                [cachedProperties addObject:property];
            }
            
            // 3.释放内存
            free(properties);
        }];
        
        [DBPropertyCache setObject:cachedProperties forKey:NSStringFromClass(self) forDictId:&DBCachedPropertiesKey];
    }
    
    return cachedProperties;
}

@end

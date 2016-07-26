//
//  NSObject+ModelToDictionary.m
//  QQDBManager
//
//  Created by iprincewang on 16/7/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#if !__has_feature(objc_arc)
#error  does not support Objective-C Automatic Reference Counting (ARC)
#endif

#import "NSObject+ModelToDictionary.h"
#import "DBProperty.h"
#import "NSObject+DBPropertys.h"
#import "NSObject+DbObject.h"

@implementation NSObject (ModelToDictionary)

- (NSDictionary *)dictionaryValue
{
    
    if (self.class.propertys == nil) {
        [self.class loadProtypes];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[self.class.propertys count]];
    
    for (DBProperty *property in self.class.propertys) {
        NSString *key = property.name;
        id value = [self valueForKey:key];
        
        if (key && value) {
            if ([value isKindOfClass:[NSString class]]
                || [value isKindOfClass:[NSNumber class]]
                || [value isKindOfClass:[NSData class]]) {
                // 普通类型的直接变成字典的值
                [dict setObject:value forKey:key];
            }
            else if ([value isKindOfClass:[NSArray class]]
                     || [value isKindOfClass:[NSDictionary class]]) {
                // 数组类型或字典类型
                [dict setObject:[self idFromObject:value] forKey:key];
            }
            else {
                // 如果model里有其他自定义模型，则递归将其转换为字典
                value = [self.class valueForFileName:value];
                
                if ([value isKindOfClass:[NSString class]]
                    || [value isKindOfClass:[NSNumber class]]
                    || [value isKindOfClass:[NSData class]]) {
                    // 普通类型的直接变成字典的值
                    [dict setObject:value forKey:key];
                }
                else{
                   [dict setObject:[value dictionaryValue] forKey:key];
                }
                
            }
        } else if (key && value == nil) {
            // 如果当前对象该值为空，设为nil。在字典中直接加nil会抛异常，需要加NSNull对象
            [dict setObject:[NSNull null] forKey:key];
        }
    }
    
    return dict;
}

- (id)idFromObject:(nonnull id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        if (object != nil && [(NSArray*)object count] > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (id obj in object) {
                // 基本类型直接添加
                if ([obj isKindOfClass:[NSString class]]
                    || [obj isKindOfClass:[NSNumber class]]
                    || [obj isKindOfClass:[NSData class]]) {
                    [array addObject:obj];
                }
                // 字典或数组需递归处理
                else if ([obj isKindOfClass:[NSDictionary class]]
                         || [obj isKindOfClass:[NSArray class]]) {
                    [array addObject:[self idFromObject:obj]];
                }
                // model转化为字典
                else {
                    
                    id newObj = [self.class valueForFileName:obj];
                    
                    if ([newObj isKindOfClass:[NSString class]]
                        || [newObj isKindOfClass:[NSNumber class]]
                        || [newObj isKindOfClass:[NSData class]]) {
                        
                        [array addObject:newObj];
                    }
                    else{
                        [array addObject:[obj dictionaryValue]];
                    }
                }
            }
            return array;
        }
        else {
            return object ? : [NSNull null];
        }
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        if (object && [[(NSDictionary*)object allKeys] count] > 0) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSString *key in [(NSDictionary*)object allKeys]) {
                // 基本类型直接添加
                if ([object[key] isKindOfClass:[NSNumber class]]
                    || [object[key] isKindOfClass:[NSString class]]
                    || [object[key] isKindOfClass:[NSData class]]) {
                    [dic setObject:object[key] forKey:key];
                }
                // 字典或数组需递归处理
                else if ([object[key] isKindOfClass:[NSArray class]]
                         || [object[key] isKindOfClass:[NSDictionary class]]) {
                    [dic setObject:[self idFromObject:object[key]] forKey:key];
                }
                // model转化为字典
                else {
                    id newObj = [self.class valueForFileName:object[key]];
                    
                    if ([newObj isKindOfClass:[NSString class]]
                        || [newObj isKindOfClass:[NSNumber class]]
                        || [newObj isKindOfClass:[NSData class]]) {
                        
                        [dic setObject:newObj forKey:key];
                    }
                    else{
                        [dic setObject:[object[key] dictionaryValue] forKey:key];
                    }
                    
                    
                }
            }
            return dic;
        }
        else {
            return object ? : [NSNull null];
        }
    }
    
    return [NSNull null];
}

@end

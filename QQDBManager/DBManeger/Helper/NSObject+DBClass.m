//
//  NSObject+DBClass.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/6.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "NSObject+DBClass.h"
/** system */
#import <objc/runtime.h>

@implementation NSObject (DBClass)

#pragma mark - Public Methods

/** 只遍历当前的类 */
+ (void)enumerateClass:(DBClassesEnumeration)enumeration {
    
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        break;
    }
}

/** 遍历到NSObject */
+ (void)enumerateClasses:(DBClassesEnumeration)enumeration {
    [self enumerateClasses:enumeration superClass:[NSObject class]];
}

/** 遍历到superClass */
+ (void)enumerateClasses:(DBClassesEnumeration)enumeration superClass:(Class)superClass {
    
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
        
        if (c == superClass) break;
    }
}

+ (void)enumerateAllClasses:(DBClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
    }
}

@end

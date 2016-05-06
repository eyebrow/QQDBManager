//
//  NSObject+DBClass.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/6.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  遍历所有类的block（父类）
 */
typedef void (^DBClassesEnumeration)(Class c, BOOL *stop);

@interface NSObject (DBClass)

/** 只遍历当前的类 */
+ (void)enumerateClass:(DBClassesEnumeration)enumeration;

/** 遍历到NSObject */
+ (void)enumerateClasses:(DBClassesEnumeration)enumeration;

/** 遍历到superClass */
+ (void)enumerateClasses:(DBClassesEnumeration)enumeration superClass:(Class)superClass;

/** 遍历所有的类 */
+ (void)enumerateAllClasses:(DBClassesEnumeration)enumeration;

@end

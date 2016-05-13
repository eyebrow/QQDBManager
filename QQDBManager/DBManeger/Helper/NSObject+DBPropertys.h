//
//  NSObject+DBPropertys.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/6.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBProperty;

/**
*  遍历成员变量用的block
*
*  @param property 成员的包装对象
*  @param stop   YES代表停止遍历，NO代表继续遍历
*/
typedef void(^DBPropertysEnumeration)(DBProperty *property, BOOL *stop);

@interface NSObject (DBPropertys)

/**
 *  遍历所有的成员
 */
+ (void)enumerateProperties:(DBPropertysEnumeration)enumeration;

/**
 *  成员变量转换成JJFMDBProperty数组
 */
+ (NSMutableArray *)properties;


@end

//
//  NSObject+Search.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/17.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBDefine.h"

@interface NSObject (DBSearch)

/**
 *  返回所有的数据
 *
 *  @param block 返回结果,对应的models
 */
+ (void)searchAll:(DBResults)block;

/**
 *  返回所有的数据
 *
 *  @param where where条件,自定义,例where:@"rowid = 2"或者@"string = 'Jay'"
 *  @param block 返回结果,对应的models
 */
+ (void)searchAllWhere:(NSString *)where results:(DBResults)block;

@end

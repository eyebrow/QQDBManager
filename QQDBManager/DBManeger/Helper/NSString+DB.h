//
//  NSString+DB.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DB)

/**
 *  判断字符串是否为空
 *
 *  @return YES/NO
 */
- (BOOL)isEmptyWithTrim;

/**
 *  去掉空格
 *
 *  @return NSString
 */
- (NSString *)stringWithTrim;

@end

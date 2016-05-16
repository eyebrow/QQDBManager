//
//  NSString+DB.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "NSString+DBModel.h"

@implementation NSString (DBModel)

- (BOOL)isEmptyWithTrim
{
    return [[self stringWithTrim] isEqualToString:@""];
}

- (NSString *)stringWithTrim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end

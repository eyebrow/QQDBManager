//
//  NSDate+DB.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/16.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "NSDate+DBModel.h"

@implementation NSDate (DBModel)

+ (NSString *)stringWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *datestr = [formatter stringFromDate:date];
    return datestr;
}

+ (NSDate *)dateWithString:(NSString *)str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:str];
    return date;
}

@end

//
//  NSDate+DB.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/16.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DBModel)

+ (NSString *)stringWithDate:(NSDate *)date;

+ (NSDate *)dateWithString:(NSString *)str;

@end

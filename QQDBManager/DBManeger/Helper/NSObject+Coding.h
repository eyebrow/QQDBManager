//
//  NSObject+coder.h
//  QQDBManager
//
//  Created by iprincewang on 16/7/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Coding)<NSCoding>

- (void)encode:(NSCoder *)aCoder;
- (id)decode:(NSCoder *)aDecoder;

@end

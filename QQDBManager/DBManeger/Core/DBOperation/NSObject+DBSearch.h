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

+ (void)searchAll:(DBResults)block;

@end

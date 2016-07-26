//
//  NSObject+Copying.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/18.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Copying)<NSCopying>

-(id)copyWithModel:(id)model;

@end

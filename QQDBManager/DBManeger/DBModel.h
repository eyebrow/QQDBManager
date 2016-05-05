//
//  DBModel.h
//  QQDBManager
//
//  Created by iprincewang on 16/4/14.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBModel : NSObject

-(void)fetch;
-(void)insert;
-(void)update;
-(void)remove;

@end

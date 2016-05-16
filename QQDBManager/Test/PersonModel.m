//
//  PersonModel.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/5.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "PersonModel.h"
#import "DBModel.h"

@implementation PersonModel

+(const NSString *)DBtableName
{
    return @"PersonTable";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end

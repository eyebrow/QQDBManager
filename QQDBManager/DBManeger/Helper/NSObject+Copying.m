//
//  NSObject+Copying.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/18.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "NSObject+Copying.h"
#import "DBProperty.h"
#import "NSObject+DBPropertys.h"

@implementation NSObject (Copying)

-(id)copyWithZone:(NSZone *)zone
{
    id model = [[[self class] allocWithZone:zone] init];
    if (self.class.propertys == nil) {
        [self.class loadProtypes];
    }
    
    for (DBProperty *property in self.class.propertys) {
        id value = [self valueForKey:property.name];
        
        [model setValue:value forKey:property.name];
    }
    
    return model;
}

@end

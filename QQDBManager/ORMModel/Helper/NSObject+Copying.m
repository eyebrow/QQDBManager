//
//  NSObject+Copying.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/18.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#if !__has_feature(objc_arc)
#error  does not support Objective-C Automatic Reference Counting (ARC)
#endif

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

-(id)copyWithModel:(id)model
{
    if (self.class.propertys == nil) {
        [self.class loadProtypes];
    }
    
    for (DBProperty *property in self.class.propertys) {
        id value = [model valueForKey:property.name];
        
        [self setValue:value forKey:property.name];
    }
    
    return self;
}

@end

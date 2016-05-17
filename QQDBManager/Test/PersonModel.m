//
//  PersonModel.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/5.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "PersonModel.h"
#import "DBModel.h"
#import "DogModel.h"

@implementation PersonModel

-(id)copyWithZone:(NSZone *)zone
{
    PersonModel *result = [[[self class] allocWithZone:zone] init];
    
    //result. = [self->_obj copy];
    result.uin = self.uin;
    result.myDog = [self.myDog copy];
    result.name = self.name;
    result.age = self.age;
    result.age2 = self.age2;
    result.sex = self.sex;
    result.sex2 = self.sex2;
    result.birthDay = self.birthDay;
    result.height = self.height;
    result.stuff = self.stuff;
    
    return result;
}

+(NSString *)DBtableName
{
    return @"PersonTable";
}

+(NSString *)DBprimaryKey
{
    return @"uin";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end

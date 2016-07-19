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

//-(id)copyWithZone:(NSZone *)zone
//{
//    PersonModel *result = [[[self class] allocWithZone:zone] init];
//    
//    //result. = [self->_obj copy];
//    result.uin = self.uin;
//    
//    result.name = self.name;
//    result.age = self.age;
//
//    result.sex = self.sex;
//
//    result.height = self.height;
//
//    result.dog = [self.dog copy];
//    
//    result.books = [self.books copy];
//    
//    return result;
//}

+(NSString *)DBtableName
{
    return @"PersonTable";
}

+(NSString *)DBprimaryKey
{
    return @"uin";
}

+(NSDictionary *)DBArrayProperties
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [dict setValue:@"BookModel" forKey:@"books"];
    
    [dict setValue:@"NSString" forKey:@"stringList"];
    
    [dict setValue:@"NSNumber" forKey:@"numberList"];
    
    return dict;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end

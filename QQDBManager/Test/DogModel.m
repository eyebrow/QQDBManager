//
//  DogModel.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/5.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "DogModel.h"
#import "DBModel.h"

@implementation DogModel

//-(id)copyWithZone:(NSZone *)zone
//{
//    DogModel *result = [[[self class] allocWithZone:zone] init];
//    
//    //result. = [self->_obj copy];
//    result.number = self.number;
//    result.name = self.name;
//    result.age = self.age;
//    result.dna = self.dna;
//    
//    return result;
//}

+(NSString *)DBtableName
{
    return @"DogTable";
}

+(NSString *)DBprimaryKey
{
    return @"number";
}

//+(BOOL)DBNeedBeLinked
//{
//    return YES;
//}

@end

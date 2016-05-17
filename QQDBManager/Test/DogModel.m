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

+(NSDictionary *)DBBeLinkedProperties
{
    return nil;
}

@end

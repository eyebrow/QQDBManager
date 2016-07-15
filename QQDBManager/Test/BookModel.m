//
//  BookModel.m
//  QQDBManager
//
//  Created by iprincewang on 16/7/12.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "BookModel.h"
#import "DBModel.h"

@implementation BookModel

//-(id)copyWithZone:(NSZone *)zone
//{
//    BookModel *result = [[[self class] allocWithZone:zone] init];
//    result.bookId = self.bookId;
//    result.bookName = self.bookName;
//    result.price = self.price;
//    result.publisher = self.publisher;
//    
//    return result;
//}


+(NSString *)DBtableName
{
    return @"BookTable";
}

+(NSString *)DBprimaryKey
{
    return @"bookId";
}

+(BOOL)DBNeedBeLinked
{
    return YES;
}

@end

//
//  PersonModel.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/5.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DogModel.h"

@interface PersonModel : NSObject

@property (nonatomic, strong) DogModel *dog;

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL sex;
@property (nonatomic, strong) NSString *name1;
@property (nonatomic, assign) float height;
@property (nonatomic, strong) NSDate *birthDay;
@property (nonatomic, strong) NSData *stuff;
@property (nonatomic, strong) UIImage *faceImg;
@property (nonatomic, strong) UIColor *skinColor;

@property (nonatomic, strong) NSArray *nsarray;
@property (nonatomic, strong) NSMutableArray *mutableArray;

@property (nonatomic, strong) NSDictionary *nsdictionary;
@property (nonatomic, strong) NSSet *nsset;

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;


@end

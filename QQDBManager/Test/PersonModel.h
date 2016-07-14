//
//  PersonModel.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/5.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DogModel;
@interface PersonModel : NSObject<NSCopying>
@property (nonatomic, assign) uint64_t uin;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL sex;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) float height;
@property (nonatomic, strong) UIImage *image;


@property (nonatomic, strong) DogModel *dog;
@property (nonatomic ,strong) NSArray *books;
@end

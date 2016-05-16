//
//  PersonModel.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/5.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PersonModel : NSObject

//@property (nonatomic, strong) DogModel *dog;

@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSMutableString *nsmutableString;
//@property (nonatomic, strong) NSAttributedString *nsAttributedString;
//@property (nonatomic, strong) NSMutableAttributedString *nsmutableAttributedString;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSUInteger age2;
@property (nonatomic, assign) BOOL sex;
@property (nonatomic, assign) bool sex2;
@property (nonatomic, assign) float height;
@property (nonatomic, strong) NSDate *birthDay;
@property (nonatomic, strong) NSData *stuff;
//@property (nonatomic, strong) UIImage *faceImg;
//@property (nonatomic, strong) UIColor *skinColor;

//@property (nonatomic, strong) NSArray *nsarray;
//@property (nonatomic, strong) NSMutableArray *mutableArray;

//@property (nonatomic, strong) NSDictionary *nsdictionary;
//@property (nonatomic, strong) NSMutableDictionary *nsmutabledictionary;
//@property (nonatomic, strong) NSSet *nsset;
//@property (nonatomic, strong) NSMutableSet *nsmutableset;

//@property (nonatomic, strong) NSString *key;
//@property (nonatomic, strong) NSString *value;


@end

//
//  QQDBProperty.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/6.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>
/** system */
#import <objc/runtime.h>

@interface DBProperty : NSObject
/** 成员属性 */
@property (nonatomic, assign) objc_property_t property;

/** 成员属性的名字 例:@"name",@"age",@"height" */
@property (nonatomic, strong) NSString *name;

/** 原始的类型 例:@"long long" */
@property (nonatomic, readonly) NSString *orignType;

/** 转换成数据库的类型 例:@"TEXT" */
@property (nonatomic, readonly) NSString *dbType;

/** 是否是扩展属性 */
@property (nonatomic, assign) BOOL expand;
/** 扩展属性的类型 */
@property (nonatomic, strong) NSString *expandType;

/** 扩展属性的名字 */
@property (nonatomic, strong) NSString *expandName;

/** 是否是链接属性 */
@property (nonatomic, readonly) BOOL link;

/** 链接属性的类型 */
@property (nonatomic, readonly) NSString *linkType;

/** 链接属性的名字 */
@property (nonatomic, readonly) NSString *linkName;
#pragma mark - Public Methods

/** 初始化 */
+ (instancetype)addProperty:(objc_property_t)property;

@end

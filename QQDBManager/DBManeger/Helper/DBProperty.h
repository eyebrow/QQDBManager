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

typedef enum{
    RelationType_default,
    RelationType_link,
    RelationType_expand,
    
}RelationType;

@interface DBProperty : NSObject
/** 成员属性 */
@property (nonatomic, assign) objc_property_t property;

/** 成员属性的名字 例:@"name",@"age",@"height" */
@property (nonatomic, readonly) NSString *name;

/** 原始的类型 例:@"long long" */
@property (nonatomic, readonly) NSString *orignType;

/** 转换成数据库的类型 例:@"TEXT" */
@property (nonatomic, readonly) NSString *dbType;

@property (nonatomic, readonly)RelationType relationType;
@property (nonatomic, readonly) NSArray<DBProperty *> *relationProperty;

#pragma mark - Public Methods

/** 初始化 */
+ (instancetype)addProperty:(objc_property_t)property;

@end

//
//  NSObject+coder.m
//  QQDBManager
//
//  Created by iprincewang on 16/7/13.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "NSObject+Coding.h"
#import "DBProperty.h"
#import "NSObject+DBPropertys.h"

@implementation NSObject (Coding)

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self decode:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self encode:aCoder];
}

// 解档方法
- (id)decode:(NSCoder *)aDecoder {
    
    if (self) {
        if (self.class.propertys == nil) {
            [self.class loadProtypes];
        }
        
        for (DBProperty *property in self.class.propertys) {
            // 根据变量名解档取值，无论是什么类型
            id value = [aDecoder decodeObjectForKey:property.name];
            // 取出的值再设置给属性
            [self setValue:value forKey:property.name];
        }
    }

    return self;
}

// 归档调用方法
- (void)encode:(NSCoder *)aCoder {

    if (self.class.propertys == nil) {
        [self.class loadProtypes];
    }
    
    for (DBProperty *property in self.class.propertys) {
        // 通过成员变量名，取出成员变量的值
        id value = [self valueForKeyPath:property.name];
        // 再将值归档
        [aCoder encodeObject:value forKey:property.name];
    }
}
@end

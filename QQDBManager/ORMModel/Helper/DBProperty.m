
//  QQDBProperty.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/6.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#if !__has_feature(objc_arc)
#error  does not support Objective-C Automatic Reference Counting (ARC)
#endif

#import "DBProperty.h"
#import "DBDefine.h"
#import "NSObject+DBProtocol.h"
#import "NSObject+DBPropertys.h"

@implementation DBProperty

+ (instancetype)addProperty:(objc_property_t)property
{
    DBProperty *propertyObj = objc_getAssociatedObject(self, property);
    if (propertyObj == nil) {
        propertyObj = [[self alloc] init];
        propertyObj.property = property;
        objc_setAssociatedObject(self, property, propertyObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return propertyObj;
}

#pragma mark - Private Methods
/**
 propertyType = T@"NSString",&,N,V_pString    --> NSString //@ id 指针 对象
 propertyType = T@"NSNumber",&,N,V_pNumber    --> NSNumber
 propertyType = Ti,N,V_pInteger               --> long long
 propertyType = Ti,N,V_pint                  --> long long
 propertyType = Tq,N,V_plonglong             --> long long
 propertyType = Tc,N,V_pchar                 --> char
 propertyType = Tc,N,V_pBool                 --> char
 propertyType = Ts,N,V_pshort                --> short
 propertyType = Tf,N,V_pfloat                --> float
 propertyType = Tf,N,V_pCGFloat              --> float
 propertyType = Td,N,V_pdouble               --> double
 
 .... ^i 表示  int*  一般都不会用到
 *
 *  @param protypes 转换后存到protypes数组中
 *  @param property 属性
 */

- (NSString *)convertToType:(objc_property_t)property {
    
    NSString *attributes = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
    
    NSString *type = nil;
    if ([attributes hasPrefix:@"T@"]) {
        type = [attributes substringWithRange:NSMakeRange(3, [attributes rangeOfString:@","].location-4)];
    }
    else if ([attributes hasPrefix:@"Ti"] || [attributes hasPrefix:@"TQ"] || [attributes hasPrefix:@"Tq"]) {
        type = @"long long";
    }
    else if ([attributes hasPrefix:@"Tf"]) {
        type = @"float";
    }
    else if([attributes hasPrefix:@"Td"]) {
        type = @"double";
    }
    else if([attributes hasPrefix:@"Tl"]) {
        type = @"long";
    }
    else if ([attributes hasPrefix:@"Tc"]) {
        type = @"char";
    }
    else if([attributes hasPrefix:@"Ts"]) {
        type = @"short";
    }
    else if([attributes hasPrefix:@"TB"] || [attributes hasPrefix:@"Tb"]) {
        type = @"BOOL";
    }
    else {
        type = @"NSString";
    }
    return [type copy];
}


/**
 *  把Model的属性类型转换成数据库的类型
 *
 *  @param type type
 *
 *  @return DB_SQLXXX
 */
- (NSString *)convertToDBType:(NSString *)type
{
    if ([type isEqualToString:@"NSString"] ||
        [type isEqualToString:@"NSMutableString"]  ||
        [type isEqualToString:@"NSDate"]) {
        return DB_SQL_TEXT;
    }
    else if ([type isEqualToString:@"char"] ||
             [type isEqualToString:@"short"] ||
             [type isEqualToString:@"int"] ||
             [type isEqualToString:@"long"]) {
        return DB_SQL_INTEGER;
    }
    else if ([type isEqualToString:@"float"] ||
             [type isEqualToString:@"double"]){
        return DB_SQL_FLOAT;
    }
    else if ([type isEqualToString:@"long long"]) {
        return DB_SQL_BIGINT;
    }
    else if ([type isEqualToString:@"NSData"] ||
             [type isEqualToString:@"UIImage"]) {
        return DB_SQL_TEXT;
    }
    else if ([type isEqualToString:@"NSArray"] ||
             [type isEqualToString:@"NSMutableArray"]) {
        return DB_SQL_BLOB;
    }
    else if ([type isEqualToString:@"NSDictionary"] ||
             [type isEqualToString:@"NSMutableDictionary"] ||
             [type isEqualToString:@"NSSet"] ||
             [type isEqualToString:@"NSMutableSet"]) {
        return DB_SQL_BLOB;
    }
    else if([type isEqualToString:@"BOOL"]){
        return DB_SQL_BOOLEAN;
    }
    else if (NSClassFromString(_orignType)){
        return DB_SQL_EXPAND;
    }
    
    return DB_SQL_TEXT;
}

#pragma mark - Property

- (void)setProperty:(objc_property_t)property
{
    _property = property;
    _name = @(property_getName(property));
    _orignType = [self convertToType:property];
    _dbType = [self convertToDBType:_orignType];
    
    if ([_orignType isEqualToString:@"NSArray"] || [_orignType isEqualToString:@"NSMutableArray"]) {
        _relationType = RelationType_array;

    }
    else if ([_dbType isEqualToString:DB_SQL_EXPAND]) {
        
        
        [NSClassFromString(_orignType) loadProtypes];
        _relationProperty =  NSClassFromString(_orignType).propertys;
        
        if ([NSClassFromString(_orignType) ORMDBNeedBeLinked]) {
            
            _relationType = RelationType_link;
        }
        else{
            _relationType = RelationType_expand;
            _dbType = DB_SQL_BLOB;
        }
    }
}

//返回当前类的所有属性
+ (objc_property_t)getPrimeKeyProperty:(NSString *)clsStr{
    
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList(NSClassFromString(clsStr), &count);
    // 遍历
    for (int i = 0; i < count; i++) {
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        if ([name isEqualToString:[NSClassFromString(clsStr) ORMDBprimaryKey]]) {
            return property;
        }
    }
    
    return nil;
}

@end

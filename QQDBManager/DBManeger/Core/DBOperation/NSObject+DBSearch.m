//
//  NSObject+Search.m
//  QQDBManager
//
//  Created by iprincewang on 16/5/17.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "NSObject+DBSearch.h"
#import "NSObject+DBProtocol.h"
#import "NSString+DBModel.h"
#import <FMDB/FMDB.h>
#import "DBProperty.h"
#import "DBDatabaseQueue.h"
#import "NSObject+DbObject.h"
#import "NSObject+DBPropertys.h"

@implementation NSObject (DBSearch)

#pragma mark Search All
+ (void)searchAll:(DBResults)block {
    [self searchWhere:nil orderBy:nil offset:0 count:0 results:block];
}

+ (void)searchAllWhere:(NSString *)where results:(DBResults)block {
    [self searchWhere:where orderBy:nil offset:0 count:0 results:block];
}

+ (void)searchWhere:(NSString *)where orderBy:(NSString *)orderBy offset:(int)offset count:(int)count results:(DBResults)block
{
    [self.dbQueue inDatabaseAsync:^(FMDatabase *db) {
        
        NSMutableString *searchSQL = [NSMutableString stringWithFormat:@"SELECT * FROM %@ ", self.DBtableName];
        if (where != nil && ![where isEmptyWithTrim]) {
            [searchSQL appendFormat:@"WHERE %@ ",where];
        }
        [self SQLString:searchSQL AddOder:orderBy offset:offset count:count];
        FMResultSet *set =[db executeQuery:searchSQL];
        
        [self executeResult:set block:block];
    }];
}


#pragma mark - Search

+ (void)executeResult:(FMResultSet *)set block:(DBResults)block {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    while ([set next]) {
        NSObject *model = [[self alloc] init];
        model.rowid = [set intForColumnIndex:0];
        for (int i=0; i<self.propertys.count; i++) {
            DBProperty *property = [self.propertys objectAtIndex:i];
            
            if (property.relationType == RelationType_link) {
                id relationClass = NSClassFromString(property.orignType);
                NSString *primeKey = [relationClass DBprimaryKey];
                id relationModel = [model valueForKey:property.name];
                [self setValueWithModel:relationModel set:set columeName:primeKey columeType:property.orignType];//先设置主键的值
                
                [self executeRelationShipTableSearch:relationModel];
            }
            else if (property.relationType == RelationType_expand){
                
            }
            else{
               [self setValueWithModel:model set:set columeName:property.name columeType:property.orignType];
            }
            
        }
        [array addObject:model];
    }
    [set close];
    
    if (block) {
        block(array);
    }
}

+ (void)executeRelationShipTableSearch:(NSObject *)model
{
    NSString *where = [NSString stringWithFormat:@"%@='%@'", [model.class DBprimaryKey],[model valueForKey:[model.class DBprimaryKey]]];
    [model.class searchAllWhere:where results:^(NSArray *results) {
        
    }];
}

/**
 *  拼接SQL语句的条件,例:@"ORDER BY %@ LIMIT %d OFFSET %d "
 *
 *  @param SQL     SQL
 *  @param orderby orderby
 *  @param offset  offset
 *  @param count   count
 */
+ (void)SQLString:(NSMutableString *)SQL AddOder:(NSString *)orderby offset:(int)offset count:(int)count
{
    if (!SQL || !count) {
        return ;
    }
    
    if (orderby != nil && ![orderby isEmptyWithTrim]) {
        [SQL appendFormat:@"ORDER BY %@ ",orderby];
    }
    [SQL appendFormat:@"LIMIT %d OFFSET %d ",count, offset];
}

@end

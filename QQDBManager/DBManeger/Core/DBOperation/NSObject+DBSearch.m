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
#import "FMDatabaseQueue.h"

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
    
    NSArray *array = [self executeResult:set];
    
    if (block) {
        block(array);
    }
}

+ (NSArray *)executeResult:(FMResultSet *)set{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    while ([set next]) {
        NSObject *model = [[self alloc] init];
        model.rowid = [set intForColumnIndex:0];
        if (self.propertys == nil) {
            [self loadProtypes];
        }
        
        for (int i=0; i<self.propertys.count; i++) {
            DBProperty *property = [self.propertys objectAtIndex:i];
            
            if (property.relationType == RelationType_array){
                
                [self setValueWithModel:model set:set columeName:property.name propertyName:property.name columeType:property.orignType];
                
                NSString *itemType = [[model.class DBArrayProperties] objectForKey:property.name];
                id relationClass = NSClassFromString(itemType);
                
                if ([relationClass DBNeedBeLinked]){
                    NSArray *tmpList = [model valueForKey:property.name];
                    
                    if (tmpList && [tmpList count] > 0) {
                        NSMutableArray *itemList = [[NSMutableArray alloc]initWithCapacity:[tmpList count]];
                        NSString *primeKey = [relationClass DBprimaryKey];
                        
                        for (id item in tmpList) {
                            id itemModel = [relationClass new];
                            [itemModel setValue:item forKey:primeKey];
                            
                            itemModel = [self executeRelationShipTableSearch:itemModel];
                            
                            [itemList addObject:itemModel];
                        }
                        
                        [model setValue:itemList forKey:property.name];
                    }
                    
                }
            }
            else if (property.relationType == RelationType_link) {
                id relationClass = NSClassFromString(property.orignType);
                NSString *primeKey = [relationClass DBprimaryKey];
                NSObject *relationModel = [model valueForKey:property.name];
                
                DBProperty *relationProperty = nil;
                if (primeKey) {
                    for (DBProperty *rProperty in property.relationProperty){
                        if ([rProperty.name isEqualToString:primeKey]) {
                            relationProperty = rProperty;
                            break;
                        }
                    }
                }
                
                if (relationProperty) {
                    
                    if (relationModel == nil) {
                        relationModel = [[NSClassFromString(property.orignType) alloc] init];
                    }
                    NSString *name = [NSString stringWithFormat:@"%@%@",property.name,primeKey];
                    [self setValueWithModel:relationModel set:set columeName:name propertyName:relationProperty.name columeType:relationProperty.orignType];//先设置主键的值
                }
                
                relationModel = [self executeRelationShipTableSearch:relationModel];
                
                [model setValue:relationModel forKey:property.name];
            }
            else if (property.relationType == RelationType_expand){

                NSData *data = [set dataForColumn:property.name];
                
                id relationModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                
                [model setValue:relationModel forKey:property.name];
                
                /*
                NSObject *relationModel = [model valueForKey:property.name];
                if (relationModel == nil) {
                    relationModel = [[NSClassFromString(property.orignType) alloc] init];
                }
                
                for (DBProperty *relationProperty in property.relationProperty){
                    NSString *name = [NSString stringWithFormat:@"%@%@",property.name,relationProperty.name];
                    
                    [self setValueWithModel:relationModel set:set columeName:name propertyName:relationProperty.name columeType:relationProperty.orignType];
                }
                
                [model setValue:relationModel forKey:property.name];
                 */
            }
            else{
                [self setValueWithModel:model set:set columeName:property.name propertyName:property.name columeType:property.orignType];
            }
            
        }
        [array addObject:model];
    }
    [set close];
    
    return array;

}

+ (id)executeRelationShipTableSearch:(NSObject *)model
{
    NSString *where = [NSString stringWithFormat:@"%@='%@'", [model.class DBprimaryKey],[model valueForKey:[model.class DBprimaryKey]]];
    
    NSMutableString *searchSQL = [NSMutableString stringWithFormat:@"SELECT * FROM %@ ", model.class.DBtableName];
    if (where != nil && ![where isEmptyWithTrim]) {
        [searchSQL appendFormat:@"WHERE %@ ",where];
    }
    [model.class SQLString:searchSQL AddOder:nil offset:0 count:0];
    
    FMDatabase *db = self.dbQueue.database;
    FMResultSet *set =[db executeQuery:searchSQL];
    
    NSArray *array = [model.class executeResult:set];
    
    if (array && array.count > 0) {
        return [array firstObject];
    }
    return nil;
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

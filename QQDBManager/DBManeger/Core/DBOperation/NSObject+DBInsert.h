//
//  NSObject+DBInsert.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/16.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBDefine.h"

@interface NSObject (DBInsert)

#pragma mark - Insert

/**
 *  把model直接插入到数据库
 *
 *  @param model model
 *  @param block block
 */
- (void)insertToDB:(DBSuccess)block;

/**
 *  把model插入到数据库,如果存在(用primaryKey来判断),就更新(通过rowid或者primarykey来更新)
 *
 *  @param model model
 *  @param block block
 */
- (void)insertUpdateToDB:(DBSuccess)block;

@end

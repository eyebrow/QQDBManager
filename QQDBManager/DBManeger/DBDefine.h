//
//  QQDBDefine.h
//  QQDBManager
//
//  Created by iprincewang on 16/5/6.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#ifndef DBDefine_h
#define DBDefine_h

/** 查询数据库一页能查询到的个数 */
#define DB_SEARCH_COUNT 10

/** 数据库的数据类型 */
#define DB_SQL_TEXT @"TEXT"
#define DB_SQL_INTEGER @"INTEGER"
#define DB_SQL_BIGINT @"BIGINT"
#define DB_SQL_FLOAT @"DECIMAL"    /** DECIMAL/FLOAT/REAL */
#define DB_SQL_BLOB @"BLOB"
#define DB_SQL_BOOLEAN @"BOOLEAN"
#define DB_SQL_EXPAND @"EXPAND"
#define DB_SQL_ARRAY @"ARRAY"
#define DB_SQL_NULL @"NULL"
#define DB_SQL_INTEGER_PRIMARY_KEY @"INTEGER PRIMARY KEY"

typedef void(^DBResults)(NSArray *results);
typedef void(^DBSuccess)(BOOL isSuccess);
typedef void(^DBCount)(int count);

#endif /* QQDBDefine_h */

//
//  BookModel.h
//  QQDBManager
//
//  Created by iprincewang on 16/7/12.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BookModel : NSObject <NSCoding>

@property (nonatomic,assign)uint64_t bookId;
@property (nonatomic,copy) NSString *bookName;
@property (nonatomic,assign)double price;
@property (nonatomic,copy) NSString *publisher;
@property (nonatomic, strong) UIImage *image;
@end

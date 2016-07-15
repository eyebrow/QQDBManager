//
//  ViewController.m
//  QQDBManager
//
//  Created by iprincewang on 16/4/14.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "PersonModel.h"
#import "DBManeger/DBModel.h"

#import "DogModel.h"
#import "BookModel.h"

@interface ViewController ()

@property(nonatomic,strong)IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self testInsert];
    //[self testSearch];
    
    _textView.text = @"测试数据:";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)clickedInset
{
    [self testInsert];
}

-(IBAction)clickedSearch
{
    [self testSearch];
}

-(void)testInsert
{
    NSLog(@".....");
    
    PersonModel *model = [PersonModel new];
    model.uin = arc4random() % 1000;
    model.name = @"prince";
    model.age = 20;
    model.sex = YES;
    model.height = 180;
    NSString *str = @"hello world";
    model.data = [NSData dataWithBytes:str.UTF8String length:str.length];
    model.image = [UIImage imageNamed:@"2.jpg"];
    
    NSMutableArray *bookList = [NSMutableArray new];
    for (int i = 0; i < 5; i++) {
        BookModel *bmodel = [BookModel new];
        bmodel.bookId = arc4random() % 10000 + i;
        bmodel.bookName = [NSString stringWithFormat:@"book-%zd",i];
        bmodel.price = 99.90;
        bmodel.publisher = @"prince-w";
        bmodel.image = [UIImage imageNamed:@"2.jpg"];
        
        [bookList addObject:bmodel];
    }
    
    DogModel *dog = nil;
    
    model.books = [bookList copy];
    
    for (int i = 0; i < 20; i++) {
        
        dog = [DogModel new];
        dog.number = arc4random() % 10000;
        dog.name = @"dog2";
        dog.age = 111;
        
        [[dog copy] insertToDB:^(BOOL isSuccess) {
            
            if (isSuccess) {
                NSLog(@"insertToDB isSuccess");
            }
            else {
                NSLog(@"insertToDB failed");
            }
        }];
    }
    
    model.dog = dog;
    
    _textView.text = [NSString stringWithFormat:@"%@\n\n 插入一条数据...\n\n%@",_textView.text,[model dictionaryValue]];
    [_textView scrollRangeToVisible:NSMakeRange(_textView.text.length, 1)];
    
    [[model copy] insertToDB:^(BOOL isSuccess) {
        
        if (isSuccess) {
            NSLog(@"insertToDB isSuccess");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                _textView.text = [NSString stringWithFormat:@"%@\n 插入成功...",_textView.text];
                [_textView scrollRangeToVisible:NSMakeRange(_textView.text.length, 1)];
            });
            
        }
        else {
            NSLog(@"insertToDB failed");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                _textView.text = [NSString stringWithFormat:@"%@\n 插入失败...",_textView.text];
                [_textView scrollRangeToVisible:NSMakeRange(_textView.text.length, 1)];
            });
        }
        
    }];
    
    
//    [dog insertToDB:^(BOOL isSuccess) {
//       
//        if (isSuccess) {
//            NSLog(@"insertToDB isSuccess");
//        }
//        else {
//            NSLog(@"insertToDB failed");
//        }
//        
//    }];
    

}

-(void)testSearch
{
    [PersonModel searchAll:^(NSArray *results) {
        
        NSArray *tmpArry = [results copy];
        
        for (PersonModel *model in tmpArry) {
            NSLog(@"model... :%@",model);
            
            NSDictionary *dict = [model dictionaryValue];
            
            NSLog(@"dict... :%@",dict);
        }
    }];
}

@end

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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self testInsert];
    [self testSearch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)testInsert
{
    
//    PersonModel *model = [PersonModel new];
//    model.uin = arc4random() % 1000;
//    model.name = @"prince";
//    model.age = 20;
//    model.sex = YES;
//    model.height = 180;
//    model.birthDay = [NSDate date];
//    NSString *str = @"王子的奋斗奋斗的风格";
//    model.stuff = [NSData dataWithBytes:str.UTF8String length:str.length];
//    model.faceImg = nil;
//    model.skinColor = [UIColor blueColor];
    
    //NSMutableArray *list = [model.class properties];
    
//    [model insertToDB:^(BOOL isSuccess) {
//        
//        if (isSuccess) {
//            NSLog(@"insertToDB isSuccess");
//        }
//        else {
//            NSLog(@"insertToDB failed");
//        }
//        
//    }];
    
    NSLog(@".....");
    
    PersonModel *model = [PersonModel new];
    model.uin = arc4random() % 1000;
    model.name = @"prince";
    model.age = 20;
    model.sex = YES;
    model.height = 180;
    model.image = [UIImage imageNamed:@"2.jpg"];
    
    NSMutableArray *bookList = [NSMutableArray new];
    for (int i = 0; i < 5; i++) {
        BookModel *bmodel = [BookModel new];
        bmodel.bookId = i;
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
        dog.number = arc4random() % 100;
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
    
    [[model copy] insertToDB:^(BOOL isSuccess) {
        
        if (isSuccess) {
            NSLog(@"insertToDB isSuccess");
        }
        else {
            NSLog(@"insertToDB failed");
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

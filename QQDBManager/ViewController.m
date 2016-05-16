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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)testCode
{
    
    PersonModel *model = [PersonModel new];
    model.uin = 2015885903;
    model.name = @"prince";
    model.age = 20;
    model.sex = YES;
    model.height = 180;
    model.birthDay = [NSDate date];
    NSString *str = @"王子的奋斗奋斗的风格";
    model.stuff = [NSData dataWithBytes:str.UTF8String length:str.length];
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
    
    DogModel *dog = [DogModel new];
    dog.number = arc4random() % 100;;
    dog.name = @"dog2";
    dog.age = 111;
    
    model.myDog = nil;//dog;
    
    [model insertToDB:^(BOOL isSuccess) {
        
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

@end

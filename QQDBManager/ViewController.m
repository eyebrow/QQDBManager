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
    unsigned int outCount;
    objc_property_t *propList = class_copyPropertyList([PersonModel class], &outCount);
    
    for (int i=0; i < outCount; i++)
    {
        objc_property_t oneProp = propList[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(oneProp)];
        NSString *attrs = [NSString stringWithUTF8String: property_getAttributes(oneProp)];
        // Read only attributes are assumed to be derived or calculated
        // See http://developer.apple.com/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/chapter_8_section_3.html
        if ([attrs rangeOfString:@",R,"].location == NSNotFound)
        {
            NSArray *attrParts = [attrs componentsSeparatedByString:@","];
            if (attrParts != nil)
            {
                if ([attrParts count] > 0)
                {
                    NSString *propType = [[attrParts objectAtIndex:0] substringFromIndex:1];
                    //[theProps setObject:propType forKey:propName];
                    
                    NSLog(@"...");
                }
            }
        }
    }

}

@end

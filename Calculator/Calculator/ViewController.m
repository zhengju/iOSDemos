//
//  ViewController.m
//  Calculator
//
//  Created by zhengju on 2020/1/8.
//  Copyright © 2020 zhengju. All rights reserved.
//

#import "ViewController.h"

#import "Factory.h"

#import "Operation.h"

@interface ViewController ()

@end

@implementation ViewController
/**
 设计一个计算器
 1.符合开闭原则：对扩展开放，对修改关闭
 2.易扩展：只需要继承父类，增加操作即可
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    Factory * factory = [Factory initWithName:@"Sub"];//新增或修改操作 只需要修改字符串即可。
    
    Operation * operation = [factory createOperation];
    
    NSInteger count = [operation resultWithNum1:2 andNum2:5];

    NSLog(@"result is %ld",(long)count);

}


@end

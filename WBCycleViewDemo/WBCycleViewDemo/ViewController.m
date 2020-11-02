//
//  ViewController.m
//  WBCycleViewDemo
//
//  Created by zhengsw on 2020/10/26.
//

#import "ViewController.h"
#import "MyCycleView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        NSArray *datas = @[@{@"url":@"icon1",@"title":@"名称icon0"},
                           @{@"url":@"icon2",@"title":@"名称icon1"},
                           @{@"url":@"icon3",@"title":@"名称icon2"},
                           @{@"url":@"icon4",@"title":@"名称icon3"},];
    
    MyCycleView * cycleView = [[MyCycleView alloc]initWithFrame:CGRectMake(50, 100, 120, 150)];
    cycleView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:cycleView];
    [cycleView configWithdate:datas];
}

@end

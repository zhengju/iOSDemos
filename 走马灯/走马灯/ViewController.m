//
//  ViewController.m
//  走马灯
//
//  Created by 58 on 2022/5/6.
//

#import "ViewController.h"
#import "CircelView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CircelView *circleView = [[CircelView alloc]initWithFrame:CGRectMake(100, 100, 200, 300)];
    [self.view addSubview:circleView];
}


@end

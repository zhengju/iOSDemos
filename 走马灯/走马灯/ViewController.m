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
//    CircelView *circleView = [[CircelView alloc]initWithFrame:CGRectMake(100, 100, 200, 300)];
//    [self.view addSubview:circleView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(test) name:@"zsw" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(test) name:@"zsw" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"zsw" object:nil];
    
}
- (void)test {
    NSLog(@"哈哈哈");
}

@end

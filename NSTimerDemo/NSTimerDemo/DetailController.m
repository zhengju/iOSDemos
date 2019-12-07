//
//  DetailController.m
//  NSTimerDemo
//
//  Created by leeco on 2019/4/3.
//  Copyright © 2019年 zsw. All rights reserved.
//

#import "DetailController.h"
#import "DetailView.h"
#import "JTimer.h"
#import "ZJWeakProxy.h"

@interface DetailController ()
@property(nonatomic, strong) NSTimer * timer;

@property(nonatomic, strong) DetailView * detailView;
@property(strong,nonatomic) JTimer  * jTimer;
@end

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];

    
    self.jTimer = [[JTimer alloc]initWithTarget:self block:^{
        NSLog(@"timer 哈哈");
    }];
    
    /**
     self.detailView = [[DetailView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
     self.detailView.backgroundColor = [UIColor blackColor];
     [self.view addSubview:self.detailView];
     */
    
//    self.timer = [NSTimer timerWithTimeInterval:1 target:[ZJWeakProxy proxyWithTarget:self] selector:@selector(run) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];

}
- (void)run{
     NSLog(@"timer run --- %@ ",[NSThread currentThread]);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{

    [self.detailView.timer invalidate];

    NSLog(@"detailController dealloc");

}

@end

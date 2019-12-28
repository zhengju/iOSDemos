//
//  TaskController.m
//  BigAPP
//
//  Created by zhengju on 2019/12/26.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import "TaskController.h"
#import "TaskManager.h"

#import "TaskProtocol.h"

@interface TaskController ()

@end

@implementation TaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray * views = [[TaskManager shareManager] modules];
    
    for (int i = 0; i< views.count; i++) {
        UIView * view = [views objectAtIndex:i];
        view.frame = CGRectMake(0, i*40+88, 100, 40);
        [self.view addSubview:view];
    }
    
    
    dispatch_group_t  group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create(0, 0);
    
    //刷新数据
    //所有数据返回之后再刷新UI
    for (UIView<TaskProtocol> * view in views) {
        dispatch_group_enter(group);
        [view dataWith:^(NSString *str) {
            NSLog(@"这是返回的数据 %@  %@",str,[NSThread currentThread]);
            dispatch_group_leave(group);
            
        }];
        
        [view reloadDatas];
    }
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"所有数据回来之后 刷新UI");
    });
    NSLog(@"来了。。。。。");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end

//
//  DetailController.m
//  NSTimerDemo
//
//  Created by leeco on 2019/4/3.
//  Copyright © 2019年 zsw. All rights reserved.
//

#import "DetailController.h"
#import "ZJHttpManager.h"

@interface DetailController ()

@property(nonatomic, strong) ZJHttpManager * detailView;

@property(nonatomic, strong) NSString * name;

@end

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];

    __weak typeof(self) weakSelf = self;
    
    [ZJHttpManager requestName:^(NSString * _Nonnull name) {

        
        weakSelf.name = name;
        
        NSLog(@"name is %@",name);
        
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{

    NSLog(@"dealloc---");

}

@end

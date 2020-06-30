//
//  ViewController.m
//  SpringBox
//
//  Created by zhengsw on 2020/6/18.
//  Copyright © 2020 58. All rights reserved.
//

#import "ViewController.h"
#import "AlertManager.h"
#import "SecondController.h"
@interface ViewController ()
@property (nonatomic,strong) AlertManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [AlertManager shareManager];

    self.view.backgroundColor = [UIColor greenColor];
 
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SecondController * vc = [[SecondController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

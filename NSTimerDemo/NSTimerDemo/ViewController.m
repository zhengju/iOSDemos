//
//  ViewController.m
//  NSTimerDemo
//
//  Created by leeco on 2019/4/3.
//  Copyright © 2019年 zsw. All rights reserved.
//

#import "ViewController.h"
#import "DetailController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        DetailController * controller = [[DetailController alloc]init];
        [self presentViewController:controller animated:YES completion:nil];
}

@end

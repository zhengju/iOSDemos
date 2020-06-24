//
//  ViewController.m
//  SpringBox
//
//  Created by zhengsw on 2020/6/18.
//  Copyright © 2020 58. All rights reserved.
//

#import "ViewController.h"
#import "SpringBoxManager.h"
@interface ViewController ()
@property (nonatomic,strong) SpringBoxManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [SpringBoxManager shareManager];

    self.view.backgroundColor = [UIColor greenColor];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self.manager alertShowWithType:@"1"];
//        });
//        
//    });
   
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.manager alertShowWithType:@"2"];
        });
    });
    
}


@end

//
//  ViewController.m
//  LearnGPUImage
//
//  Created by leeco on 2019/4/26.
//  Copyright © 2019 zsw. All rights reserved.
//

#import "ViewController.h"

#import "CameraViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#define MaxRow (1)
#define MaxColumn (2)

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    CameraViewController *imagePicker = [[CameraViewController alloc] init];
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePicker];
    
    
    [self presentViewController:navigationController animated:YES completion:nil];
}



@end

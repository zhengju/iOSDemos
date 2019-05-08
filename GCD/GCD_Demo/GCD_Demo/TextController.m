//
//  TextController.m
//  GCD_Demo
//
//  Created by leeco on 2019/2/27.
//  Copyright © 2019年 zsw. All rights reserved.
//

#import "TextController.h"

@interface TextController ()

@end

@implementation TextController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"str":@"xiaoming"}];
    [dic valueForKey:@""];
    [dic setValue:@"小米" forKey:@"name"];
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

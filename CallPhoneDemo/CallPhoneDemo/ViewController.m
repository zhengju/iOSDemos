//
//  ViewController.m
//  CallPhoneDemo
//
//  Created by zhengju on 2019/3/30.
//  Copyright © 2019年 zhengju. All rights reserved.
//https://www.jianshu.com/p/589609124c97

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

/**
 iOS 8 :有弹框提示，点击确定，拨打电话(iOS 8.3下测试)
 iOS 11 :有弹框提示，点击确定，拨打电话(iOS 11.3.1下测试)
 iOS 12 :有弹框提示，点击确定，拨打电话(iOS 12.0下测试)
 iOS 13 :有弹框提示，点击确定，拨打电话(iOS 13.0下测试)
 @param sender sender
 */
- (IBAction)uRLRequesCallPhone:(UIButton *)sender {
    
    NSMutableString * callPhone=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"10086"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callPhone]]];
    [self.view addSubview:callWebview];
    
}

/**
 iOS 8 :有弹框提示，点击确定，拨打电话(iOS 8.3下测试)
 iOS 11 :有弹框提示，点击确定，拨打电话(iOS 11.3.1下测试)
 iOS 12 :有弹框提示，点击确定，拨打电话(iOS 12.0下测试)
 iOS 13 :有弹框提示，点击确定，拨打电话(iOS 13.0下测试)
 @param sender sender
 */
- (IBAction)uRLTelprompCallPbone:(UIButton *)sender {
    
    NSString * callPhone = [NSString stringWithFormat:@"telprompt://%@", @"10086"];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
    
}

/**
 iOS 8:未弹框提示，直接拨打电话(iOS 8.3下测试)
 iOS 11:有弹框提示，点击确定，拨打电话(iOS 11.3.1下测试)
 iOS 12:有弹框提示，点击确定，拨打电话(iOS 12.0下测试)
 iOS 13:有弹框提示，点击确定，拨打电话(iOS 13.0下测试)
 @param sender sender
 */
- (IBAction)uRLTellCallPhone:(UIButton *)sender {
    
    NSMutableString * callPhone=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"10086"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    
}


@end

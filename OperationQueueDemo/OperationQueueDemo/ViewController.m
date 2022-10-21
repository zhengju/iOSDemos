//
//  ViewController.m
//  OperationQueueDemo
//
//  Created by zhengsw on 2022/10/21.
//

#import "ViewController.h"
#import "HttpNetwork.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestNetworkWithUrl:@"http://1"];
    [self requestNetworkWithUrl:@"http://2"];
}
- (void)requestNetworkWithUrl:(NSString *)url {
    [HttpNetwork requestWithUrl:url completBlock:^(id  _Nonnull completData) {
        NSLog(@"网络请求成功%@",completData);
    } failed:^{
    }];
}

@end

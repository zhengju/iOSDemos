//
//  ViewController.m
//  OperationQueueDemo
//
//  Created by zhengsw on 2022/10/21.
//

#import "ViewController.h"
#import "HttpNetwork.h"
@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *taskArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskArray = [NSMutableArray array];
    
    [self requestA];
    [self requestB];
    [self requestC];
    
    [self requestNextNetwork];

}

- (void)requestA {
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(requestNetworkWithUrl:) object:@"http://A"];
    [self.taskArray addObject:invocationOperation];
}
- (void)requestB {
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(requestNetworkWithUrl:) object:@"http://B"];
    [self.taskArray addObject:invocationOperation];
}
- (void)requestC {
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(requestNetworkWithUrl:) object:@"http://C"];
    [self.taskArray addObject:invocationOperation];
}

- (void)requestNetworkWithUrl:(NSString *)url {
    [HttpNetwork requestWithUrl:url completBlock:^(id  _Nonnull completData) {
        NSLog(@"网络请求成功%@",completData);
        [self requestNextNetwork];
    } failed:^{
    }];
}

- (void)requestNextNetwork {
    if(self.taskArray.count > 0) {
        NSInvocationOperation *invocationOperation = [self.taskArray firstObject];
        [invocationOperation start];
        [self.taskArray removeObjectAtIndex:0];
    }
    
}

@end

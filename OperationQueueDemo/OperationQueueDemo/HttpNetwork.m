//
//  HttpNetwork.m
//  OperationQueueDemo
//
//  Created by zhengsw on 2022/10/21.
//

#import "HttpNetwork.h"

@implementation HttpNetwork
+ (void)requestWithUrl:(NSString *)url completBlock:(void (^)(id _Nonnull))completBlock failed:(void (^)(void))failedBlock {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(0.2);//模拟网络请求
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completBlock) {
                completBlock(url);
            }
        });
    });
}
@end

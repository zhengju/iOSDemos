//
//  HttpNetwork.h
//  OperationQueueDemo
//
//  Created by zhengsw on 2022/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpNetwork : NSObject
+ (void)requestWithUrl:(NSString *)url completBlock:(void (^)(id completData))completBlock failed:(void (^)(void))failedBlock;
@end

NS_ASSUME_NONNULL_END

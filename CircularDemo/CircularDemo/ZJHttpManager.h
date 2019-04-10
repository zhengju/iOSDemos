//
//  DetailView.h
//  NSTimerDemo
//
//  Created by leeco on 2019/4/3.
//  Copyright © 2019年 zsw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN





@interface ZJHttpManager : NSObject



+ (void)requestName:(void(^)(NSString *name))successBlock;

@end

NS_ASSUME_NONNULL_END

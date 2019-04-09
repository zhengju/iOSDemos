//
//  ZJWeakProxy.h
//  NSTimerDemo
//
//  Created by leeco on 2019/4/9.
//  Copyright © 2019 zsw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJWeakProxy : NSProxy

@property(nonatomic, weak, readonly)  id   target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END

//
//  JTimer.h
//  NSTimerDemo
//
//  Created by zhengju on 2019/12/7.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^block)(void);

@interface JTimer : NSObject

- (instancetype)initWithTarget:(id)target block:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END

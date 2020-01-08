//
//  Factory.h
//  Calculator
//
//  Created by zhengju on 2020/1/8.
//  Copyright © 2020 zhengju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Operation.h"
NS_ASSUME_NONNULL_BEGIN

@interface Factory : NSObject

+ (id)initWithName:(NSString *)className;

- (Operation *)createOperation;

@end

NS_ASSUME_NONNULL_END

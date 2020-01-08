//
//  Operation.h
//  Calculator
//
//  Created by zhengju on 2020/1/8.
//  Copyright © 2020 zhengju. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Operation : NSObject
- (NSInteger)resultWithNum1:(NSInteger)num1 andNum2:(NSInteger)num2;
@end

NS_ASSUME_NONNULL_END

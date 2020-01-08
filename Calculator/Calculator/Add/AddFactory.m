//
//  AddFactory.m
//  Calculator
//
//  Created by zhengju on 2020/1/8.
//  Copyright © 2020 zhengju. All rights reserved.
//

#import "AddFactory.h"
#import "AddOperation.h"
@implementation AddFactory

- (Operation *)createOperation{
    return [AddOperation new];
}

@end

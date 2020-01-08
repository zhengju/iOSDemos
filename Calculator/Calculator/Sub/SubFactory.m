//
//  SubFactory.m
//  Calculator
//
//  Created by zhengju on 2020/1/8.
//  Copyright © 2020 zhengju. All rights reserved.
//

#import "SubFactory.h"
#import "SubOperation.h"
@implementation SubFactory
- (Operation *)createOperation{
    return [SubOperation new];
}
@end

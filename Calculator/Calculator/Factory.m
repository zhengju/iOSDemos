//
//  Factory.m
//  Calculator
//
//  Created by zhengju on 2020/1/8.
//  Copyright © 2020 zhengju. All rights reserved.
//

#import "Factory.h"
#import "AddFactory.h"
@implementation Factory

+ (id)initWithName:(NSString *)className{
    

    Class class = NSClassFromString([NSString stringWithFormat:@"%@Factory",className]);
    
    return [class new];
    
    
}


@end

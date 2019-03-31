//
//  MyObj.m
//  深浅拷贝
//
//  Created by zhengju on 2016/11/19.
//  Copyright © 2016年 zhengju. All rights reserved.
//

#import "MyObj.h"

@implementation MyObj
- (id)copyWithZone:(NSZone *)zone{
    MyObj *copy = [[[self class] allocWithZone :zone] init];
    copy->_name = [_name copy];
    copy->_imutableStr = [_imutableStr copy];
    copy->_age = _age;
    return copy;
}
@end

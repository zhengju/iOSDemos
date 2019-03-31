//
//  ZJPerson.m
//  深浅拷贝
//
//  Created by zhengju on 2016/11/19.
//  Copyright © 2016年 zhengju. All rights reserved.
//

#import "ZJPerson.h"
@interface ZJPerson()<NSCopying>

@end


@implementation ZJPerson
-(id)copyWithZone:(NSZone *)zone{
    
    ZJPerson * person = [[ZJPerson allocWithZone:zone]init];
    person.age = self.age ;
    person.name = [self.name copy];
    person.StrongName = self.StrongName;
    // 这里self其实就要被copy的那个对象，很显然要自己赋值给新对象，所以这里可以控制copy的属性
    return person;
}
@end

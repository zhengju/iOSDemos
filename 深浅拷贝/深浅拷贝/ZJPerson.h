//
//  ZJPerson.h
//  深浅拷贝
//
//  Created by zhengju on 2016/11/19.
//  Copyright © 2016年 zhengju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJPerson : NSObject

@property (nonatomic,copy) NSString * name;
@property (nonatomic) NSInteger  age;
@property (nonatomic,strong) NSString * StrongName;

@end

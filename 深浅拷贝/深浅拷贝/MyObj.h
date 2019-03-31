//
//  MyObj.h
//  深浅拷贝
//
//  Created by zhengju on 2016/11/19.
//  Copyright © 2016年 zhengju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyObj : NSObject<NSCopying,NSMutableCopying>{
    NSMutableString *_name;
    NSString * _imutableStr ;
    int _age;
}
@property (nonatomic, retain) NSMutableString *name;
@property (nonatomic, retain) NSString *imutableStr;


@property (nonatomic) int age;
@property (nonatomic) int height;

@end

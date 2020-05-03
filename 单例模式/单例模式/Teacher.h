//
//  Teacher.h
//  单例模式
//
//  Created by 郑帅伟 on 2020/4/13.
//  Copyright © 2020 郑帅伟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Teacher : NSObject

@property(nonatomic,copy,readonly)NSString * name;

+(instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END

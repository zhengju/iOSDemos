//
//  TaskManager.h
//  BigAPP
//
//  Created by zhengju on 2019/12/26.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN




@interface TaskManager : NSObject

@property(strong,nonatomic) NSMutableArray * modules;


+ (instancetype)shareManager;

- (void)registModules:(UIView *)module;

@end

NS_ASSUME_NONNULL_END

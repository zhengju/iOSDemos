//
//  ModuleA.h
//  BigAPP
//
//  Created by zhengju on 2019/12/26.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface ModuleA : UIView<TaskProtocol>
@property(copy,nonatomic) block block;

@end

NS_ASSUME_NONNULL_END

//
//  SpringBoxManager.h
//  SpringBox
//
//  Created by zhengsw on 2020/6/18.
//  Copyright © 2020 58. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertConfig : NSObject
@property (nonatomic,assign) NSInteger alertType;
@property (nonatomic,assign) NSInteger priority;
@property (nonatomic,strong) NSDictionary *params;
@end


@interface SpringBoxManager : NSObject

+ (instancetype)shareManager;

- (void)addAlert:(AlertConfig *)config;

- (void)alertShowWithType:(NSString *)type;

- (void)alertDissMissWithType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END

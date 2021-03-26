//
//  SpringBoxManager.h
//  SpringBox
//
//  Created by zhengsw on 2020/6/18.
//  Copyright © 2020 58. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AlertPriority) {
    AlertPriority1 = 1,
    AlertPriority2,
    AlertPriority3
};

typedef void(^Block)(BOOL isSuccess,NSString *message);

@interface AlertConfig : NSObject

/// 弹框标识
@property (nonatomic,copy) NSString *alertType;

///  是否被拦截阻断 默认是YES
@property (nonatomic,assign) BOOL isIntercept;

/// 阻断后，是否需要激活 在isIntercept为YES有效
@property (nonatomic,assign) BOOL isActivate;

/// 当前的弹框是否已经在显示
@property (nonatomic,assign) BOOL isDisplay;

/// 优先级 1 2 3 .. 默认1 设置其他值会重置成1
@property (nonatomic,assign) AlertPriority priority;

@property (nonatomic,strong) NSDictionary *params;

@property (nonatomic,copy) Block showBlock;

@property (nonatomic,copy) Block dismissBlock;

- (instancetype)initWithPatams:(NSDictionary *)params activate:(BOOL)isActivate;

@end


@interface AlertManager : NSObject

+ (instancetype)shareManager;

/// 是否根据优先级排序 默认YES优先级生效
@property (nonatomic,assign,readonly) BOOL isSortByPriority;

/// 最大弹框数量 默认是5
@property (nonatomic,assign) NSInteger maxAlertCount;

/// 弹框展示
/// @param config 配置
/// @param showBlock 显示回调
/// @param dismissBlock 隐藏回调
- (void)alertShowWithConfig:(AlertConfig *)config show:(Block)showBlock dismiss:(Block)dismissBlock;

/// 清除弹框 每一个弹框必须要调用此方法
- (void)alertDissMiss;

/// 清楚缓存
- (void)clearCache;

@end

NS_ASSUME_NONNULL_END

//优先级排序显示 排序：在diss时排序
//不考虑弹框折叠，若是后来者弹框显示，则先隐藏掉已经在显示的弹框
//跨界面使用时 不要使用单例创建实例


//
//  OperatioCrossingEffectView.h
//  ClipVideo
//
//  Created by zhengju on 2018/12/9.
//  Copyright © 2018年 zsw. All rights reserved.
//过场动画-过度效果

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZJTransitionModel;
@class OperatioCrossingEffectView;
@protocol OperatioCrossingEffectViewDelegate <NSObject>

- (void)operatioCrossingEffectView:(NSInteger)index model:(ZJTransitionModel*)model;

- (void)dismissOperatioCrossingEffectView:(OperatioCrossingEffectView *)operatioCrossingEffectView;

@end

@interface OperatioCrossingEffectView : UIView

@property(nonatomic, weak) id<OperatioCrossingEffectViewDelegate> delegate;
@property(nonatomic, strong) ZJTransitionModel * model;

@end

NS_ASSUME_NONNULL_END

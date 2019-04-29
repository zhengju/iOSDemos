//
//  ProportionBottomView.h
//  ClipVideo
//
//  Created by leeco on 2018/11/7.
//  Copyright © 2018年 zsw. All rights reserved.
//视频比例 --操作面板

#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN
@class OperationProportionView;
@protocol ProportionBottomViewDelegate <NSObject>

- (void)proportionBottomView:(NSInteger)index;
- (void)dismissAndSave:(OperationProportionView*)proportionBottomView;
@end


@interface OperationProportionView : UIView
@property(nonatomic, weak) id<ProportionBottomViewDelegate> delegate;



@end

NS_ASSUME_NONNULL_END

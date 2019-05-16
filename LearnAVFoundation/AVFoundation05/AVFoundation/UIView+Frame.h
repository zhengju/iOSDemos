//
//  UIView+Frame.h
//  ZJPlayer
//
//  Created by leeco on 2018/10/9.
//  Copyright © 2018年 郑俱. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Frame)

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

- (CGFloat)frameX;
- (CGFloat)frameY;
- (CGFloat)frameW;
- (CGFloat)frameH;
- (CGSize)size;
- (CGFloat)centerX;
- (CGFloat)centerY;

- (void)setFrameX:(CGFloat)x;
- (void)setFrameY:(CGFloat)y;
- (void)setFrameW:(CGFloat)width;
- (void)setFrameH:(CGFloat)height;
- (void)setSize:(CGSize)size;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;

@end

NS_ASSUME_NONNULL_END

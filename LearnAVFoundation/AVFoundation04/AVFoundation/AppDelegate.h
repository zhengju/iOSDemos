//
//  AppDelegate.h
//  AVFoundation
//
//  Created by leeco on 2019/5/7.
//  Copyright © 2019 zsw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

/**
 转场栗子
 */

/**
 
 CGAffineTransform CGAffineTransformMakeTranslation(CGFloat tx,CGFloat ty)//相对平移 (左上角为相对移动的(0,0)点)
 CGAffineTransform CGAffineTransformMakeScale(CGFloat sx, CGFloat sy)缩放
 CGAffineTransform CGAffineTransformScale(CGAffineTransform t, CGFloat sx, CGFloat sy)
 CGAffineTransform CGAffineTransformRotate(CGAffineTransform t, CGFloat angle)
 CGAffineTransform CGAffineTransformMakeRotation(CGFloat angle)
 
 **/

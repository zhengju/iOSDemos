//
//  LCNetworkImageView.h
//  LCNetworkImageView
//
//  Created by CC on 15/11/19.
//  Copyright © 2015年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LCNetworkImageView : UIView



- (void)loadImageWithURL:(NSURL*)url
               completed:(void (^) (BOOL isSuccess, UIImage * image))block;

- (UIImage*) image;

@end

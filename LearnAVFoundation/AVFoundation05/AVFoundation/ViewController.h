//
//  ViewController.h
//  AVFoundation
//
//  Created by leeco on 2019/5/7.
//  Copyright © 2019 zsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class PlayerView;
@protocol PlayerViewDelegate <NSObject>

- (void)playerView:(PlayerView*)playerView playOrPause:(BOOL)play;

@end

@interface PlayerView : UIView
@property (nonatomic ,strong) AVPlayer *player;
@property(nonatomic, weak) id<PlayerViewDelegate> delegate;
@end

@interface ViewController : UIViewController


@end


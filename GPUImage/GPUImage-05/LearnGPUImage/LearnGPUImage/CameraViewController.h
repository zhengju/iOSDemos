//
//  CameraViewController.h
//  LearnGPUImage
//
//  Created by leeco on 2019/5/21.
//  Copyright © 2019 zsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Camera.h"
NS_ASSUME_NONNULL_BEGIN

@interface CameraViewController : UIViewController
@property (nonatomic , strong) Camera *cameraManager;

@end

NS_ASSUME_NONNULL_END

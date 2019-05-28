//
//  Camera.h
//  LearnGPUImage
//
//  Created by leeco on 2019/5/21.
//  Copyright © 2019 zsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"
#import "GPUImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface Camera : NSObject
@property (nonatomic , strong) GPUImageVideoCamera *camera;
@property (nonatomic , strong) GPUImageView *cameraScreen;
@property (nonatomic , strong) GPUImageFilter *filter;

- (void)startCamera;
- (void)stopCamera;
@end

NS_ASSUME_NONNULL_END

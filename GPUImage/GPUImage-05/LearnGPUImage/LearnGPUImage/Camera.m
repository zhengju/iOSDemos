//
//  Camera.m
//  LearnGPUImage
//
//  Created by leeco on 2019/5/21.
//  Copyright © 2019 zsw. All rights reserved.
//

#import "Camera.h"

@implementation Camera
- (void)startCamera{
    
    if (!_camera) {
        GPUImageVideoCamera *camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
        camera.outputImageOrientation = UIInterfaceOrientationPortrait;
        camera.horizontallyMirrorFrontFacingCamera = YES;
        _camera = camera;
    }
//    _filter = [[GPUImageFilter alloc] init];
//    [self.camera addTarget:_filter];
//    [_filter addTarget:self.cameraScreen];
    [self.camera startCameraCapture];
}

- (void)stopCamera{
    [self.camera stopCameraCapture];
}
@end

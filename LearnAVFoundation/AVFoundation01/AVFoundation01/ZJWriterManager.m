//
//  ZJWriterManager.m
//  AVFoundation01
//
//  Created by leeco on 2019/5/16.
//  Copyright © 2019 zsw. All rights reserved.
//

#import "ZJWriterManager.h"
#import <AVFoundation/AVFoundation.h>

@interface ZJWriterManager()
@property (nonatomic, strong) AVAssetWriter *writer;

@property (nonatomic, strong) AVAssetWriterInput *writerInput;

@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *writerAdaptor;
@end


@implementation ZJWriterManager
- (NSMutableArray *)images{
    if (_images == nil) {
        _images = [NSMutableArray arrayWithCapacity:0];
    }
    return _images;
}
- (void)writeVideoSize:(CGSize)videoSize path:(NSURL *)path success:(nonnull KSuccessBlcok)successBlcok{
    NSError *error = nil;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:path
                                                           fileType:AVFileTypeMPEG4
                                                              error:&error];
    if (error) {
        
        NSLog(@"error is %@",error);
        return;
    }
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings = @{AVVideoCodecKey: AVVideoCodecH264,
                                    AVVideoWidthKey: [NSNumber numberWithInt:videoSize.width],
                                    AVVideoHeightKey: [NSNumber numberWithInt:videoSize.height]};
    
    AVAssetWriterInput* writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                         outputSettings:videoSettings];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                                                                                     sourcePixelBufferAttributes:nil];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    [videoWriter addInput:writerInput];
    
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    CVPixelBufferRef buffer;
    CVPixelBufferPoolCreatePixelBuffer(NULL, adaptor.pixelBufferPool, &buffer);
    
    int fps = 30;//30帧为1秒
    
    for (int i = 0; i < self.images.count; i++) {
        
        buffer = [self pixelBufferFromCGImage:([self.images[i] CGImage]) size:videoSize];//image转为帧
        
        if (writerInput.readyForMoreMediaData) {
            
            CMTime frameTime = CMTimeMake(i,(int32_t)fps);
            
            CMTimeShow(frameTime);
            
            if (buffer) {
                
                BOOL appendSuccess = [self appendToAdapter:adaptor pixelBuffer:buffer atTime:frameTime withInput:writerInput];
                
                NSAssert(appendSuccess, @"Failed to append");
                
            }
        }
    }
    
    [writerInput markAsFinished];
    
    [videoWriter finishWritingWithCompletionHandler:^{
        NSLog(@"Successfully closed video writer \n");
        NSLog(@"%@ \n", path);
        
        if (videoWriter.status == AVAssetWriterStatusCompleted) {
            NSLog(@"成功了");
            if (successBlcok) {
                successBlcok();
            }
        } else {
            NSLog(@"fail %ld",(long)videoWriter.status);
        }
    }];
    
    CVPixelBufferPoolRelease(adaptor.pixelBufferPool);
    
}

- (BOOL)appendToAdapter:(AVAssetWriterInputPixelBufferAdaptor*)adaptor
            pixelBuffer:(CVPixelBufferRef)buffer
                 atTime:(CMTime)presentTime
              withInput:(AVAssetWriterInput*)writerInput
{
    while (!writerInput.readyForMoreMediaData) {
        usleep(1);
    }
    
    return [adaptor appendPixelBuffer:buffer withPresentationTime:presentTime];
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image
                                      size:(CGSize)imageSize
{
    NSDictionary *options = @{(id)kCVPixelBufferCGImageCompatibilityKey: @YES,
                              (id)kCVPixelBufferCGBitmapContextCompatibilityKey: @YES};
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, imageSize.width,
                                          imageSize.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, imageSize.width,
                                                 imageSize.height, 8, 4*imageSize.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    
    CGContextDrawImage(context, CGRectMake(0 + (imageSize.width-CGImageGetWidth(image))/2,
                                           (imageSize.height-CGImageGetHeight(image))/2,
                                           CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}
@end

//
//  ViewController.m
//  LearnGPUImage
//
//  Created by leeco on 2019/4/26.
//  Copyright © 2019 zsw. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "ZJDisplayCropFilter.h"

@interface ViewController ()
{
    GPUImageMovie *movieFile;
    GPUImageMovieWriter *movieWriter;
    AVPlayer * player;
    AVPlayerItemVideoOutput * itemOutput;
    AVPlayerItem * playerItem;
    NSTimer * timer;
}

@property(nonatomic, strong) UILabel * progressLabel;
@property (nonatomic , strong) CADisplayLink *mDisplayLink;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGPUImage];
}
- (void)setupGPUImage{
    
    self.progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, self.view.bounds.size.height-40, 100, 30)];
    self.progressLabel.text = @"0%";
    [self.view addSubview:self.progressLabel];
    
    NSURL * inputMovieURL = [[NSBundle mainBundle] URLForResource:@"2233" withExtension:@"mp4"];// 640 360
    
    GPUImageView * playerView = [[GPUImageView alloc]initWithFrame:CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width)/2.0, self.view.bounds.size.width, self.view.bounds.size.width)];
    
    playerView.fillMode = kGPUImageFillModeStretch;
    
    [self.view addSubview:playerView];

    AVAsset * asset = [AVAsset assetWithURL:inputMovieURL];
    
    
    NSDictionary *pixBuffAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};
    itemOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:pixBuffAttributes];
    playerItem = [AVPlayerItem playerItemWithURL:inputMovieURL];
    
    [playerItem addOutput:itemOutput];
    
    
    
    player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
    
    movieFile = [[GPUImageMovie alloc]initWithPlayerItem:playerItem];
    
    //CGRectMake((1920 - 1080) / 2 / 1920, 0, 1080.0 / 1920, 1)
    GPUImageCropFilter * cropFilter = [[GPUImageCropFilter alloc]initWithCropRegion:CGRectMake(0, 0, 1, 1)];//裁剪filter
    [movieFile addTarget:cropFilter];
    
    
    ZJDisplayCropFilter * displayCropFilter = [[ZJDisplayCropFilter alloc]init];
    [displayCropFilter setDrawRect:CGRectMake(0, (1 - 360.0 / 640.0) / 2.0, 1, 360.0 / 640.0)];//设置渲染区域 视频按比例显示
    [cropFilter addTarget:displayCropFilter];
    
  
//    GPUImageGaussianBlurFilter *gaussianBlur = [[GPUImageGaussianBlurFilter alloc] init];
//    gaussianBlur.blurRadiusInPixels = 25.0;
//    [cropFilter addTarget:gaussianBlur];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
    imageView.image = [UIImage imageNamed:@"WID-small.jpg"];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width)/2.0, self.view.bounds.size.width, self.view.bounds.size.width)];
    [view addSubview:imageView];

    GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    blendFilter.mix = 1;
    
    GPUImageUIElement * element = [[GPUImageUIElement alloc]initWithView:view];
    [element addTarget:blendFilter];
 
    GPUImageFilter * progressFilter = [[GPUImageFilter alloc]init];
    [displayCropFilter addTarget:progressFilter];
    
    
    [progressFilter addTarget:blendFilter];
//    [displayCropFilter addTarget:blendFilter];
    
    [blendFilter addTarget:playerView];
    
    [progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        [element update];
    }];
    
    
    //save video 
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 640.0)];
    [blendFilter addTarget:movieWriter];
    
    movieWriter.shouldPassthroughAudio = YES;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    
    
    [player play];
    
//    [movieWriter startRecording];
//    [movieFile startProcessing];
    
    
   timer = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                             target:self
                                           selector:@selector(retrievingProgress)
                                           userInfo:nil
                                            repeats:YES];
    
    [movieWriter setCompletionBlock:^{
        [blendFilter removeTarget:self->movieWriter];
        [self->movieWriter finishRecording];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [timer invalidate];
            self.progressLabel.text = @"100%";
        });

        UISaveVideoAtPathToSavedPhotosAlbum(movieURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);

    }];
    
    self.mDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displaylink:)];
    [self.mDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

}

- (void)retrievingProgress
{
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(movieFile.progress * 100)];
}

- (void)displaylink:(CADisplayLink *)displaylink {
    CMTime itemTime = [itemOutput itemTimeForHostTime:CACurrentMediaTime()];

    if ([itemOutput hasNewPixelBufferForItemTime:itemTime]) {
        CVPixelBufferRef pixelBuffer = [itemOutput copyPixelBufferForItemTime:itemTime itemTimeForDisplay:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self->movieFile processMovieFrame:pixelBuffer withSampleTime:itemTime];
            
            CVBufferRelease(pixelBuffer);
        });
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alert show];
 } else {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                    delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alert show];
 }

}

@end

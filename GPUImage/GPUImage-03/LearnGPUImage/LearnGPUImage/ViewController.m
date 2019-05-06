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
#import "OperationProportionView.h"
@interface ViewController ()<ProportionBottomViewDelegate>
{
    GPUImageMovie *movieFile;
    GPUImageMovieWriter *movieWriter;
    AVPlayer * player;
    AVPlayerItemVideoOutput * itemOutput;
    AVPlayerItem * playerItem;
    NSTimer * timer;
    GPUImageView * playerView;
    CGSize naturalSize;
    ZJDisplayCropFilter * displayCropFilter;
    CGRect originFrame;
}

@property(nonatomic, strong) UILabel * progressLabel;
@property (nonatomic , strong) CADisplayLink *mDisplayLink;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGPUImage];
    [self configureProportionView];
}


- (void)setupGPUImage{
    
    BOOL rate = YES;
    
    self.progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, 100, 30)];
    self.progressLabel.text = @"0%";
    [self.view addSubview:self.progressLabel];
    
    playerView = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.width)];
    originFrame = playerView.frame;
    playerView.fillMode = kGPUImageFillModeStretch;
    
    [self.view addSubview:playerView];
    
    
    NSURL * inputMovieURL = [[NSBundle mainBundle] URLForResource:@"驾校视频" withExtension:@"MOV"];
    
    //判断是否有旋转
    AVAsset * asset = [AVAsset assetWithURL:inputMovieURL];
    NSArray * tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    NSInteger degress = 0;
    naturalSize = CGSizeZero;
    if(tracks.count > 0){// 1080 1920
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        
        CGAffineTransform t = videoTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
            naturalSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.width);
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
            naturalSize = videoTrack.naturalSize;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
            naturalSize = videoTrack.naturalSize;

        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
            naturalSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.width);
        }
    }

    NSDictionary *pixBuffAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};
    itemOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:pixBuffAttributes];
    playerItem = [AVPlayerItem playerItemWithURL:inputMovieURL];
    
    [playerItem addOutput:itemOutput];
    
    
    player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
    
    movieFile = [[GPUImageMovie alloc]initWithPlayerItem:playerItem];
    
    //CGRectMake((1920 - 1080) / 2 / 1920, 0, 1080.0 / 1920, 1)
    GPUImageCropFilter * cropFilter = [[GPUImageCropFilter alloc]initWithCropRegion:CGRectMake(0, 0, 1, 1)];//裁剪filter
    [movieFile addTarget:cropFilter];
    
    switch (degress) {
            case 90:
            [cropFilter setInputRotation:kGPUImageRotateRight atIndex:0];
            break;
            case 180:
            [cropFilter setInputRotation:kGPUImageRotate180 atIndex:0];
            break;
            case 270:
            [cropFilter setInputRotation:kGPUImageRotateLeft atIndex:0];
            break;
            
        default:
            break;
    }
    
    //视频按比例渲染区域
    CGRect drawRect = CGRectMake(0, (1 - naturalSize.height / naturalSize.width) / 2.0, 1, naturalSize.height / naturalSize.width);//以宽
    if (naturalSize.height > naturalSize.width) {//以高
       drawRect = CGRectMake((1 - naturalSize.width / naturalSize.height) / 2.0, 0, naturalSize.width / naturalSize.height, 1);
    }
    
    displayCropFilter = [[ZJDisplayCropFilter alloc]init];
    [displayCropFilter setDrawRect:drawRect];//设置渲染区域 视频按比例显示
    [cropFilter addTarget:displayCropFilter];
    
    GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    blendFilter.mix = 1;
    if (rate == YES) {//比例蒙层
        GPUImageGaussianBlurFilter *gaussianBlur = [[GPUImageGaussianBlurFilter alloc] init];
        gaussianBlur.blurRadiusInPixels = 25.0;
        [cropFilter addTarget:gaussianBlur];
        
        [gaussianBlur addTarget:blendFilter];
        [displayCropFilter addTarget:blendFilter];
        
    }else{//显示背景图片
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
        imageView.image = [UIImage imageNamed:@"WID-small.jpg"];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width)/2.0, self.view.bounds.size.width, self.view.bounds.size.width)];
        [view addSubview:imageView];
        GPUImageUIElement * element = [[GPUImageUIElement alloc]initWithView:view];
        
        GPUImageFilter * progressFilter = [[GPUImageFilter alloc]init];//进度filter
        [displayCropFilter addTarget:progressFilter];
        
        [element addTarget:blendFilter];
        [progressFilter addTarget:blendFilter];
        
        [progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
            [element update];
        }];
        
    }

    [blendFilter addTarget:playerView];

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

- (void)configureProportionView{
    OperationProportionView * proportionView = [[OperationProportionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(playerView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(playerView.frame))];
    proportionView.delegate = self;
    [self.view addSubview:proportionView];
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

#pragma mark - ProportionBottomViewDelegate
- (void)proportionBottomView:(NSInteger)index{

    CGFloat rate = 1.0;
    
    if (index == 0) {//视频原始比例
        rate = naturalSize.width/naturalSize.height;
    }else if (index == 1) {//1:1
        rate = 1;
    }else if (index == 2){//4:3
        rate = 4/3.0;
    }else if (index == 3){//3:4
        rate = 3/4.0;
    }else if (index == 4){//16:9
        rate = 16/9.0;
    }else if (index == 5){//9:16
        rate = 9/16.0;
    }else if (index == 6){
        rate = 4/5.0;
    }else if (index == 7){
        rate = 2/3.0;
    }else if (index == 8){
        rate = 3/2.0;
    }else if (index == 9){
        rate = 2/1.0;
    }else if (index == 10){
        rate = 1/2.0;
    }


    CGRect frame = [self frameWithPlayerViewOriginFrame:originFrame videorate:rate];
    
    /*******/
    [UIView animateWithDuration:0.3 animations:^{
        playerView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
    /*******/
    CGRect drawRect = [self drawRectWithNaturalSize:naturalSize playViewSize:frame.size videorate:rate];
    [displayCropFilter setDrawRect:drawRect];
    
    /*******/
    [movieFile processMovieFrame:movieFile.pixelBuffer withSampleTime:movieFile.currentSampleTime];
    
}

/**
 视频playerView显示的frame

 @param originFrame 视频view的原始frame
 @param rate 视频将要显示的比例
 @return frame
 */
- (CGRect)frameWithPlayerViewOriginFrame:(CGRect)originFrame videorate:(CGFloat)rate{
    
    CGRect frame = originFrame;
    
    CGFloat originWidth = frame.size.width;
    CGFloat originHeight = frame.size.height;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    if (rate < 1) {//以高
        
        width = height * rate;
    }else{//以宽
        
        height = width / rate;
    }
    
    return CGRectMake((originWidth-width)/2.0, (originHeight-height)/2.0+64, width, height);
}

/**
 视频按比例渲染的frame

 @param naturalSize 视频原始size
 @param playViewSize 视频PayerView显示的size
 @param rate 比例
 @return 视频渲染frame (0,0,1,1)
 */
- (CGRect)drawRectWithNaturalSize:(CGSize)naturalSize playViewSize:(CGSize)playViewSize  videorate:(CGFloat)rate{
    
    CGFloat width = playViewSize.width;
    CGFloat height = playViewSize.height;
    
    CGRect drawRect = CGRectMake(0, (1 - naturalSize.height / naturalSize.width) / 2.0, 1, naturalSize.height / naturalSize.width);//以宽
    
    if (naturalSize.height > naturalSize.width) {//以高
        
        drawRect = CGRectMake((1 - naturalSize.width / naturalSize.height) / 2.0, 0, naturalSize.width / naturalSize.height, 1);
    }
    
    if ((naturalSize.width / naturalSize.height) <= rate) {
        
        CGFloat drawRectWidth = height * (naturalSize.width / naturalSize.height)/width;
        drawRect = CGRectMake((1 - drawRectWidth) / 2.0, 0, drawRectWidth, 1);
    }else{//显示的高，视频的高用不完
        
        CGFloat drawRectHeight = width/(naturalSize.width / naturalSize.height)/height;
        drawRect = CGRectMake(0, (1 - drawRectHeight) / 2.0, 1, drawRectHeight);
    }
    
    return drawRect;
}


@end

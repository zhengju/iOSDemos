//
//  ViewController.m
//  LearnGPUImage
//
//  Created by leeco on 2019/4/26.
//  Copyright © 2019 zsw. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"

#import "ZJDisplayCropFilter.h"
#import "LYMultiTextureFilter.h"
@interface ViewController ()
@property (nonatomic, strong) LYMultiTextureFilter *lyMultiTextureFilter6;
@property (nonatomic, strong) LYMultiTextureFilter *lyMultiTextureFilter9;
@end

@implementation ViewController

#define MaxRow (2)
#define MaxColumn (3)

- (void)viewDidLoad {
    [super viewDidLoad];

    self.lyMultiTextureFilter6 = [[LYMultiTextureFilter alloc] initWithMaxFilter:MaxRow * MaxColumn];
    self.lyMultiTextureFilter9 = [[LYMultiTextureFilter alloc] initWithMaxFilter:3 * 3];
    [self setupGPUImage];
}
- (void)setupGPUImage{
    
    NSURL * inputMovieURL = [[NSBundle mainBundle] URLForResource:@"2222" withExtension:@"mp4"];
    
    GPUImageView * playerView = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 300)];
    
    playerView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    
    [self.view addSubview:playerView];
    
    GPUImageMovie * movie = [[GPUImageMovie alloc]initWithURL:inputMovieURL];
    
    //CGRectMake((1920 - 1080) / 2 / 1920, 0, 1080.0 / 1920, 1)
    GPUImageCropFilter * cropFilter = [[GPUImageCropFilter alloc]initWithCropRegion:CGRectMake(0, 0, 1, 1)];//裁剪filter
    
    [movie addTarget:cropFilter];
    
    
    ZJDisplayCropFilter * displayCropFilter = [[ZJDisplayCropFilter alloc]init];
    [displayCropFilter setDrawRect:CGRectMake(0, 0, 1, 1)];//设置渲染区域
    [cropFilter addTarget:displayCropFilter];
    
//
//    GPUImageNormalBlendFilter * blendFilter = [[GPUImageNormalBlendFilter alloc]init];
//    //两个分屏
//    ZJDisplayCropFilter * displayCropFilter0 = [[ZJDisplayCropFilter alloc]init];
//    [displayCropFilter0 setDrawRect:CGRectMake(0, 0, 1, 0.5)];//设置渲染区域
//    [cropFilter addTarget:displayCropFilter0];
//    ZJDisplayCropFilter * displayCropFilter1 = [[ZJDisplayCropFilter alloc]init];
//    [displayCropFilter1 setDrawRect:CGRectMake(0, 0.5, 1, 1)];//设置渲染区域
//    [cropFilter addTarget:displayCropFilter1];
//    [displayCropFilter0 addTarget:blendFilter];
//    [displayCropFilter1 addTarget:blendFilter];

    
    for (int indexRow = 0; indexRow < MaxRow; ++indexRow) {
        for (int indexColumn = 0; indexColumn < MaxColumn; ++indexColumn) {
            CGRect frame = CGRectMake(indexColumn * 1.0 / MaxColumn,
                                      indexRow * 1.0 / MaxRow,
                                      1.0 / MaxColumn,
                                      1.0 / MaxRow);
            [self buildGPUImageViewWithFrame:frame imageMovie:movie];
        }
    }
    
    [self.lyMultiTextureFilter6 addTarget:playerView];
    
    
    [cropFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        CMTimeShow(time);
        
        if (CMTimeGetSeconds(time) > 4 && CMTimeGetSeconds(time)<15) {//分屏
            if ([displayCropFilter.targets containsObject:playerView]) {
                [displayCropFilter removeTarget:playerView];
                [self.lyMultiTextureFilter6 addTarget:playerView];
            }
        }else{

            if (![displayCropFilter.targets containsObject:playerView] || [self.lyMultiTextureFilter6.targets containsObject:playerView]) {
                [self.lyMultiTextureFilter6 removeTarget:playerView];
                [displayCropFilter addTarget:playerView];
            }
        }
    }];
    
    [movie startProcessing];
}

- (void)buildGPUImageViewWithFrame:(CGRect)frame imageMovie:(GPUImageMovie *)imageMovie {
    // 1080 1920，这里已知视频的尺寸。如果不清楚视频的尺寸，可以先读取视频帧CVPixelBuffer，再用CVPixelBufferGetHeight/Width
    GPUImageCropFilter *cropFilter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake((1920 - 1080) / 2 / 1920, 0, 1080.0 / 1920, 1)];
    
    GPUImageTransformFilter *transformFilter = [[GPUImageTransformFilter alloc] init];
    
    GPUImageOutput *tmpFilter;
    
    tmpFilter = imageMovie;
    
    [tmpFilter addTarget:cropFilter];
    tmpFilter = cropFilter;
    
    [tmpFilter addTarget:transformFilter];
    tmpFilter = transformFilter;
    
    NSInteger index = [self.lyMultiTextureFilter6 nextAvailableTextureIndex];
    [tmpFilter addTarget:self.lyMultiTextureFilter6 atTextureLocation:index];
    [self.lyMultiTextureFilter6 setDrawRect:frame atIndex:index];
}
@end

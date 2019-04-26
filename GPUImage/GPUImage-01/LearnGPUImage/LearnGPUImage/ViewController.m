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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGPUImage];
}
- (void)setupGPUImage{
    
    NSURL * inputMovieURL = [[NSBundle mainBundle] URLForResource:@"2222" withExtension:@"mp4"];
    
    GPUImageView * playerView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    
    playerView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    
    [self.view addSubview:playerView];
    
    GPUImageMovie * movie = [[GPUImageMovie alloc]initWithURL:inputMovieURL];
    
    //CGRectMake((1920 - 1080) / 2 / 1920, 0, 1080.0 / 1920, 1)
    GPUImageCropFilter * cropFilter = [[GPUImageCropFilter alloc]initWithCropRegion:CGRectMake(0, 0.5, 1, 1)];//裁剪filter
    
    [movie addTarget:cropFilter];
    
    ZJDisplayCropFilter * displayCropFilter = [[ZJDisplayCropFilter alloc]init];
    
    [displayCropFilter setDrawRect:CGRectMake(0, 0.5, 1, 1)];//设置渲染区域
    
    [cropFilter addTarget:displayCropFilter];
    
    [displayCropFilter addTarget:playerView];
    
    [movie startProcessing];
    
}

@end

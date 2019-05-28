//
//  CameraViewController.m
//  LearnGPUImage
//
//  Created by leeco on 2019/5/21.
//  Copyright © 2019 zsw. All rights reserved.
//

#import "CameraViewController.h"
#import "GPUImage.h"
#import "GPUImageView.h"

#import "LYMultiTextureFilter.h"

@interface CameraViewController ()<UIImagePickerControllerDelegate>
{
    NSTimer * timer;
}
@property(nonatomic, strong) GPUImageMovie * movie;
@property(nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) LYMultiTextureFilter *lyMultiTextureFilter;
@end

@implementation CameraViewController

#define MaxRow (1)
#define MaxColumn (2)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
   
    self.view.backgroundColor = [UIColor blackColor];
    
    
    self.lyMultiTextureFilter = [[LYMultiTextureFilter alloc] initWithMaxFilter:MaxRow * MaxColumn];

    self.cameraManager = [[Camera alloc] init];
    
    self.cameraManager.cameraScreen = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    
    self.cameraManager.cameraScreen.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    
    [self.view addSubview:self.cameraManager.cameraScreen];
    
    [self.cameraManager startCamera];

    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"];
    
    NSLog(@"path is %@",pathToMovie);
    
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 640.0)];
    self.movieWriter.shouldPassthroughAudio = YES;
    self.cameraManager.camera.audioEncodingTarget = self.movieWriter;
//     self.movie.audioEncodingTarget = self.movieWriter;
    self.movieWriter.encodingLiveVideo = YES;
    [self.movie enableSynchronizedEncodingUsingMovieWriter:self.movieWriter];
    
    
    [self setupGPUImage];
    

    [self.movieWriter startRecording];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                             target:self
                                           selector:@selector(retrievingProgress)
                                           userInfo:nil
                                            repeats:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [self.movieWriter setCompletionBlock:^{
        [weakSelf.movieWriter finishRecording];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->timer invalidate];
        });
        
        UISaveVideoAtPathToSavedPhotosAlbum(movieURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        
    }];
}
- (void)retrievingProgress
{
    NSLog(@"%f",(self.movie.progress * 100));
}
- (void)setupGPUImage{
    
    NSURL * inputMovieURL = [[NSBundle mainBundle] URLForResource:@"2222" withExtension:@"mp4"];

    self.movie = [[GPUImageMovie alloc]initWithURL:inputMovieURL];

    NSArray * moves = @[self.movie,self.cameraManager.camera];
    
    for (int indexRow = 0; indexRow < MaxRow; ++indexRow) {
        for (int indexColumn = 0; indexColumn < MaxColumn; ++indexColumn) {
            CGRect frame = CGRectMake(indexColumn * 1.0 / MaxColumn,
                                      indexRow * 1.0 / MaxRow,
                                      1.0 / MaxColumn,
                                      1.0 / MaxRow);
            [self buildGPUImageViewWithFrame:frame imageMovie:moves[indexColumn]];
        }
    }
    
    [self.lyMultiTextureFilter addTarget:self.cameraManager.cameraScreen];
    [self.lyMultiTextureFilter addTarget:self.movieWriter];
    [self.movie startProcessing];
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
    
    NSInteger index = [self.lyMultiTextureFilter nextAvailableTextureIndex];
    [tmpFilter addTarget:self.lyMultiTextureFilter atTextureLocation:index];
    [self.lyMultiTextureFilter setDrawRect:frame atIndex:index];
    
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

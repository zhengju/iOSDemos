//
//  ViewController.m
//  AVFoundation02
//
//  Created by leeco on 2019/5/6.
//  Copyright © 2019 zsw. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>

#import "ZJSimpleEditor.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
@interface playerView()


@end

@implementation playerView
+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}
- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

@end


@interface ViewController ()

@property(nonatomic, strong) AVURLAsset * asset;
@property(nonatomic, strong) AVPlayer * player;
@property(nonatomic, strong) ZJSimpleEditor * editor;
@property(nonatomic, strong) NSMutableArray * localPaths;
@property(nonatomic, strong) NSMutableArray * clips;
@end

@implementation ViewController
- (NSMutableArray *)clips{
    if (_clips == nil) {
        _clips = [NSMutableArray arrayWithCapacity:0];
    }
    return _clips;
}
- (NSMutableArray *)localPaths{
    if (_localPaths == nil) {
        _localPaths = [NSMutableArray arrayWithCapacity:0];
    }
    return _localPaths;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    NSString * path = [[NSBundle mainBundle]pathForResource:@"良品铺子" ofType:@"mp4"];
    
    self.asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    
    AVPlayerItem * playeritem = [[AVPlayerItem alloc]initWithAsset:self.asset];
    
    self.player = [AVPlayer playerWithPlayerItem:playeritem];
    
    playerView * view = [[playerView alloc]initWithFrame:CGRectMake(0, 88, KScreenWidth, 300)];

    view.player = self.player;
    
    [self.view addSubview:view];
    
//    __weak typeof(self) weakSelf = self;

    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    NSArray *assetKeysToLoadAndTest = @[@"tracks", @"duration", @"composable"];
    
    
    [self clipAction:^{
        
      
    }];

    sleep(1);
    for (NSString * path  in self.localPaths) {
        AVURLAsset * asset  = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
        [self loadAsset:asset withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];
    }
    

    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        [self play];
    });
  
    
}
- (void)play{
    self.editor = [[ZJSimpleEditor alloc]init];
    self.editor.clips = self.clips;
    self.editor.clipTimeRanges = @[[NSValue valueWithCMTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(0, 1), CMTimeMakeWithSeconds(10, 1))],[NSValue valueWithCMTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(0, 1), CMTimeMakeWithSeconds(10, 1))]];
    self.editor.transitionDuration = CMTimeMakeWithSeconds(0.01, 30);
    [self.editor buildCompositionObjectsForPlayback];
    
    [self.player replaceCurrentItemWithPlayerItem:self.editor.playerItem];
    
    [self.player play];
}
- (void)loadAsset:(AVAsset *)asset withKeys:(NSArray *)assetKeysToLoad usingDispatchGroup:(dispatch_group_t)dispatchGroup
{
    dispatch_group_enter(dispatchGroup);
    [asset loadValuesAsynchronouslyForKeys:assetKeysToLoad completionHandler:^(){
        // First test whether the values of each of the keys we need have been successfully loaded.
        for (NSString *key in assetKeysToLoad) {
            NSError *error;
            
            if ([asset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed) {
                NSLog(@"Key value loading failed for key:%@ with error: %@", key, error);
                goto bail;
            }
        }
        if (![asset isComposable]) {
            NSLog(@"Asset is not composable");
            goto bail;
        }
        
        [self.clips addObject:asset];
        // This code assumes that both assets are atleast 5 seconds long.
//        [self.clipTimeRanges addObject:[NSValue valueWithCMTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(0, 1), CMTimeMakeWithSeconds(5, 1))]];
    bail:
        dispatch_group_leave(dispatchGroup);
    }];
}

- (void)clipAction:(void(^)(void))SuccessBlock{
    
    CGSize videoSize = [[[self.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
    
    NSDictionary * clip0 = @{@"start":@(0),
                             @"duration":@(10)
                             };
    
    NSDictionary * clip1 = @{@"start":@(33),
                             @"duration":@(10)
                             };
    
    
    NSArray * clips = @[clip0,clip1];
    
    for (int i = 0 ; i < clips.count ; i++) {
        
        NSDictionary * clip = clips[i];
        
        CGFloat start = [clip[@"start"] floatValue];
        CGFloat duration = [clip[@"duration"] floatValue];
        
        //开始时间
        CMTime startCropTime = CMTimeMakeWithSeconds(start, 30);
        //结束时间
        CMTime endCropTime = CMTimeMakeWithSeconds(duration, 30);
        
        CMTimeRange tiemRange = CMTimeRangeMake(startCropTime, endCropTime);
        
        AVMutableComposition * mixComposition = [AVMutableComposition composition];
        AVMutableCompositionTrack * videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableCompositionTrack * audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        NSArray *  videoTracks = [self.asset tracksWithMediaType:AVMediaTypeVideo];
        
        NSArray *  audioTracks = [self.asset tracksWithMediaType:AVMediaTypeAudio];
        
        NSError * error ;
        
        if (videoTracks.count > 0) {
            [videoTrack insertTimeRange:tiemRange ofTrack:[videoTracks lastObject] atTime:kCMTimeZero error:&error];
        }
        if (audioTracks.count > 0) {
            [audioTrack insertTimeRange:tiemRange ofTrack:[audioTracks lastObject] atTime:kCMTimeZero error:&error];
        }
        
        
        AVMutableVideoCompositionInstruction * mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoTrack.timeRange.duration);
        
        AVMutableVideoCompositionLayerInstruction * videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        mainInstruction.layerInstructions = [NSArray arrayWithObject:videolayerInstruction];
        
        AVMutableVideoComposition * mainComposition = [AVMutableVideoComposition videoComposition];
        mainComposition.renderSize = videoSize;
        mainComposition.instructions = [NSArray arrayWithObject:mainInstruction];
        mainComposition.frameDuration = CMTimeMake(1, 30);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.mp4",@"zhengju",i]];
        
        [self.localPaths addObject:myPathDocs];
        
        NSLog(@"path is %@",myPathDocs);
        unlink([myPathDocs UTF8String]);
        NSURL* videoUrl = [NSURL fileURLWithPath:myPathDocs];
        
        AVAssetExportSession * exporter = [[AVAssetExportSession alloc]initWithAsset:mixComposition presetName:AVAssetExportPresetLowQuality];
        exporter.outputURL=videoUrl;
        exporter.outputFileType = AVFileTypeMPEG4;
        exporter.shouldOptimizeForNetworkUse = YES;
        exporter.videoComposition = mainComposition;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                
                if (SuccessBlock && exporter.progress == 1) {
                    SuccessBlock();
                }
                
                //这里是输出视频之后的操作
                //            [self cropExportDidFinish:exporter];
            });
        }];
        
    }
}


- (void)cropExportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __block PHObjectPlaceholder *placeholder;
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outputURL.path)) {
                NSError *error;
                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                    PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputURL];
                    placeholder = [createAssetRequest placeholderForCreatedAsset];
                } error:&error];
                if (error) {
                }
                else{
                    NSLog(@"视频已经保存到相册");
                }
            }else {
            }
        });
    }
    else{
        NSLog(@"%@",session.error);
    }
}


@end

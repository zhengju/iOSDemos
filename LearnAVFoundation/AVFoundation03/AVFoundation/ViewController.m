//
//  ViewController.m
//  AVFoundation
//
//  Created by leeco on 2019/5/7.
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

    dispatch_group_t dispatchGroup = dispatch_group_create();
    NSArray *assetKeysToLoadAndTest = @[@"tracks", @"duration", @"composable"];

    [self loadAsset:self.asset withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];

    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        
        [self play];
        [self expoerAction];
    });

}

- (void)play{
    self.editor = [[ZJSimpleEditor alloc]init];
    self.editor.clips = self.clips;
    self.editor.clipTimeRanges = @[[NSValue valueWithCMTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(40, 1), CMTimeMakeWithSeconds(10, 1))],[NSValue valueWithCMTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(10, 1), CMTimeMakeWithSeconds(10, 1))],[NSValue valueWithCMTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(50, 1), CMTimeMakeWithSeconds(10, 1))]];
    self.editor.transitionDuration = CMTimeMakeWithSeconds(1, 30);
    [self.editor buildCompositionObjectsForPlayback];
    
    [self.player replaceCurrentItemWithPlayerItem:self.editor.playerItem];
    
    [self.player play];
    
   
}
- (void)expoerAction{
    /**********导出视频**********/
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",@"zheng---ju"]];
    
    unlink([myPathDocs UTF8String]);
    NSURL* videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    AVAssetExportSession * exporter = [[AVAssetExportSession alloc]initWithAsset:self.editor.composition presetName:AVAssetExportPresetLowQuality];
    exporter.outputURL=videoUrl;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = self.editor.videoComposition;
    exporter.audioMix = self.editor.audioMix;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        
        NSLog(@"video path is %@",myPathDocs);
        
    }];
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
        
    bail:
        dispatch_group_leave(dispatchGroup);
    }];
}

@end

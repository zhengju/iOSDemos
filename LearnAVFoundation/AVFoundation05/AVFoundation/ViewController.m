//
//  ViewController.m
//  AVFoundation
//
//  Created by leeco on 2019/5/7.
//  Copyright © 2019 zsw. All rights reserved.
//
#import "ViewController.h"
#import <Photos/Photos.h>
#import "VideoAudioCompositionManager.h"
#import "CZHChooseCoverController.h"
#import "ZJWriterManager.h"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
@interface PlayerView()


@end

@implementation PlayerView
+ (Class)layerClass {
    return [AVPlayerLayer class];
}
- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}
- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIButton * playBtn = [[UIButton alloc]init];
        [playBtn setBackgroundColor:[UIColor redColor]];
        [self addSubview:playBtn];
        [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.with.height.mas_equalTo(45);
            make.center.mas_equalTo(self);
        }];
        WeakObj(self)
        [playBtn bk_addEventHandler:^(id sender) {
            playBtn.selected = !playBtn.selected;
            if ([self.delegate respondsToSelector:@selector(playerView:playOrPause:)]) {
                [self.delegate playerView:self playOrPause:playBtn.selected];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

@end

@interface ViewController ()<PlayerViewDelegate>

@property(nonatomic, strong) AVURLAsset * asset;
@property(nonatomic, strong) AVPlayer * player;
@property(nonatomic, strong) AVPlayerItem * playerItem;
@property(nonatomic, strong) NSMutableArray * clips;
@property(nonatomic, strong) NSURL * videoFilePath;
@property(nonatomic, strong) ZJWriterManager * writer;
@property(nonatomic, strong) NSURL *filePath;
@property(nonatomic, strong) PlayerView * playerDisplayview;
@end

@implementation ViewController
- (NSMutableArray *)clips{
    if (_clips == nil) {
        _clips = [NSMutableArray arrayWithCapacity:0];
    }
    return _clips;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self configurePlayer];
    
    [self configureChoiceBtn];

    self.writer = [[ZJWriterManager alloc]init];
    
    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"temp.mp4"]];
    
    self.filePath =  [NSURL fileURLWithPath:tempPath];
    
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:NULL];

    UISlider * slider = [[UISlider alloc]init];
    [self.view addSubview:slider];
    slider.minimumValue = 0.0;
    slider.maximumValue = CMTimeGetSeconds(self.asset.duration);
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.playerDisplayview.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
    }];
}
- (void)sliderAction:(UISlider*)slider{
    NSLog(@"%f",slider.value);
    CMTimeShow(self.playerItem.currentTime);
    [self.player seekToTime:CMTimeMakeWithSeconds(slider.value, 30) completionHandler:^(BOOL finished) {
        
    }];
}
- (void)configurePlayer{
    NSString * path = [[NSBundle mainBundle]pathForResource:@"良品铺子" ofType:@"mp4"];
    
    self.videoFilePath =  [NSURL fileURLWithPath:path];

    self.asset = [AVURLAsset assetWithURL:self.videoFilePath];
    
    self.playerItem = [[AVPlayerItem alloc]initWithAsset:self.asset];
    
    self.player = [[AVPlayer alloc]init];

    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    
    self.playerDisplayview = [[PlayerView alloc]initWithFrame:CGRectMake(0, 88, KScreenWidth, 300)];
    self.playerDisplayview.delegate = self;
    self.playerDisplayview.player = self.player;
    
//    [self.player play];
    
    [self.view addSubview:self.playerDisplayview];
    
}
- (void)configureChoiceBtn{
    UIButton * choiceBtn = [[UIButton alloc]init];
    WeakObj(self);
    [choiceBtn bk_addEventHandler:^(id sender) {
        
        [selfWeak chooseCover];
        
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:choiceBtn];
    [choiceBtn setTitle:@"点击替换封面" forState:UIControlStateNormal];
    [choiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-100);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}
- (void)chooseCover{
    CZHChooseCoverController *chooseCover = [[CZHChooseCoverController alloc] init];
    chooseCover.videoPath = self.videoFilePath;
    chooseCover.coverImageBlock = ^(UIImage *coverImage) {
        
        [[NSFileManager defaultManager] removeItemAtPath:self.filePath.path error:NULL];
        [self.writer.images addObject:coverImage];
        [self.writer writeVideoSize:CGSizeMake(1280, 720) path:self.filePath success:^() {
            [self compositionAction];
        }];
    };
    
    [self presentViewController:chooseCover animated:YES completion:nil];
}

- (void)compositionAction{
    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    NSArray *assetKeysToLoadAndTest = @[@"tracks", @"duration", @"composable"];

    AVURLAsset * asset2 = [AVURLAsset assetWithURL:self.filePath];//封面视频
    
    AVURLAsset * asset1 = [AVURLAsset assetWithURL:self.videoFilePath];

    [self loadAsset:asset2 withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];
    
    [self loadAsset:asset1 withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];

    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){

        NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:
                                  [NSString stringWithFormat:@"temp22.mp4"]];
        
        NSLog(@"path : %@",tempPath);
        
        [[NSFileManager defaultManager] removeItemAtPath:tempPath error:NULL];

        NSURL * filePath =  [NSURL fileURLWithPath:tempPath];

        VideoAudioCompositionManager * manager = [[VideoAudioCompositionManager alloc]init];
        
        [manager compositionAssets:self.clips Path:filePath success:^(NSURL * _Nullable fileUrl) {

           
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.asset = [AVURLAsset assetWithURL:filePath];

                self.playerItem = [[AVPlayerItem alloc]initWithAsset:self.asset];

                [self.player  replaceCurrentItemWithPlayerItem:self.playerItem];

                [self.player pause];

            });

        }];
        
    });
    
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
#pragma mark - PlayerViewViewDelegate
- (void)playerView:(PlayerView *)playerView playOrPause:(BOOL)play{
    if (play) {
        [self.player play];
    }else{
        [self.player pause];
    }
}
@end

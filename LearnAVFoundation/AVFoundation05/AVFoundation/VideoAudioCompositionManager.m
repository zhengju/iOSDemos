//
//  VideoAudioCompositionManager.m
//  AVFoundation
//
//  Created by leeco on 2019/5/16.
//  Copyright © 2019 zsw. All rights reserved.
//

#import "VideoAudioCompositionManager.h"

@implementation VideoAudioCompositionManager
- (void)compositionAssets:(NSArray<AVURLAsset*>*)assets Path:(NSURL*)path success:(SuccessBlcok)successBlcok{

    AVMutableComposition *composition = [AVMutableComposition composition];
    // 视频通道
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    // 音频通道
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime atTime = kCMTimeZero;
    
    for (int i = 0; i < assets.count; i++) {
        
        AVURLAsset *videoAsset = assets[i];
        
        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);

        AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];

        [videoTrack insertTimeRange:timeRange ofTrack:videoAssetTrack atTime:atTime error:nil];

        AVAssetTrack *audioAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];

        [audioTrack insertTimeRange:timeRange ofTrack:audioAssetTrack atTime:atTime error:nil];
        
        atTime = CMTimeAdd(atTime, timeRange.duration);
    }
      [self composition:composition storePath:path success:successBlcok];
}
//输出
- (void)composition:(AVMutableComposition *)avComposition
          storePath:(NSURL *)storePath
            success:(SuccessBlcok)successBlcok
{
    // 创建一个输出
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:avComposition presetName:AVAssetExportPresetLowQuality];
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    // 输出地址
    assetExport.outputURL = storePath;
    // 优化
    assetExport.shouldOptimizeForNetworkUse = YES;
    
    __block NSTimer *timer = nil;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@" 打印信息:%f",assetExport.progress);
//        if (self.progressBlock) {
//            self.progressBlock(assetExport.progress);
//        }
    }];
    // 合成完毕
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        // 回到主线程
        switch (assetExport.status) {
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"exporter Unknow");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"exporter Canceled");
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"%@", [NSString stringWithFormat:@"exporter Failed%@",assetExport.error.description]);
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"exporter Waiting");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"exporter Exporting");
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"exporter Completed");
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 调用播放方法
                    successBlcok(storePath);
                });
                break;
        }
    }];
}

@end

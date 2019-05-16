//
//  VideoAudioCompositionManager.h
//  AVFoundation
//
//  Created by leeco on 2019/5/16.
//  Copyright © 2019 zsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

/**
 合成成功block
 
 @param fileUrl 合成后的地址
 */
typedef void(^SuccessBlcok)(NSURL * _Nullable fileUrl);


/**
 合成进度block
 
 @param progress 进度
 */
typedef void(^CompositionProgress)(CGFloat progress);


/**
 
 @param image 图片
 @param error 错误
 
 */
typedef  void(^CompleteBlock)(UIImage * _Nullable image,NSError * _Nullable error);

@interface VideoAudioCompositionManager : NSObject



- (void)compositionAssets:(NSArray<AVURLAsset*>*)assets Path:(NSURL*)path success:(SuccessBlcok)successBlcok;
@end

NS_ASSUME_NONNULL_END

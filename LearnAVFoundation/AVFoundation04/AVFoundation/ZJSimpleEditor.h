
#import <Foundation/Foundation.h>
#import <CoreMedia/CMTime.h>
#import <AVFoundation/AVFoundation.h>


typedef NS_ENUM(NSInteger, TransitionType)
{
    kTransitionTypeNone = 0,
    kTransitionTypePushHorizontalSpinFromRight = 1,
    kTransitionTypePushHorizontalFromRight,
    kTransitionTypePushHorizontalFromLeft,
    kTransitionTypePushVerticalFromBottom,
    kTransitionTypePushVerticalFromTop,
    kTransitionTypeCrossFade,//溶解
    kTransitionTypeCropRectangle,//向四角擦除
    kTransitionTypeMiddleTransform,//从四边向中间消失
    kTransitionTypeLeftAndRightToMiddleTransform,//左右到中间合成
    kTransitionTypeUpAndDownToMiddleTransform,//上下到中间合成
    kTransitionTypeLeftAndRightToMiddleInUpDownTransform,//上下各一半左右到中间合成
    kTransitionTypeUpAndDownToMiddleInLeftRightTransform,//左右各一半上下到中间合成
    kTransitionTypeUpDownLeftAndRightToMiddleTransform,//上下左右角到中间合成
    kTransitionTypeFadeInAndFadeOut,//淡入淡出
};

@interface ZJSimpleEditor : NSObject

// Set these properties before building the composition objects.
@property (nonatomic, copy) NSArray *clips; // array of AVURLAssets
@property (nonatomic, copy) NSArray *clipTimeRanges; // array of CMTimeRanges stored in NSValues.
@property(nonatomic, strong) NSMutableArray * transitionTypes;
@property (nonatomic) CMTime transitionDuration;

@property (nonatomic, readonly, retain) AVMutableComposition *composition;
@property (nonatomic, readonly, retain) AVMutableVideoComposition *videoComposition;
@property (nonatomic, readonly, retain) AVMutableAudioMix *audioMix;

// Builds the composition and videoComposition
- (void)buildCompositionObjectsForPlayback;

- (AVPlayerItem *)playerItem;

@end


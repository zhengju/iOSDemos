
#import "ZJSimpleEditor.h"
#import <CoreMedia/CoreMedia.h>

@interface ZJSimpleEditor ()
@property (nonatomic, readwrite, retain) AVMutableComposition *composition;
@property (nonatomic, readwrite, retain) AVMutableVideoComposition *videoComposition;
@property (nonatomic, readwrite, retain) AVMutableAudioMix *audioMix;
@property(nonatomic, strong) NSMutableArray *compositionVideoTracks;
@property(nonatomic, strong) NSMutableArray *compositionAudioTracks;
@end

@implementation ZJSimpleEditor
- (NSMutableArray *)compositionAudioTracks{
    if (_compositionAudioTracks == nil) {
        _compositionAudioTracks = [NSMutableArray arrayWithCapacity:0];
    }
    return _compositionAudioTracks;
}
- (NSMutableArray *)compositionVideoTracks{
    if (_compositionVideoTracks == nil) {
        _compositionVideoTracks = [NSMutableArray arrayWithCapacity:0];
    }
    return _compositionVideoTracks;
}
- (NSMutableArray *)transitionTypes{
    if (_transitionTypes == nil) {
        _transitionTypes = [NSMutableArray arrayWithCapacity:0];
    }
    return _transitionTypes;
}
- (void)buildTransitionComposition:(AVMutableComposition *)composition andVideoComposition:(AVMutableVideoComposition *)videoComposition andAudioMix:(AVMutableAudioMix *)audioMix
{
	CMTime nextClipStartTime = kCMTimeZero;
	NSInteger i;
	NSUInteger clipsCount = [self.clipTimeRanges count];
	
	// Make transitionDuration no greater than half the shortest clip duration.
	CMTime transitionDuration = self.transitionDuration;
	for (i = 0; i < clipsCount; i++ ) {
		NSValue *clipTimeRange = [self.clipTimeRanges objectAtIndex:i];
		if (clipTimeRange) {
			CMTime halfClipDuration = [clipTimeRange CMTimeRangeValue].duration;
			halfClipDuration.timescale *= 2; // You can halve a rational by doubling its denominator.
			transitionDuration = CMTimeMinimum(transitionDuration, halfClipDuration);
		}
	}

    [self.compositionAudioTracks removeAllObjects];
    [self.compositionVideoTracks removeAllObjects];
    
    
    for (int i = 0; i < clipsCount; i++) {

        [self.compositionVideoTracks addObject: [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid]];
        [self.compositionAudioTracks addObject: [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid] ];
    }

	CMTimeRange *passThroughTimeRanges = alloca(sizeof(CMTimeRange) * clipsCount);
	CMTimeRange *transitionTimeRanges = alloca(sizeof(CMTimeRange) * clipsCount);
	
	// Place clips into alternating video & audio tracks in composition, overlapped by transitionDuration.
	for (i = 0; i < clipsCount; i++ ) {
		AVURLAsset *asset = [self.clips objectAtIndex:0];
		NSValue *clipTimeRange = [self.clipTimeRanges objectAtIndex:i];
		CMTimeRange timeRangeInAsset;
		if (clipTimeRange)
			timeRangeInAsset = [clipTimeRange CMTimeRangeValue];
		else
			timeRangeInAsset = CMTimeRangeMake(kCMTimeZero, [asset duration]);
		
        NSArray * videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        if (videoTracks.count > 0) {
            AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            [self.compositionVideoTracks[i] insertTimeRange:timeRangeInAsset ofTrack:clipVideoTrack atTime:nextClipStartTime error:nil];
        }
        NSArray * audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
        if (audioTracks.count > 0) {
            AVAssetTrack *clipAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
            [self.compositionAudioTracks[i] insertTimeRange:timeRangeInAsset ofTrack:clipAudioTrack atTime:nextClipStartTime error:nil];
        }
        CMTimeShow(nextClipStartTime);

		passThroughTimeRanges[i] = CMTimeRangeMake(nextClipStartTime, timeRangeInAsset.duration);
		if (i > 0) {
			passThroughTimeRanges[i].start = CMTimeAdd(passThroughTimeRanges[i].start, transitionDuration);
			passThroughTimeRanges[i].duration = CMTimeSubtract(passThroughTimeRanges[i].duration, transitionDuration);
		}
		if (i+1 < clipsCount) {
			passThroughTimeRanges[i].duration = CMTimeSubtract(passThroughTimeRanges[i].duration, transitionDuration);
		}
		
		// The end of this clip will overlap the start of the next by transitionDuration.
		// (Note: this arithmetic falls apart if timeRangeInAsset.duration < 2 * transitionDuration.)
		nextClipStartTime = CMTimeAdd(nextClipStartTime, timeRangeInAsset.duration);
        nextClipStartTime = CMTimeSubtract(nextClipStartTime, transitionDuration);
		
		// Remember the time range for the transition to the next item.
		if (i+1 < clipsCount) {
			transitionTimeRanges[i] = CMTimeRangeMake(nextClipStartTime, transitionDuration);
		}
	}
	
	// Set up the video composition if we are to perform crossfade transitions between clips.
	NSMutableArray *instructions = [NSMutableArray array];
	NSMutableArray *trackMixArray = [NSMutableArray array];
	
	// Cycle between "pass through A", "transition from A to B", "pass through B"
	for (i = 0; i < clipsCount; i++ ) {

		AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
		passThroughInstruction.timeRange = passThroughTimeRanges[i];
		AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:self.compositionVideoTracks[i]];//由track轨道初始化layer层对象
		
		passThroughInstruction.layerInstructions = [NSArray arrayWithObject:passThroughLayer];
		[instructions addObject:passThroughInstruction];
		
		if (i+1 < clipsCount) {
            
            TransitionType type = kTransitionTypeNone;
            if (self.transitionTypes.count >i) {
                type = [self.transitionTypes[i] integerValue];
            }
            
            AVMutableVideoCompositionInstruction *transitionInstruction = [self transitionInstructionWith:self.compositionVideoTracks[i] next:self.compositionVideoTracks[i+1] timeRange:transitionTimeRanges[i] transitionType:type];
			[instructions addObject:transitionInstruction];

		}
	}
    
    // Add AudioMix to fade in the volume ramps
    AVMutableAudioMixInputParameters *trackMix1 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:self.compositionAudioTracks[0]];
    
    [trackMix1 setVolumeRampFromStartVolume:1.0 toEndVolume:0.0 timeRange:transitionTimeRanges[0]];
    
    [trackMixArray addObject:trackMix1];
    
    AVMutableAudioMixInputParameters *trackMix2 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:self.compositionAudioTracks[1]];
    
    //            [trackMix2 setVolumeRampFromStartVolume:0.0 toEndVolume:1.0 timeRange:transitionTimeRanges[0]];
    [trackMix2 setVolumeRampFromStartVolume:1.0 toEndVolume:0.0 timeRange:passThroughTimeRanges[1]];
    [trackMixArray addObject:trackMix2];
    
    AVMutableAudioMixInputParameters *trackMix3 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:self.compositionAudioTracks[2]];
    
    [trackMix3 setVolume:1.0 atTime:CMTimeMake(2*30, 30)];
    
    [trackMixArray addObject:trackMix3];
    
	audioMix.inputParameters = trackMixArray;
	videoComposition.instructions = instructions;
}

#pragma mark - 转场layer
- (AVMutableVideoCompositionInstruction *)transitionInstructionWith:(AVMutableCompositionTrack *)compositionVideoTrack
                                                               next:(AVMutableCompositionTrack *)nextcompositionVideoTrack
                                                          timeRange:(CMTimeRange )transitionTimeRange
                                                     transitionType:(TransitionType)transitionType{
    
    AVMutableVideoCompositionInstruction *transitionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    transitionInstruction.timeRange = transitionTimeRange;
    
    AVMutableVideoCompositionLayerInstruction *fromLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];//当前视频track

    AVMutableVideoCompositionLayerInstruction *toLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];//下一个视频track
    // Fade in the toLayer by setting a ramp from 0.0 to 1.0.
    [toLayer setOpacityRampFromStartOpacity:0.0 toEndOpacity:1.0 timeRange:transitionTimeRange];

    
    CGFloat videoWidth = compositionVideoTrack.naturalSize.width;
    CGFloat videoHeight = compositionVideoTrack.naturalSize.height;
    
    switch (transitionType)
    {
            
        case kTransitionTypeNone:
        {
            [toLayer setOpacity:1.0 atTime:kCMTimeZero];
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer ,nil];
            break;
        }
        case kTransitionTypeCrossFade://溶解
        {
            // Fade out the fromLayer by setting a ramp from 1.0 to 0.0.
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRange];
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];
            break;
        }
        case kTransitionTypeCropRectangle:
        {

            
            AVMutableVideoCompositionLayerInstruction *fromLayerRightup = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *fromLayerLeftup = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *fromLayerLeftDown = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
            
            //右下
            CGRect startRect = CGRectMake(videoWidth/2.0, videoHeight/2.0, videoWidth/2.0, videoHeight/2.0);
            CGRect endRect = CGRectMake(videoWidth, videoHeight, 0.0f, 0.0f);
            //通过裁剪实现擦除
            [fromLayer setCropRectangleRampFromStartCropRectangle:startRect toEndCropRectangle:endRect timeRange:transitionTimeRange];
            //右上
            startRect = CGRectMake(videoWidth/2.0, 0, videoWidth/2.0, videoHeight/2.0);
            endRect = CGRectMake(videoWidth, 0.0f, 0.0f, 0.0f);
            //通过裁剪实现擦除
            [fromLayerRightup setCropRectangleRampFromStartCropRectangle:startRect toEndCropRectangle:endRect timeRange:transitionTimeRange];
            //左上
            startRect = CGRectMake(0, 0, videoWidth/2.0, videoHeight/2.0);
            endRect = CGRectZero;
            //通过裁剪实现擦除
            [fromLayerLeftup setCropRectangleRampFromStartCropRectangle:startRect toEndCropRectangle:endRect timeRange:transitionTimeRange];
            //左上
            startRect = CGRectMake(0, videoHeight/2.0, videoWidth/2.0, videoHeight/2.0);
            endRect = CGRectMake(0, videoHeight, 0.0f, 0.0f);
            //通过裁剪实现擦除
            [fromLayerLeftDown setCropRectangleRampFromStartCropRectangle:startRect toEndCropRectangle:endRect timeRange:transitionTimeRange];
            
             transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer,fromLayerRightup,fromLayerLeftup,fromLayerLeftDown, nil];
            
            break;
        }
        case kTransitionTypePushHorizontalSpinFromRight:
        {
            CGAffineTransform scaleT = CGAffineTransformMakeScale(0.1, 0.1);
            CGAffineTransform rotateT = CGAffineTransformMakeRotation(M_PI);
            CGAffineTransform transform = CGAffineTransformTranslate(CGAffineTransformConcat(scaleT, rotateT), 1, 1);
            [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:transform timeRange:transitionTimeRange];
             transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];
            
            break;
        }
        case kTransitionTypeMiddleTransform:
        {
            CGAffineTransform scaleT = CGAffineTransformMakeScale(0.001, 0.001);
            CGAffineTransform transform = CGAffineTransformTranslate(scaleT, videoWidth*500,videoHeight*500);
            [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:transform timeRange:transitionTimeRange];
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];
            
            break;
        }
        case kTransitionTypePushHorizontalFromRight:
        {
            [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeTranslation(-videoWidth, 0) timeRange:transitionTimeRange];

            [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            
             transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];
            
            break;
        }
            
        
            case kTransitionTypeLeftAndRightToMiddleInUpDownTransform:
        {
            
            
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRange];
            
            AVMutableVideoCompositionLayerInstruction *toLayerLeft = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *toLayerRight = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            
            
            [toLayerLeft setCropRectangle:CGRectMake(0, 0, videoWidth, videoHeight/2.0) atTime:kCMTimeZero];
            [toLayerLeft setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            
            [toLayerRight setCropRectangle:CGRectMake(0, videoHeight/2.0, videoWidth, videoHeight/2.0) atTime:kCMTimeZero];
            [toLayerRight setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayerRight,toLayerLeft, fromLayer, nil];
            break;
        }
            
            case kTransitionTypeMultiLeftRightToMiddleInUpDownTransform:
        {
            /**
                 <---R
             L--->
                 <---R
             L--->
                 <---R
             **/
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRange];
            
            AVMutableVideoCompositionLayerInstruction *toLayerRight1 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];///<---R
            AVMutableVideoCompositionLayerInstruction *toLayerLeft1 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];///L--->
            AVMutableVideoCompositionLayerInstruction *toLayerRight2 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];///<---R
            AVMutableVideoCompositionLayerInstruction *toLayerLeft2 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];///L--->
             AVMutableVideoCompositionLayerInstruction *toLayerRight3 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];///<---R

            CGFloat height = videoHeight/5.0;
            
            [toLayerRight1 setCropRectangle:CGRectMake(0, 0, videoWidth, height) atTime:kCMTimeZero];
            [toLayerRight1 setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            [toLayerLeft1 setCropRectangle:CGRectMake(0, height, videoWidth, height) atTime:kCMTimeZero];
            [toLayerLeft1 setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            [toLayerRight2 setCropRectangle:CGRectMake(0, height*2, videoWidth, height) atTime:kCMTimeZero];
            [toLayerRight2 setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            [toLayerLeft2 setCropRectangle:CGRectMake(0, height*3, videoWidth, height) atTime:kCMTimeZero];
            [toLayerLeft2 setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            [toLayerRight3 setCropRectangle:CGRectMake(0, height*4, videoWidth, height) atTime:kCMTimeZero];
            [toLayerRight3 setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayerRight1,toLayerLeft1,toLayerRight2,toLayerLeft2,toLayerRight3, fromLayer, nil];
            break;
        }
        
        case kTransitionTypeLeftAndRightToMiddleTransform:
        {

            
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRange];
            
            AVMutableVideoCompositionLayerInstruction *toLayerLeft = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *toLayerRight = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            
          
            [toLayerLeft setCropRectangle:CGRectMake(0, 0, videoWidth/2.0, videoHeight) atTime:kCMTimeZero];
            [toLayerLeft setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-videoWidth/2.0, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            [toLayerRight setCropRectangle:CGRectMake(videoWidth/2.0, 0, videoWidth/2.0, videoHeight) atTime:kCMTimeZero];
            [toLayerRight setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth/2.0, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            
           transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayerRight,toLayerLeft, fromLayer, nil];
            break;
        }
        case kTransitionTypeUpAndDownToMiddleInLeftRightTransform:
        {
            
            
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRange];
            
            AVMutableVideoCompositionLayerInstruction *toLayerUp = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *toLayerDown = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            
             [toLayerUp setTransform:CGAffineTransformScale(CGAffineTransformMakeRotation(-1.0), 1.5, 1) atTime:kCMTimeZero];
            [toLayerUp setCropRectangle:CGRectMake(0, 0, videoWidth/2.0, videoHeight*2) atTime:kCMTimeZero];
            
            [toLayerUp setTransformRampFromStartTransform:CGAffineTransformScale(CGAffineTransformMakeRotation(-1.0), 1.5, 1) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

           
            
            
            [toLayerDown setCropRectangle:CGRectMake(videoWidth/2.0, 0, videoWidth/2.0, videoHeight) atTime:kCMTimeZero];
            [toLayerDown setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(0, videoHeight) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayerUp,toLayerDown, fromLayer, nil];
            break;
        }
        case kTransitionTypeUpDownLeftAndRightToMiddleTransform:
        {
            
            
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRange];
            
            AVMutableVideoCompositionLayerInstruction *toLayerUpLeft = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *toLayerUpRight = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *toLayerDownLeft = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *toLayerDownRight = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            
            [toLayerUpLeft setCropRectangle:CGRectMake(0, 0, videoWidth/2.0, videoHeight/2.0) atTime:kCMTimeZero];
            [toLayerUpLeft setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-videoWidth/2.0, -videoHeight/2.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            
            [toLayerUpRight setCropRectangle:CGRectMake(videoWidth/2.0, 0, videoWidth/2.0, videoHeight/2.0) atTime:kCMTimeZero];
            [toLayerUpRight setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth/2.0, -videoHeight/2.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            
            [toLayerDownLeft setCropRectangle:CGRectMake(0, videoHeight/2.0, videoWidth/2.0, videoHeight/2.0) atTime:kCMTimeZero];
            [toLayerDownLeft setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-videoWidth/2.0, videoHeight/2.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            
            [toLayerDownRight setCropRectangle:CGRectMake(videoWidth/2.0, videoHeight/2.0, videoWidth/2.0, videoHeight/2.0) atTime:kCMTimeZero];
            [toLayerDownRight setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth/2.0, videoHeight/2.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayerUpLeft,toLayerDownLeft,toLayerDownRight,toLayerUpRight, fromLayer, nil];
            break;
        }
            
        case kTransitionTypeUpAndDownToMiddleTransform:
        {
            
            
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRange];
            
            AVMutableVideoCompositionLayerInstruction *toLayerUp = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *toLayerDown = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            
            [toLayerUp setCropRectangle:CGRectMake(0, 0, videoWidth, videoHeight/2.0) atTime:kCMTimeZero];
            [toLayerUp setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(0, -videoHeight/2.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            
            [toLayerDown setCropRectangle:CGRectMake(0.0, videoHeight/2.0, videoWidth, videoHeight/2.0) atTime:kCMTimeZero];
            [toLayerDown setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(0, videoHeight/2.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayerUp,toLayerDown, fromLayer, nil];
            
            break;
        }
        case kTransitionTypePushHorizontalFromLeft://水平从左至右
        {
            [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeTranslation(compositionVideoTrack.naturalSize.width, 0.0) timeRange:transitionTimeRange];
            
            [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-compositionVideoTrack.naturalSize.width, 0.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
             transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];
            break;
        }
        case kTransitionTypePushVerticalFromBottom:
        {
            [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeTranslation(0, -compositionVideoTrack.naturalSize.height) timeRange:transitionTimeRange];
            
            [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(0, +compositionVideoTrack.naturalSize.height) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
             transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];
            break;
        }
        case kTransitionTypePushVerticalFromTop:
        {
            [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeTranslation(0, compositionVideoTrack.naturalSize.height) timeRange:transitionTimeRange];
            
            [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(0, -compositionVideoTrack.naturalSize.height) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            
                transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];
            
            break;
        }
        default:
            break;
    }


    return transitionInstruction;
}

- (void)buildCompositionObjectsForPlayback
{
	if ( (self.clips == nil) || [self.clips count] == 0 ) {
		self.composition = nil;
		self.videoComposition = nil;
		return;
	}
	
	CGSize videoSize = [[self.clips objectAtIndex:0] naturalSize];
	AVMutableComposition *composition = [AVMutableComposition composition];
	AVMutableVideoComposition *videoComposition = nil;
	AVMutableAudioMix *audioMix = nil;
	
	composition.naturalSize = videoSize;
	
	// With transitions:
	// Place clips into alternating video & audio tracks in composition, overlapped by transitionDuration.
	// Set up the video composition to cycle between "pass through A", "transition from A to B",
	// "pass through B"
	
	videoComposition = [AVMutableVideoComposition videoComposition];
	audioMix = [AVMutableAudioMix audioMix];
	
	[self buildTransitionComposition:composition andVideoComposition:videoComposition andAudioMix:audioMix];
	
	if (videoComposition) {
		// Every videoComposition needs these properties to be set:
		videoComposition.frameDuration = CMTimeMake(1, 30); // 30 fps
		videoComposition.renderSize = videoSize;
	}
	
	self.composition = composition;
	self.videoComposition = videoComposition;
	self.audioMix = audioMix;
}

- (AVPlayerItem *)playerItem
{
	AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:self.composition];
	playerItem.videoComposition = self.videoComposition;
	playerItem.audioMix = self.audioMix;
	
	return playerItem;
}

@end


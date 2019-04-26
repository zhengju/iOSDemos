//
//  ZJDisplayCropFilter.h
//  LearnGPUImage
//
//  Created by leeco on 2019/4/26.
//  Copyright © 2019 zsw. All rights reserved.
//

#import "GPUImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZJDisplayCropFilter : GPUImageFilter

/**
 设置绘制区域rect

 @param rect 绘制区域 origin是起始点，size是矩形大小；（取值范围是0~1）
 */
- (void)setDrawRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END

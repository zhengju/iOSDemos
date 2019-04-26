//
//  ZJDisplayCropFilter.m
//  LearnGPUImage
//
//  Created by leeco on 2019/4/26.
//  Copyright © 2019 zsw. All rights reserved.
//

#import "ZJDisplayCropFilter.h"

@interface ZJDisplayCropFilter()
@property(nonatomic, assign) CGRect rect;
@end


@implementation ZJDisplayCropFilter

- (instancetype)init{
    if (self = [super init]) {
        self.rect = CGRectMake(0, 0, 1, 1);
    }
    return self;
}

- (void)setDrawRect:(CGRect)rect{
    NSParameterAssert(rect.origin.x >= 0 && rect.origin.x <= 1 &&
                      rect.origin.y >= 0 && rect.origin.y <= 1 &&
                      rect.size.width >= 0 && rect.size.width <= 1 &&
                      rect.size.height >= 0 && rect.size.height <= 1);
    self.rect = rect;
}
- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)filterIndex {
    
    
    CGRect rect = self.rect;
    
    GLfloat vertices[] = {
            
            rect.origin.x * 2 - 1, rect.origin.y * 2 - 1, // 左下
            
            rect.origin.x * 2 - 1 + rect.size.width * 2, rect.origin.y * 2 - 1,// 右下
            
            rect.origin.x * 2 - 1, rect.origin.y * 2 - 1 + rect.size.height * 2, // 左上
           
            rect.origin.x * 2 - 1 + rect.size.width * 2, rect.origin.y * 2 - 1 + rect.size.height * 2,  // 右上
        
        };
    
    [self renderToTextureWithVertices:vertices textureCoordinates:[[self class] textureCoordinatesForRotation:inputRotation]];
   
    [self informTargetsAboutNewFrameAtTime:frameTime];

}

@end

//
//  ZJWriterManager.h
//  AVFoundation01
//
//  Created by leeco on 2019/5/16.
//  Copyright © 2019 zsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^KSuccessBlcok)(void);
@interface ZJWriterManager : NSObject
@property(nonatomic, strong) NSMutableArray<UIImage *> * images;
- (void)writeVideoSize:(CGSize)videoSize path:(NSURL *)path success:(KSuccessBlcok)successBlcok;
@end

NS_ASSUME_NONNULL_END

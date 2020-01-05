//
//  LCImageDownloadManager.h
//  LCNetworkImageView
//
//  Created by CC on 15/11/19.
//  Copyright © 2015年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LCImageDownloadManager : NSObject




+ (LCImageDownloadManager *)sharedManager;


- (UIImage *) fileExistsForResourceWithURL:(NSString*)url;

- (NSString *)storagePathWithURL:(NSURL *)URL;

- (void)cleanLocalCache;

@end

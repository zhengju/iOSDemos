//
//  LCImageDownloadManager.m
//  LCNetworkImageView
//
//  Created by CC on 15/11/19.
//  Copyright © 2015年 CC. All rights reserved.
//

#import "LCImageDownloadManager.h"
#import <CommonCrypto/CommonDigest.h>

#define kDefaultImageCacheFileName @"LCImageCache"

@interface LCImageDownloadManager ()

@property (strong) NSRecursiveLock *accessLock;

@end


@implementation LCImageDownloadManager
static LCImageDownloadManager*_shardManager;
+ (LCImageDownloadManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shardManager = [[LCImageDownloadManager alloc]init];
    });
    return _shardManager;
}

- (id)init
{
    if (self = [super init])
    {
        _accessLock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

#pragma mark - 编码相关
- (NSString *)keyForURL:(NSURL *)url
{
    if (url == nil) {
        return nil;
    }
    if ([url absoluteString].length == 0)
    {
        return nil;
    }
    NSString *oriUrl = [url absoluteString];
    if ([[oriUrl substringFromIndex:[oriUrl length]-1] isEqualToString:@"/"]) {
        oriUrl = [oriUrl substringToIndex:[oriUrl length]-1];
    }
    
    const char *cStr = [oriUrl UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

#pragma mark - 路径相关
- (NSString *)imageStorageFilePath
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *libPath = [pathList objectAtIndex:0];
    NSString *infoPath = [libPath stringByAppendingPathComponent:kDefaultImageCacheFileName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if(![fileManager fileExistsAtPath:infoPath isDirectory:&isDir] || !isDir)
    {
        [fileManager createDirectoryAtPath:infoPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return infoPath;
}

- (UIImage *) fileExistsForResourceAtURL:(NSString*)url
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString * localFile = [self getImageStoragePathWithUrl:url];
    if ([fileManager fileExistsAtPath:localFile])
    {
        UIImage * image = [UIImage imageWithContentsOfFile:localFile];
        return image;
    }
    return nil;
}

- (NSString *)getImageStoragePathWithUrl:(NSString *)urlStr
{
    NSString *destPath = [NSString stringWithFormat:@"%@/%@",[self imageStorageFilePath],[self keyForURL:[NSURL URLWithString:urlStr]]];
    return destPath;
}

#pragma mark - 外部调用
- (UIImage *) fileExistsForResourceWithURL:(NSString*)url
{
    if (!url)
    {
        return nil;
    }
    return [self fileExistsForResourceAtURL:url];
}

- (NSString *)storagePathWithURL:(NSURL *)URL
{
    if (!URL)
    {
        return nil;
    }
    return [self getImageStoragePathWithUrl:[URL absoluteString]];
}

- (void)cleanLocalCache
{
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[wSelf accessLock] lock];
        NSString *path = [wSelf imageStorageFilePath];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        BOOL isDirectory = NO;
        BOOL exists = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
        if (!exists || !isDirectory) {
            [[wSelf accessLock] unlock];
            return;
        }
        NSError *error = nil;
        NSArray *cacheFiles = [fileManager contentsOfDirectoryAtPath:path error:&error];
        if (error) {
            [[wSelf accessLock] unlock];
            [NSException raise:@"FailedToTraverseCacheDirectory" format:@"Listing cache directory failed at path '%@'",path];
        }
        for (NSString *file in cacheFiles) {
            [fileManager removeItemAtPath:[path stringByAppendingPathComponent:file] error:&error];
            if (error) {
                [[wSelf accessLock] unlock];
                [NSException raise:@"FailedToRemoveCacheFile" format:@"Failed to remove cached data at path '%@'",path];
            }
        }
        [[wSelf accessLock] unlock];
        
        
        //此处是为了及时重建根目录
        [self imageStorageFilePath];
    });
}

@end

//
//  ZJImageManager.m
//  BigAPP
//
//  Created by zhengju on 2020/1/1.
//  Copyright © 2020 zhengju. All rights reserved.
//

#import "ZJImageManager.h"

@interface ZJImageManager()<NSURLSessionDownloadDelegate>

@property(strong,nonatomic) NSURLSession * session;
@property(strong,nonatomic) NSURLSessionDownloadTask * task;
@end

@implementation ZJImageManager
-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
- (void)downloadImage{
    
    NSURL * url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576860245217&di=218393fb5d459a15607d3c31dbea302c&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201210%2F24%2F20121024114828_TtcQe.jpeg"];
   //http://img2.imgtn.bdimg.com/it/u=3344415164,12208452&fm=26&gp=0.jpg //https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576860245217&di=218393fb5d459a15607d3c31dbea302c&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201210%2F24%2F20121024114828_TtcQe.jpeg
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    config.timeoutIntervalForRequest = 30;
    
    _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    
    NSString *localFile = [NSString stringWithFormat:@"%@/%@",[self imageStorageFilePath],@"1234"];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if ([fileManager fileExistsAtPath:localFile])
    {
        UIImage * image = [UIImage imageWithContentsOfFile:localFile];
        
        NSLog(@"image is %@",image);
        
        return;
    }

    __weak typeof(self) wSelf = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        self.task = [wSelf.session downloadTaskWithRequest:request];
        
        [self.task resume];
        
    });
    
}

- (BOOL) copyTempFileAtURL:(NSURL *)location toDestination:(NSURL *)destination
{
    NSError *error;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [fileManager removeItemAtURL:destination error:NULL];
    [fileManager copyItemAtURL:location toURL:destination error:&error];
    if (error == nil) {
        return true;
    }else{
//        NSLog(@"%@",error);
        return false;
    }
}
- (NSString *)imageStorageFilePath
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *libPath = [pathList objectAtIndex:0];
    NSString *infoPath = [libPath stringByAppendingPathComponent:@"zj"];
    BOOL isDir = NO;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if(![fileManager fileExistsAtPath:infoPath isDirectory:&isDir] || !isDir)
    {
        [fileManager createDirectoryAtPath:infoPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return infoPath;
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"--location is %@",location);
    //必须及时copy
    
    NSString *localPath = [NSString stringWithFormat:@"%@/%@",[self imageStorageFilePath],@"1234"];
 
    NSLog(@"--destination is %@",localPath);
    
    NSURL *destination = [NSURL fileURLWithPath:localPath];
    BOOL success = NO;
    NSData * data = [NSData dataWithContentsOfURL:location];
    if (data && data.length != 0)
    {
        success = [self copyTempFileAtURL:location toDestination:destination];
    }
    
    if (success) {
        NSLog(@"copy ok");
    }
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSLog(@"error is %@",error.userInfo);
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
}

@end

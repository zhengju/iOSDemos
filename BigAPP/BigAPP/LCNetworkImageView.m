//
//  LCNetworkImageView.m
//  LCNetworkImageView
//
//  Created by CC on 15/11/19.
//  Copyright © 2015年 CC. All rights reserved.
//

#import "LCNetworkImageView.h"
#import "LCImageDownloadManager.h"


#define Tag_downloadImageView   1000010


typedef void (^DownloadImageFinishedBlock) (BOOL isSuccess, UIImage * image);


@interface LCNetworkImageView ()<NSURLSessionDelegate>

@property (nonatomic, readwrite, copy) DownloadImageFinishedBlock downloadImageFinishedBlock;
@property (nonatomic, strong) __block NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSURL * imageURL;
@property (nonatomic, assign) UIViewContentMode lecContentMode;
@property (nonatomic, strong) NSURLSession *session;

@end



@implementation LCNetworkImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
    [super setContentMode:contentMode];
    _lecContentMode = contentMode;
    UIImageView * imageView = (UIImageView *)[self viewWithTag:Tag_downloadImageView];
    if (imageView)
    {
        imageView.contentMode = contentMode;
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    UIImageView * imageView = (UIImageView *)[self viewWithTag:Tag_downloadImageView];
    if (imageView)
    {
        imageView.frame = self.bounds;
    }
}

#pragma mark - ImageView相关
- (void)loadImageViewWithImage:(UIImage *)image
{
    UIImageView * imageView = (UIImageView *)[self viewWithTag:Tag_downloadImageView];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = Tag_downloadImageView;
        imageView.contentMode = _lecContentMode;
        [self addSubview:imageView];
    }
    [imageView setImage:image];
}

- (void)loadImageWithURL:(NSURL*)url
               completed:(void (^) (BOOL isSuccess, UIImage * image))block
{
    self.downloadImageFinishedBlock = block;
    if (!url)
    {
        if (block)
        {
            block(NO,nil);
        }
        return;
    }
    if (_task)
    {
        [_task cancel];
        _task = nil;
    }
    self.imageURL = url;
    
    UIImage * image = [[LCImageDownloadManager sharedManager] fileExistsForResourceWithURL:[url absoluteString]];
    if (image)
    {
        [self loadImageViewWithImage:image];
        if (block)
        {
            block(YES,image);
        }
        return;
    }
    else
    {
        [self loadImageViewWithImage:image];
    }
    

    [self cancelRequest];
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 30;
    _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    // 使用配置文件实例化会内存泄漏

    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//       NSLog(@"*******开始加载图片数据********");
//        NSLog(@"获取图片DownloadTask:%@",wSelf.task);
        wSelf.task = [_session downloadTaskWithRequest:request];
        [wSelf.task resume];
    });
}

- (void)cancelRequest
{
    if (_session)
    {
        [_session invalidateAndCancel];
        _session = nil;
    }
    if (_task) {
        [_task suspend];
        [_task cancel];
    }
}

#pragma mark - 路径管理
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

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
//    int code = [(NSHTTPURLResponse *)[downloadTask response] statusCode];
//    NSLog(@"code:%d",code);
    NSLog(@"Download success for URL: %@",location.description);
    NSString * localPath = [[LCImageDownloadManager sharedManager] storagePathWithURL:_imageURL];
    NSURL *destination = [NSURL fileURLWithPath:localPath];;
    BOOL success = NO;
    NSData * data = [NSData dataWithContentsOfURL:location];
    if (data && data.length != 0)
    {
        success = [self copyTempFileAtURL:location toDestination:destination];
    }
    UIImage * image = [[LCImageDownloadManager sharedManager] fileExistsForResourceWithURL:[_imageURL absoluteString]];
    __weak typeof(self) wSelf = self;
    if(success){
        dispatch_async(dispatch_get_main_queue(), ^{
            [wSelf loadImageViewWithImage:image];
            if (wSelf.downloadImageFinishedBlock)
            {
                wSelf.downloadImageFinishedBlock(success,image);
            }
        });
    }
    [self cancelRequest];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
//    int code = [(NSHTTPURLResponse *)[task response] statusCode];
//    NSLog(@"code:%d",code);
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (wSelf.downloadImageFinishedBlock)
        {
            wSelf.downloadImageFinishedBlock(NO,nil);
        }
    });
    [self cancelRequest];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    //恢复下载
    
}



#pragma mark - 外部调用
- (UIImage*) image
{
    UIImageView* iv = [[self subviews] objectAtIndex:0];
    return [iv image];
}



@end


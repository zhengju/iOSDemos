//
//  ViewController.m
//  AVFoundation01
//
//  Created by leeco on 2019/4/15.
//  Copyright © 2019 zsw. All rights reserved.
//

#import "ViewController.h"
#import "ZJWriterManager.h"
@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    NSMutableArray * images = [NSMutableArray arrayWithCapacity:0];
    

    for (int i = 0; i < 5; i++) {
        for (int j = 1; j < 5; j++) {
            for (int k = 0; k < 30; k++) {
                [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Lotus0%d",j]]];
            }
        }
    }
    
  
    CGSize size = CGSizeMake(480, 320);
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"temp.mp4"]];
    
    NSURL *filePath =  [NSURL fileURLWithPath:path];
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    
    NSLog(@"%@", path);
    
    ZJWriterManager * writer = [[ZJWriterManager alloc]init];
    writer.images = images;
    [writer writeVideoSize:size path:filePath success:^{
        
    }];
}

@end

//
//  ViewController.m
//  MergeImages
//
//  Created by zhengsw on 2024/12/27.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 88, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width)];
    imageView.image = [self mergeImagesToOne:[UIImage imageNamed:@"image_1"] twoImg:[UIImage imageNamed:@"image_2"] topleft:CGPointMake(100, 100)];
    [self.view addSubview:imageView];
    
    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(imageView.frame)+50, UIScreen.mainScreen.bounds.size.width-200, 60)];
    [saveBtn addTarget:self action:@selector(savePhotosAlbum) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"保存至相册" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:saveBtn];
    
}

- (void)savePhotosAlbum {
    UIImageWriteToSavedPhotosAlbum([self mergeImagesToOne:[UIImage imageNamed:@"image_1"] twoImg:[UIImage imageNamed:@"image_2"] topleft:CGPointMake(100, 100)], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

// 保存完成
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"需要开启访问相册权限，才能帮您保存图片呦~");
    } else {
        NSLog(@"%@",@"保存成功");
    }
}

- (UIImage *)mergeImagesToOne:(UIImage *)ongImg twoImg:(UIImage *)twoImg topleft:(CGPoint)tlPoint {

    UIGraphicsBeginImageContext(twoImg.size);
    [twoImg drawInRect:CGRectMake(0, 0, twoImg.size.width, twoImg.size.height)];
    [ongImg drawInRect:CGRectMake(tlPoint.x, tlPoint.y, 500, 250)];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}

@end

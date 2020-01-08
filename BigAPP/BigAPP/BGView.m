//
//  BGView.m
//  BigAPP
//
//  Created by zhengju on 2020/1/5.
//  Copyright © 2020 zhengju. All rights reserved.
//

#import "BGView.h"
#import <Masonry/Masonry.h>

//NSString * const name = @"name zj";

@interface BGView()
@property(strong,nonatomic) UILabel * titleL;
@end


@implementation BGView



- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    
    self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.titleL.backgroundColor = [UIColor redColor];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.text = @"title";
    self.titleL.frame = CGRectMake(0, 0, 100, 30);
    [self addSubview:self.titleL];
    
}

#pragma mark -绘制上下文
- (void)drawRect:(CGRect)rect{
    
    //1
    UIImage * image = [UIImage imageNamed:@"test.jpg"];
    NSLog(@"size:%@",NSStringFromCGSize(image.size));
    [image drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    
    
    
    //2
//    CGContextRef context =  UIGraphicsGetCurrentContext();
//    //画一个椭圆
//    CGContextAddEllipseInRect(context, CGRectMake(0, 0, 100, 100));
//    //填充颜色为蓝色
//    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
//    //在context上绘制
//    CGContextFillPath(context);
    
    
    
    //3 
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(0,0,100,100));
    //填充颜色为蓝色
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    //在context上绘制
    CGContextFillPath(context);
    //把当前context的内容输出成一个UIImage图片
    UIImage* i = UIGraphicsGetImageFromCurrentImageContext();
    //上下文栈pop出创建的context
    UIGraphicsEndImageContext();
    [i drawInRect:CGRectMake(0, 0, 100, 100)];
    
    
}

- (void)layoutSubviews{
    
    self.titleL.frame = CGRectMake(0, 100, 100, 30);
    
    
    NSLog(@"-- layoutSubviews");
    
}

@end

//
//  LayerController.m
//  BigAPP
//
//  Created by zhengju on 2020/1/5.
//  Copyright © 2020 zhengju. All rights reserved.
//

#import "LayerController.h"
#import "ZJLayer.h"

#import "BGView.h"

@interface LayerController ()<CALayerDelegate>

@end

@implementation LayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //创建自定义的view
    ZJLayer * layer = [ZJLayer layer];
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    //设置layer的位置
    layer.position = CGPointMake(200, 200);
    //设置大小
    layer.bounds = CGRectMake(0, 0, 200, 200);
    //设置layer的锚点
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    //添加到layer中
    [self.view.layer addSublayer:layer];
    
    layer.delegate = self;
    
    //重绘  需注意是哪一个layer重绘
    [layer setNeedsDisplay];
    
//    NSLog(@"name is %@",name);
    
    
    //bgView
    
    BGView * bgView = [[BGView alloc]initWithFrame:CGRectMake(0,300, 200, 200)];
    bgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bgView];
    
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    
    NSLog(@"%@",ctx);
    
    //绘制路径
    CGContextAddEllipseInRect(ctx, CGRectMake(100, 100, 100, 100));
    //设置颜色
    CGContextSetRGBFillColor(ctx, 0, 1, 0, 1);
    //渲染
    CGContextFillPath(ctx);
}
@end

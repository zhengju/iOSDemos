//
//  SDController.m
//  BigAPP
//
//  Created by zhengsw on 2020/5/19.
//  Copyright © 2020 zhengju. All rights reserved.
//

#import "SDController.h"
#import <SDWebImage/SDWebImage.h>
@interface SDController ()

@end

@implementation SDController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"SD研究";
    self.view.backgroundColor = [UIColor whiteColor];

    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576860245217&di=218393fb5d459a15607d3c31dbea302c&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201210%2F24%2F20121024114828_TtcQe.jpeg"] placeholderImage:[UIImage imageNamed:@""]];
    
    [self.view addSubview:imageView];
    
}


@end

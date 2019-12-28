//
//  VCCell.h
//  BigAPP
//
//  Created by zhengju on 2019/12/20.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImage.h>
NS_ASSUME_NONNULL_BEGIN

@interface VCCell : UITableViewCell

@property(strong,nonatomic) UIImageView * icon;

@property(strong,nonatomic) NSString * urlString;

@end

NS_ASSUME_NONNULL_END

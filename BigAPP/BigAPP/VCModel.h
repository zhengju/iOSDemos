//
//  VCModel.h
//  BigAPP
//
//  Created by zhengju on 2019/12/30.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCModel : NSObject

@property(copy,nonatomic) NSString * title;
@property(copy,nonatomic) NSString * iconURL;
@property (nonatomic,copy) NSString * viewController;

@end

NS_ASSUME_NONNULL_END

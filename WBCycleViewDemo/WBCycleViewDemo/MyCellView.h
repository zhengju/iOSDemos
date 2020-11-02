//
//  MyCellView.h
//  WBCycleViewDemo
//
//  Created by zhengsw on 2020/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCellView : UIView

- (void) configData:(NSDictionary *)data;

- (void)show;
- (void)hidden;

@end

NS_ASSUME_NONNULL_END

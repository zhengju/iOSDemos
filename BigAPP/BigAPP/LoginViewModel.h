//
//  LoginViewModel.h
//  BigAPP
//
//  Created by zhengju on 2019/12/30.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
NS_ASSUME_NONNULL_BEGIN

@interface LoginViewModel : NSObject

@property(copy,nonatomic) NSString * name;
@property(copy,nonatomic) NSString * pwd;
@property(strong,nonatomic) RACSignal * btnEnableSignal;
@property(strong,nonatomic) RACCommand * loginCommand;

@end


NS_ASSUME_NONNULL_END

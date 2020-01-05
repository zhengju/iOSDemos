//
//  UIViewController+Logging.m
//  BigAPP
//
//  Created by zhengju on 2019/12/31.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import "UIViewController+Logging.h"
#import <objc/runtime.h>
#import "Aspects.h"

@implementation UIViewController (Logging)


void swizzledMethod(Class class,SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+(void)load{
    
    swizzledMethod([self class], @selector(viewDidAppear:), @selector(swizzled_viewDidAppear:));
    
    swizzledMethod([self class], @selector(viewDidDisappear:), @selector(swizzled_viewDidDisappear:));
    
    [self aspect_hookSelector:@selector(viewWillAppear:) withOptions:0 usingBlock:^(id<AspectInfo> info, BOOL animated) {
        UIViewController *controller = [info instance];
        
        NSLog(@"hook技术 %@",NSStringFromClass([controller class]));
        
    } error:NULL];

}


- (void)swizzled_viewDidAppear:(BOOL)animated{
    [self swizzled_viewDidAppear:animated];
    NSLog(@"开始记录 %@",NSStringFromClass([self class]));
}

- (void)swizzled_viewDidDisappear:(BOOL)animated{
    [self swizzled_viewDidDisappear:animated];
    NSLog(@"结束记录 %@",NSStringFromClass([self class]));
}

@end

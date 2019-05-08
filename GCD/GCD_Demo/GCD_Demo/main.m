//
//  main.m
//  GCD_Demo
//
//  Created by leeco on 2019/2/3.
//  Copyright © 2019年 zsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        NSString *s = @"Draveness";
        [s stringByAppendingString:@"-Suffix"];
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}




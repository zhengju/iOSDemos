//
//  TaskController+ModuleA.m
//  BigAPP
//
//  Created by zhengju on 2019/12/26.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import "TaskController+ModuleA.h"

#import "ModuleA.h"

#import "TaskManager.h"

@implementation TaskController (ModuleA)

+ (void)load{
    ModuleA * module = [[ModuleA alloc]init];
    TaskManager * manager = [TaskManager shareManager];
    [manager registModules:module];
}

@end

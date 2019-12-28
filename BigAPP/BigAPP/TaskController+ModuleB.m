//
//  TaskController+ModuleB.m
//  BigAPP
//
//  Created by zhengju on 2019/12/26.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import "TaskController+ModuleB.h"
#import "ModuleB.h"
#import "TaskManager.h"


@implementation TaskController (ModuleB)

+ (void)load{
    ModuleB * module = [[ModuleB alloc]init];
    TaskManager * manager = [TaskManager shareManager];
    [manager registModules:module];
}

@end

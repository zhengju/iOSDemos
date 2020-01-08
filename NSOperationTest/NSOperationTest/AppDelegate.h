//
//  AppDelegate.h
//  NSOperationTest
//
//  Created by zhengju on 2020/1/6.
//  Copyright © 2020 zhengju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


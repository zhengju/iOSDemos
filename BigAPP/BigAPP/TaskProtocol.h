//
//  TaskProtocol.h
//  BigAPP
//
//  Created by zhengju on 2019/12/26.
//  Copyright © 2019 zhengju. All rights reserved.
//

#ifndef TaskProtocol_h
#define TaskProtocol_h

#include <stdio.h>


typedef void(^block)(NSString * str);

@protocol TaskProtocol  <NSObject>

- (void)reloadDatas;
- (void)dataWith:(block)block;

@end
#endif /* TaskProtocol_h */

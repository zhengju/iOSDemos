//
//  SpringBoxManager.m
//  SpringBox
//
//  Created by zhengsw on 2020/6/18.
//  Copyright © 2020 58. All rights reserved.
//https://blog.csdn.net/hanhailong18/article/details/96186614

#import "AlertManager.h"


@interface AlertConfig()

@end


@implementation AlertConfig

- (instancetype)initWithPatams:(NSDictionary *)params activate:(BOOL)isActivate{
    if (self = [super init]) {
        self.params = params;
        self.isActivate = isActivate;
        self.isIntercept = YES;
    }
    return self;
}
@end


@interface AlertManager()

@property (nonatomic,strong) NSMutableDictionary *springBoxDict;

/// 弹框缓存
@property (nonatomic,strong) NSMutableDictionary *alertCache;

@end

@implementation AlertManager
static AlertManager *_shareInstance = nil;
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc]init];
    });
    return _shareInstance;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [super allocWithZone:zone];
    });
    return _shareInstance;
}
- (id)copyWithZone:(NSZone *)zone {
    return _shareInstance;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return _shareInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.springBoxDict = [NSMutableDictionary dictionaryWithCapacity:0];
        self.alertCache = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (void)alertShowWithType:(NSString *)type config:(AlertConfig *)config success:(Block)successBlock{
    
    config.block = successBlock;
    //加入缓存
    [self.alertCache setObject:config forKey:type];
    
    if (config.isIntercept && self.alertCache.allKeys.count > 1) {//self.alertCache.allKeys.count > 1 表示当前有弹框在显示
        return;
    }
    
    successBlock();
}

- (void)alertDissMissWithType:(NSString *)type success:(Block)successBlock{
    successBlock();
    
    //延迟释放其他block
    NSArray * keys = self.alertCache.allKeys;
    [self.alertCache removeObjectForKey:type];

    //接下来是要显示被拦截的弹框
    if (keys.count > 0) {
        
        AlertConfig * config = [self.alertCache objectForKey:[keys firstObject]];
        Block  block = config.block;
        
        //查找是否有可以显示的弹框 条件：1.已加入缓存 2.被拦截 3.可以激活显示
        //目前是从先加入的找起
        
        for (NSString * key in keys) {
            
            AlertConfig * config = [self.alertCache objectForKey:key];
            
            if (config.isIntercept && config.isActivate && block) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    block();
                });
                break;
            }else {//不符合条件的可以在此移除
                [self.alertCache removeObjectForKey:type];
            }
        }
    }
}

@end
//结尾移除

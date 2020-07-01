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
        
        //在此移除被拦截并且不被激活的弹框
        if (!config.isActivate) {
            [self.alertCache removeObjectForKey:type];
        }

        return;
    }
    
    successBlock();
}

- (void)alertDissMissWithType:(NSString *)type success:(Block)successBlock{
    
    successBlock();
    
    //延迟释放其他block
    [self.alertCache removeObjectForKey:type];
    NSArray * values = [[self.alertCache.allValues reverseObjectEnumerator] allObjects];//逆序
    
    //判断当前是否有显示-有，不显示弹框
    
    values = [self sortByPriority:values];
    NSLog(@"%@",self.alertCache);
    //接下来是要显示被拦截的弹框
    if (values.count > 0) {

        //查找是否有可以显示的弹框 条件：1.已加入缓存 2.被拦截 3.可以激活显示
        //目前是从先加入的找起->优先级
        
        for (AlertConfig * config in values) {

            Block  block = config.block;
            
            if (config.isIntercept && config.isActivate && block) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    block();
                });
                break;
            }
        }
    }
}

#pragma mark - 根据优先级排序 根据priority降序

- (NSArray *)sortByPriority:(NSArray *)allKeys {
    
    NSComparator cmptr = ^(AlertConfig *obj1, AlertConfig *obj2){
        if (obj1.priority > obj2.priority) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if (obj1.priority < obj2.priority) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    return [allKeys sortedArrayUsingComparator:cmptr];
}

#pragma mark - 清除被拦截且不被激活的弹框

- (void)clearWithNoActivate {
    
    NSArray * keys = [self.alertCache allKeys];
    for (NSString *key in keys) {
        AlertConfig *config = [self.alertCache objectForKey:key];
        if (config.isIntercept && !config.isActivate) {
            [self.alertCache removeObjectForKey:key];
        }
    }
}

@end

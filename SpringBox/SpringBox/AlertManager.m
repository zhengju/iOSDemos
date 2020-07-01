//
//  SpringBoxManager.m
//  SpringBox
//
//  Created by zhengsw on 2020/6/18.
//  Copyright © 2020 58. All rights reserved.
//https://blog.csdn.net/hanhailong18/article/details/96186614

#import "AlertManager.h"

#define ZJSemaphoreCreate \
static dispatch_semaphore_t signalSemaphore; \
static dispatch_once_t onceTokenSemaphore; \
dispatch_once(&onceTokenSemaphore, ^{ \
    signalSemaphore = dispatch_semaphore_create(1); \
});

#define ZJSemaphoreWait \
dispatch_semaphore_wait(signalSemaphore, DISPATCH_TIME_FOREVER);

#define ZJSemaphoreSignal \
dispatch_semaphore_signal(signalSemaphore);

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

/// 是否根据优先级排序 默认YES
@property (nonatomic,assign) BOOL isSortByPriority;

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
        self.alertCache = [NSMutableDictionary dictionaryWithCapacity:0];
        self.isSortByPriority = YES;
    }
    return self;
}

- (void)alertShowWithType:(NSString *)type config:(AlertConfig *)config success:(Block)successBlock{
    
    //排查是否重复添加
    NSArray * keys = self.alertCache.allKeys;
    if ([keys containsObject:type]) {
        successBlock(NO,@"type标识重复");
        NSLog(@"type(%@)标识重复",type);
        return;
    }
    
    //重置优先级
    if (config.priority != AlertPriority1 && config.priority != AlertPriority2 && config.priority != AlertPriority3) {
        config.priority = AlertPriority1;
    }
    
    config.alertType = type;
    config.block = successBlock;
    config.isDisplay = YES;//设置为当前显示
    //加入缓存
    ZJSemaphoreCreate
    ZJSemaphoreWait
    [self.alertCache setObject:config forKey:type];
    ZJSemaphoreSignal
    if (config.isIntercept && self.alertCache.allKeys.count > 1) {//self.alertCache.allKeys.count > 1 表示当前有弹框在显示
        
        //在此移除被拦截并且不被激活的弹框
        if (!config.isActivate) {
            ZJSemaphoreCreate
            ZJSemaphoreWait
            [self.alertCache removeObjectForKey:type];
            ZJSemaphoreSignal
        }
        config.isDisplay = NO;//重置为当前隐藏
        return;
    }
    
    successBlock(YES,@"");
}

- (void)alertDissMissWithType:(NSString *)type success:(Block)successBlock{
    
    successBlock(YES,@"");
    
    //延迟释放其他block
    ZJSemaphoreCreate
    ZJSemaphoreWait
    [self.alertCache removeObjectForKey:type];
    ZJSemaphoreSignal
    NSArray * values = self.alertCache.allValues;
    
    //判断当前是否有显示-有，不显示弹框拦截的弹框
    if ([self displayAlert]) {
        return;
    }
    if (self.isSortByPriority) {
        values = [self sortByPriority:values];
    }
    //接下来是要显示被拦截的弹框
    if (values.count > 0) {

        //查找是否有可以显示的弹框 条件：1.已加入缓存 2.被拦截 3.可以激活显示
        //目前是从先加入的找起->优先级
        
        for (AlertConfig * config in values) {

            Block  block = config.block;
            
            if (config.isIntercept && config.isActivate && block) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    block(YES,@"");
                });
                break;
            }
        }
    }
}

#pragma mark - 排查当前是否有在显示的弹框

- (BOOL)displayAlert {
    
    BOOL display = NO;
    NSArray * keys = [self.alertCache allKeys];
    for (NSString *key in keys) {
        AlertConfig *config = [self.alertCache objectForKey:key];
        if (config.isDisplay) {
            display = YES;
            break;
        }
    }
    return display;
}

#pragma mark - 根据优先级排序 根据priority降序

- (NSArray *)sortByPriority:(NSArray *)allValues {
    //排序
    NSComparator cmptr = ^(AlertConfig *obj1, AlertConfig *obj2){
        if (obj1.priority > obj2.priority) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if (obj1.priority < obj2.priority) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    return [allValues sortedArrayUsingComparator:cmptr];
}

#pragma mark - 清除被拦截且不被激活的弹框

- (void)clearWithNoActivate {
    
    NSArray * keys = [self.alertCache allKeys];
    for (NSString *key in keys) {
        AlertConfig *config = [self.alertCache objectForKey:key];
        if (config.isIntercept && !config.isActivate) {
            ZJSemaphoreCreate
            ZJSemaphoreWait
            [self.alertCache removeObjectForKey:key];
            ZJSemaphoreSignal
        }
    }
}

- (void)clearCache {
    ZJSemaphoreCreate
    ZJSemaphoreWait
    [self.alertCache removeAllObjects];
    ZJSemaphoreSignal;
}

@end

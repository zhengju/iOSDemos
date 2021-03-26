//
//  SpringBoxManager.m
//  SpringBox
//
//  Created by zhengsw on 2020/6/18.
//  Copyright © 2020 58. All rights reserved.
//

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

/// 弹框缓存
@property (nonatomic,strong) NSMutableDictionary *alertCache;

/// 当前显示的alert弹框
@property (nonatomic, strong) AlertConfig *currentDisplayAlertConfig;

@property (nonatomic,assign) NSInteger num;

/// 已经显示过的弹框，主动点击消失+1
@property (nonatomic, assign) NSInteger displayAlertNum;


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
        _isSortByPriority = YES;
        _num = 0;
        _displayAlertNum = 0;
        _maxAlertCount = 5;
    }
    return self;
}

//禁止KVC
+ (BOOL)accessInstanceVariablesDirectly {
    return NO;
}

- (void)alertShowWithConfig:(AlertConfig *)config
                     show:(nonnull Block)showBlock
                  dismiss:(nonnull Block)dismissBlock{
    
    NSString *type = [NSString stringWithFormat:@"type%ld",(long)self.num];//累加的type
    self.num++;
    //重置优先级
    if (config.priority != AlertPriority1 && config.priority != AlertPriority2 && config.priority != AlertPriority3) {
        config.priority = AlertPriority1;
    }
    
    config.alertType = type;
    config.showBlock = showBlock;
    config.dismissBlock = dismissBlock;
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
        }else {//允许被激活(重新显示)
            config.isDisplay = NO;//被打断后，重置为当前隐藏
        }
        return;
    }
    if (self.currentDisplayAlertConfig && self.currentDisplayAlertConfig != config) {//不被拦截的弹框，已经在显示的弹框先隐藏，会在下次按算法显示
        self.currentDisplayAlertConfig.isDisplay = NO;
        if (self.currentDisplayAlertConfig.dismissBlock) {
            self.currentDisplayAlertConfig.dismissBlock(YES,@"本次被隐藏了啊");
        }
    }
    self.currentDisplayAlertConfig = config;//当前在显示的alert
    if (showBlock) {
        showBlock(YES,@"");
    }
}

- (void)alertDissMiss{

    self.currentDisplayAlertConfig.isDisplay = NO;
    if (self.currentDisplayAlertConfig.dismissBlock) {
        self.currentDisplayAlertConfig.dismissBlock(YES,@"");
    }
    [self.alertCache removeObjectForKey:self.currentDisplayAlertConfig.alertType];

    //弹框显示最大数量 拦截
    self.displayAlertNum++;
    if (self.displayAlertNum >= self.maxAlertCount) {
        //清空
        [self clearCache];
        self.displayAlertNum = 0;//同一批缓存的弹框的最大数量 重新设置0
        self.num = 0;
        return;
    }

    NSArray * values = self.alertCache.allValues;

    if (self.isSortByPriority) {
        values = [self sortByPriority:values];
    }
    //接下来是要显示被拦截的弹框
    if (values.count > 0) {

        //查找是否有可以显示的弹框 条件：1.已加入缓存 2.被拦截 3.可以激活显示
        //目前是从先加入的找起->优先级
        
        for (AlertConfig * config in values) {

            Block showBlock = config.showBlock;
            
            if (config.isIntercept && config.isActivate && showBlock) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    config.isDisplay = YES;
                    showBlock(YES,@"");
                    self.currentDisplayAlertConfig = config;
                });
                break;
            }
        }
    }
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

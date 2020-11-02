

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^block)(void);
@interface MyTimer : NSObject

- (instancetype)initWithTarget:(id)target block:(void(^)(void))block;

- (void)invalidate;

@end

NS_ASSUME_NONNULL_END

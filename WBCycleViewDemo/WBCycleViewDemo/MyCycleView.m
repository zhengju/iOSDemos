//
//  MyCycleView.m
//  WBCycleViewDemo
//
//  Created by zhengsw on 2020/10/26.
//

#import "MyCycleView.h"
#import "MyCellView.h"
#import "MyTimer.h"
@interface MyCycleView()
@property (nonatomic,strong) MyTimer *multiTimer;
@property(nonatomic,strong)NSArray *datas;
@property(nonatomic,strong)NSMutableArray *cells;

@property(nonatomic,assign)NSInteger index;

@end


@implementation MyCycleView

- (NSMutableArray *)cells {
    if (!_cells) {
        _cells = [NSMutableArray arrayWithCapacity:0];
    }
    return _cells;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
    }
    return self;
}


- (void)configWithdate:(NSArray *)datas {
   
    _datas  = datas;
    
    for (int i = 0; i<_datas.count; i++) {
        
        NSDictionary *dict = [_datas objectAtIndex:i];
        
        MyCellView * cellView = [[MyCellView alloc]initWithFrame:self.bounds];
        [self addSubview:cellView];
        [cellView configData:dict];
        [self.cells addObject:cellView];
    }

    [self.cells addObject:[self.cells objectAtIndex:0]];//追加第一个至尾部
    
    
    if (_datas.count>1) {//开启定时器
        self.multiTimer = [[MyTimer alloc]initWithTarget:self block:^{
            [self cycleAction];
        }];
    }else {
        
    }
}

- (void)cycleAction {

    MyCellView *headCell = [self.cells objectAtIndex:self.index];

    [headCell hidden];

    MyCellView *tailCell = [self.cells objectAtIndex:self.index+1];

    [tailCell show];

    self.index++;
    
    if (self.index == (self.cells.count-1)) {
        self.index = 0;
    }
    
    NSLog(@"走了定时器了当前index %ld",(long)self.index);   // 0 1 2 3 0
}


@end

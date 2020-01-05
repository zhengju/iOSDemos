//
//  ViewController.m
//  BigAPP
//
//  Created by zhengju on 2019/12/20.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import "ViewController.h"
#import "KMCGeigerCounter.h"
#import "VCCell.h"
#import "TaskController.h"
#import "VCModel.h"
#import "BigAPP-Swift.h"
#import "ZJImageManager.h"
#import "LCNetworkImageView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LoginController.h"
#import "HTMLController.h"
#import "LayerController.h"

#define cellID @"cellID"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic) NSMutableArray * datas;
@end

@implementation ViewController
- (NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray arrayWithCapacity:0];
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [KMCGeigerCounter sharedGeigerCounter].enabled = YES;

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[VCCell class] forCellReuseIdentifier:cellID];

    //rac
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号A 被销毁");
        }];
    }];
    
    [signalA subscribeNext:^(id x) {
        NSLog(@"A 收到数据：%@",x);
    }];

    RACSignal * signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@2];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号B 被销毁");
        }];
        
    }];
    [signalB subscribeNext:^(id x) {
          NSLog(@"B 收到数据：%@",x);
    }];
 
    //合并信号
    RACSignal * mergerSignal = [RACSignal combineLatest:@[signalA,signalB] reduce:^id(NSNumber * num1,NSNumber*num2){
        return [NSString stringWithFormat:@"哈哈哈 %@ %@",num1,num2];
    }];
    
    [mergerSignal subscribeNext:^(id x) {
        NSLog(@"合并信号执行  %@",x);
    }];
    
    
    NSArray * titles = @[@"任务中心",@"RAC",@"Swift",@"WKWebView",@"layer"];
    
    for (int i = 0; i < titles.count; i++) {
        VCModel * model = [[VCModel alloc]init];
        model.iconURL = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576860245217&di=218393fb5d459a15607d3c31dbea302c&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201210%2F24%2F20121024114828_TtcQe.jpeg";
        model.title = titles[i];
        [self.datas addObject:model];
    }
    
    [self.tableView reloadData];
    
    
    ZJImageManager * imageManager = [[ZJImageManager alloc]init];
    [imageManager downloadImage];

    LCNetworkImageView * view = [[LCNetworkImageView alloc]init];
    [view loadImageWithURL:[NSURL URLWithString:@"http://img2.imgtn.bdimg.com/it/u=3344415164,12208452&fm=26&gp=0.jpg"] completed:^(BOOL isSuccess, UIImage *image) {

    }];
    
    
}
- (void)viewWillLayoutSubviews{
    
}
- (void)viewDidLayoutSubviews{
    
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    VCCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[VCCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {//任务中心
        
        TaskController * vc = [[TaskController alloc]init];
        
        [self presentViewController:vc animated:YES completion:nil];
        
    }else if (indexPath.row == 1){
        LoginController * loginVC = [[LoginController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
        
    }else if (indexPath.row == 2){
        FriendsController * vc = [[FriendsController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else if (indexPath.row == 3){
        HTMLController * vc = [[HTMLController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else if (indexPath.row == 4){
        LayerController * vc = [[LayerController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
        
    }
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

@end

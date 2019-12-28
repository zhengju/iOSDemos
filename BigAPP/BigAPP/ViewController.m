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
#define cellID @"cellID"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [KMCGeigerCounter sharedGeigerCounter].enabled = YES;

    [self.tableView registerClass:[VCCell class] forCellReuseIdentifier:cellID];
    
    NSLog(@"----");
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    VCCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[VCCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.urlString = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576860245217&di=218393fb5d459a15607d3c31dbea302c&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201210%2F24%2F20121024114828_TtcQe.jpeg";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        TaskController * vc = [[TaskController alloc]init];
        
        [self presentViewController:vc animated:YES completion:nil];
        
    }
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

@end

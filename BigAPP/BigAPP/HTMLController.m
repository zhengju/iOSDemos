//
//  HTMLController.m
//  BigAPP
//
//  Created by zhengju on 2020/1/1.
//  Copyright © 2020 zhengju. All rights reserved.
//

#import "HTMLController.h"
#import <WebKit/WebKit.h>
@interface HTMLController ()<WKNavigationDelegate>
@property(strong,nonatomic) WKWebView * webView;
@end

@implementation HTMLController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    
//  NSString *js = @"document.getElementsByTagName('h2')[0].innerText = '我是ios为h5注入的方法'";
//  WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//  [configuration.userContentController addUserScript:script];
    
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.baidu.com"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];

}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__func__);
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"1 加载失败%@", error.userInfo);
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"2 加载失败%@", error.userInfo);
}
//在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    
    NSLog(@"---->%@",webView.title);
    
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    decisionHandler(actionPolicy);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"%s",__func__);
    
}

@end

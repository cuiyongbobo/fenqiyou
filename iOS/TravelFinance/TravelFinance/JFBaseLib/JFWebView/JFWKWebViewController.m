//
//  JFWKWebViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/5.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFWKWebViewController.h"

#import "Masonry.h"
#import "YKNewToastView.h"
#import "JFBaseLibCommon.h"
#import "JFWebViewJSCallBack.h"
#import "UIColor+Hex.h"
#import "JFColor.h"
#import "YKToastView.h"
#import "JFNavigationController.h"

@interface JFWKWebViewController ()<WKNavigationDelegate>

@end

@implementation JFWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.webView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    if (self.isShowNavigation) {
        [self.navigationController.navigationBar setHidden:NO];
    }else {
        [self.navigationController.navigationBar setHidden:YES];
    }
    
    if (self.isNotShowCloseBtn) {
        [self configNavigation:self.titleName showRightBtn:NO showLeftBtn:NO currentController:self];
    }else {
        [self configNavigation:self.titleName showRightBtn:NO showLeftBtn:YES currentController:self];
    }
    
    self.requestUrl = _requestUrl;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)dealloc {
    _webView.navigationDelegate = nil;
}


#pragma mark---WebView Delegate---
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation { // 类似UIWebView的 -webViewDidStartLoad:
    
    YKToastView *toastView = [YKToastView sharedToastViewWWithIndicatorAndText:@"努力加载.."];
    [toastView showInView:self.view];
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    [[YKToastView sharedToastView] hide];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation { // 类似 UIWebView 的 －webViewDidFinishLoad:
    
    [[YKToastView sharedToastView] hide];
    self.titleName =webView.title;
    if (self.isShowNavigation) {
        [self.navigationController.navigationBar setHidden:NO];
        
        if (self.isNotShowCloseBtn) {
            [self configNavigation:webView.title showRightBtn:NO showLeftBtn:NO currentController:self];
        }else {
            [self configNavigation:webView.title showRightBtn:NO showLeftBtn:YES currentController:self];
        }
        
    }else {
        [self.navigationController.navigationBar setHidden:YES];
    }
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {// 类似 UIWebView 的- webView:didFailLoadWithError:
    
    
    [[YKToastView sharedToastView] hide];
    if (error.code == NSURLErrorCancelled) {    //链接取消
        return;
    }
}
//在收到响应之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
    
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
    
    NSString *requestString = [JFBaseLibCommon URLDecodedString:navigationAction.request.URL.absoluteString];
    NSLog(@"wkurl:%@",requestString);
    NSArray *components = [requestString componentsSeparatedByString:@"::"]; //提交请求时候分割参数的分隔符
    if (components.count >= 2 && [components[0] isEqualToString:@"jfapp"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        if ([components[1] isEqualToString:kJFFinanceActionBack]) {
            // 返回按钮
            if (components.count >= 3) {
                NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:[components[2] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                [JFWebViewJSCallBack sharedWebViewJSCallBack].controller = self;
                [[JFWebViewJSCallBack sharedWebViewJSCallBack] webViewJSCallBack:YKFinanceJSCallBackTypeBack userInfo:userInfo];
            }
            
        } else if ([components[1] isEqualToString:kJFFinanceActionPay]){
            // h5 详情页
            if (components.count >= 3) {
                NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:[components[2] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                [JFWebViewJSCallBack sharedWebViewJSCallBack].controller = self;
                [[JFWebViewJSCallBack sharedWebViewJSCallBack] webViewJSCallBack:JFFinanceJSCallBackTypePay userInfo:userInfo];
            }
        } else if ([components[1] isEqualToString:kFFinanceActionPayBackPay]){
            // 白玩支付完成
            [JFWebViewJSCallBack sharedWebViewJSCallBack].controller = self;
            NSDictionary *userInfo = [[NSDictionary alloc]init];
            [[JFWebViewJSCallBack sharedWebViewJSCallBack] webViewJSCallBack:JFFinanceJSCallBackTypePayBack userInfo:userInfo];
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
    
}


//在发送请求之前 ，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//接收到服务器 跳转请求之后调用，即从一个h5 进入另一个h5
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    self.titleName = nil;
    // decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark---setter/getter---

- (WKWebView *)webView {
    
    if (_webView == nil) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame))];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
        //        self.webView.scrollView.backgroundColor = [UIColor whiteColor];
        // 允许左右划手势导航，默认允许
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    return _webView;
}

- (void)setRequestUrl:(NSString *)requestUrl {
    _requestUrl = requestUrl;
    if (_requestUrl.length > 0) {
        
        if (self.htmlSubmit) {
            [self.webView loadHTMLString:_requestUrl baseURL:nil];
        }else {
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                            initWithURL:[NSURL URLWithString:_requestUrl]
                                            cachePolicy:NSURLRequestReloadIgnoringCacheData
                                            timeoutInterval:30.0];
            [_webView loadRequest:request];
        }
    }
}

- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
}


@end

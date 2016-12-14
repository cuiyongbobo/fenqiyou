//
//  JFWebViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/4.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFWebViewController.h"

#import "Masonry.h"
#import "JFWebViewJSCallBack.h"
#import "JFBaseLibCommon.h"
#import "UIColor+Hex.h"
#import "JFColor.h"
#import "JFSubmitOrderViewController.h"
#import "YKToastView.h"

@interface JFWebViewController ()

@end

@implementation JFWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.webView];
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
    }];
    self.requestUrl = _requestUrl;
    if (self.isNotShowCloseBtn) {
        [self configNavigation:self.titleName showRightBtn:NO showLeftBtn:NO currentController:self];
    }else {
        [self configNavigation:self.titleName showRightBtn:NO showLeftBtn:YES currentController:self];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    [self setNeedsStatusBarAppearanceUpdate];
    
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
}

//- (BOOL)prefersStatusBarHidden
//{
//    if (self.isShowNavigation) {
//        return NO;
//    }
//    return YES;
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

#pragma mark--- Web view delegate---

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"url:%@",request);
    NSString *requestString = [JFBaseLibCommon URLDecodedString:[[request URL] absoluteString]];
    NSArray *components = [requestString componentsSeparatedByString:@"::"]; //提交请求时候分割参数的分隔符
    if (components.count >= 2 && [components[0] isEqualToString:@"jfapp"]) {
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
        //        else if ([components[1] isEqualToString:kFFinanceActionStagingPayBackPay]){
        //            // 分期支付
        //            [JFWebViewJSCallBack sharedWebViewJSCallBack].controller = self;
        //            NSDictionary *userInfo = [[NSDictionary alloc]init];
        //            [[JFWebViewJSCallBack sharedWebViewJSCallBack] webViewJSCallBack:JFFinanceJSCallBackTypeStagingPayBack userInfo:userInfo];
        //        }
    }
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    YKToastView *toastView = [YKToastView sharedToastViewWWithIndicatorAndText:@"努力加载.."];
    [toastView showInView:self.view];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [[YKToastView sharedToastView] hide];
    self.titleName =[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (self.isShowNavigation) {
        [self.navigationController.navigationBar setHidden:NO];
        
        if (self.isNotShowCloseBtn) {
            [self configNavigation:self.titleName showRightBtn:NO showLeftBtn:NO currentController:self];
        }else {
            [self configNavigation:self.titleName showRightBtn:NO showLeftBtn:YES currentController:self];
        }
        
        //        [self configNavigation:self.titleName showRightBtn:NO showLeftBtn:YES currentController:self];
    }else {
        [self.navigationController.navigationBar setHidden:YES];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"web load error!");
    [[YKToastView sharedToastView] hide];
    if (error.code == NSURLErrorCancelled) {//链接取消
        return;
    }
}


#pragma mark---setter/getter---

- (void)setRequestUrl:(NSString *)requestUrl {
    _requestUrl = requestUrl;
    if (_requestUrl.length > 0) {
        if (self.htmlSubmit) {
            [self.webView loadHTMLString:requestUrl baseURL:nil];
        }else {
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                            initWithURL:[NSURL URLWithString:_requestUrl]
                                            cachePolicy:NSURLRequestReloadIgnoringCacheData
                                            timeoutInterval:30.0];
            [_webView loadRequest:request];
        }
    }
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.scrollView.bounces  = NO;
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
        //        _webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
    }
    return _webView;
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

//
//  JFWebViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/4.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"

@interface JFWebViewController : JFBaseViewController<UIWebViewDelegate>

/* 加载的h5页面的链接URL */
@property (nonatomic, strong) NSString *requestUrl;

/* 加载Web页面，是否显示导航栏左侧的关闭按钮？ */
@property (nonatomic, assign) BOOL isNotShowCloseBtn;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *titleName;/* 导航标题，nil时 显示网页标题 */
@property (nonatomic, assign) BOOL isShowNavigation;
@property (nonatomic, assign) BOOL htmlSubmit;

@end

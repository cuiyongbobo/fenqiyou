//
//  JFWebViewJSCallBack.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/5.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "JFBaseViewController.h"

static NSString * const KSimpleFinanceHome = @"home";
static NSString * const KSimpleFinanceSafe = @"safe";
static NSString * const KSimpleFinanceLogin = @"login";
static NSString * const KSimpleFinanceShared = @"share";
static NSString * const KSimpleFinanceEvents = @"events";
static NSString * const KSimpleFinanceAppName = @"jlcapp";
static NSString * const kSimpleFinanceH5Login = @"h5Login";
static NSString * const KSimpleFinanceAccount = @"account";
static NSString * const kSimpleFinanceAddRate = @"addrate";
static NSString * const KSimpleFinanceInvestment = @"invest";
static NSString * const KSimpleFinanceFeedback = @"feedback";
static NSString * const kSimpleFinanceUpdateApp = @"updateApp";
static NSString * const kSimpleFinanceJoinRentPlan = @"rentPlan";
static NSString * const kSimpleFinanceJoinWagesPlan = @"wagesPlan";
static NSString * const kSimpleFinanceNewUserAddRate = @"goAddRate";
static NSString * const kSimpleFinanceDreamPlanSetting = @"dreamPlan";
static NSString * const kSimpleFinanceCurrentAssets = @"currentAssets";
static NSString * const kFFinanceActionStagingPayBackPay = @"actionStagingPayBack";
static NSString * const kFFinanceActionPayBackPay = @"actionPayBack";
static NSString * const kJFFinanceActionPay = @"actionPay";
static NSString * const kJFFinanceActionBack = @"actionBack";
static NSString * const kSimpleFinanceJSCallBackType = @"KSimpleFinanceJSCallBackType";
static NSString * const KSimpleFinanceJSCallBackNotification = @"KSimpleFinanceJSCallBackNotification";

typedef NS_ENUM(NSUInteger, JFFinanceJSCallBackType) {
    JFFinanceJSCallBackTypeNone,
    JFFinanceJSCallBackTypePay,
    YKFinanceJSCallBackTypeBack,
    JFFinanceJSCallBackTypePayBack,
    JFFinanceJSCallBackTypeStagingPayBack,
    JFFinanceJSCallBackTypeSafe,
    JFFinanceJSCallBackTypeEvents,
    JFFinanceJSCallBackTypeAccount,
    JFFinanceJSCallBackTypeFeedback,
    JFFinanceJSCallBackTypeAddRate,
    JFFinanceJSCallBackTypeGoAddRate,
    JFFinanceJSCallBackTypeCurrentAssets,
};


@interface JFWebViewJSCallBack : NSObject

@property (nonatomic, strong) JFBaseViewController *controller;

+ (instancetype)sharedWebViewJSCallBack;

- (void)webViewJSCallBack:(JFFinanceJSCallBackType)financeJSCallBackType userInfo:(NSDictionary*)userInfo;

@end

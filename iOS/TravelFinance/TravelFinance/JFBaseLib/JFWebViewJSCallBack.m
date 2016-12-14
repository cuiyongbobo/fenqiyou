//
//  JFWebViewJSCallBack.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/5.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFWebViewJSCallBack.h"

#import "AppDelegate.h"
#import "JFSubmitOrderViewController.h"
#import "JFSubmitOrderBuilder.h"
#import "JFNetworkAFN.h"
#import "JFString.h"
#import "JFTipsWindow.h"
#import "JFSubmitOrderParser.h"
#import "JFOpeningStageBindingBankCardViewController.h"
#import "JFOpeningStageRealNameViewController.h"
#import "JFOpeningStageCertificationInstitutionViewController.h"
#import "JFInputPhoneNumberViewController.h"
#import "AppDelegate.h"

@interface JFWebViewJSCallBack ()

@property (nonatomic, strong) NSDictionary *userDictionary;
@property (nonatomic, strong) JFCreditPersonItem *personItem;

@end

@implementation JFWebViewJSCallBack

static JFWebViewJSCallBack *sharedWebViewJSCallBack = nil;

+ (instancetype)sharedWebViewJSCallBack {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWebViewJSCallBack = [[JFWebViewJSCallBack alloc] init];
    });
    return sharedWebViewJSCallBack;
}


- (void)webViewJSCallBack:(JFFinanceJSCallBackType)financeJSCallBackType
                 userInfo:(NSDictionary *)userInfo {
    
    switch (financeJSCallBackType) {
        case JFFinanceJSCallBackTypePay: {
            [self handlePayCallBack:userInfo];
        } break;
        case YKFinanceJSCallBackTypeBack: {
            [self handleHomeCallBack:userInfo];
        } break;
        case JFFinanceJSCallBackTypePayBack: {
            [self handlePayBackCallBack:userInfo];
        }
            break;
            //        case JFFinanceJSCallBackTypeStagingPayBack: {
            //            [self handleStagingPayBackCallBack:userInfo];
            //        }
            //            break;
        default:
            break;
    }
}


//- (void)handleStagingPayBackCallBack:(NSDictionary *)userInfo {
//
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    app.tbc.selectedIndex = 1;
//    UINavigationController *nav = app.tbc.childViewControllers[1];
//    UINavigationController *navfirst = app.tbc.childViewControllers[0];
//    [nav popToRootViewControllerAnimated:NO];
//    [navfirst popToRootViewControllerAnimated:NO];
//}


- (void)handlePayBackCallBack:(NSDictionary *)userInfo {
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.tbc.selectedIndex = 1;
    UINavigationController *nav = app.tbc.childViewControllers[1];
    UINavigationController *navfirst = app.tbc.childViewControllers[0];
    [nav popToRootViewControllerAnimated:NO];
    [navfirst popToRootViewControllerAnimated:NO];
}


- (void)handleHomeCallBack:(NSDictionary *)userInfo {
    
    [self.controller.navigationController popViewControllerAnimated:YES];
    
}

- (void)handlePayCallBack:(NSDictionary *)userInfo {
    
    NSLog(@"拉取用户数据!");
    self.userDictionary = userInfo;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]) {
        // 请求接口
        JFSubmitOrderBuilder *orderBuilder = [JFSubmitOrderBuilder sharedOrder];
        [orderBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
        
        JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
        [afnet requestHttpDataWithPath:orderBuilder.requestURL params:orderBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
        afnet.connectionType = JFConnectionTypeUserCreditInformation;
        
    }else {
        // 手机校验
        JFInputPhoneNumberViewController *phoneNumberController = [[JFInputPhoneNumberViewController alloc] initWithNibName:@"JFInputPhoneNumberViewController" bundle:nil];
        [_controller.navigationController pushViewController:phoneNumberController animated:YES];
    }
    
    //    self.controller.navigationController.tabBarController.selectedIndex = 0;
    //    [self.controller.navigationController popToRootViewControllerAnimated:YES];
    
}


#pragma mark responce Evne

- (void)jfURLConnection:(JFNetworkAFN *)jfURLConnection withError:(id)error {
    
    if (error) {
        NSLog(@"error = %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:_controller tiptext:error backgroundcolor:white];
        });
        return;
    }
    switch (jfURLConnection.connectionType) {
            
        case JFConnectionTypeUserCreditInformation:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleOrderResponse:responsedict];
        }
            break;
            
        default:
            break;
    }
}

- (void)handleOrderResponse:(NSDictionary *)dictionary {
    
    NSLog(@"dic =%@",dictionary);
    JFSubmitOrderParser *orderParser = [JFSubmitOrderParser sharedOrderParser];
    orderParser.sourceData = dictionary;
    if (orderParser.code == [JFKStatusCode integerValue]) {
        self.personItem = orderParser.personItem;
        // 添加判断 是否为分期 分期走授信流程
        if ([self.userDictionary[@"orderType"] isEqualToString:@"fq"]) {
            
            if ([self.personItem.stageStep integerValue] == 0) {
                NSLog(@"实名认证");
                dispatch_async(dispatch_get_main_queue(), ^{
                    JFOpeningStageRealNameViewController *realNameController = [[JFOpeningStageRealNameViewController alloc] initWithNibName:@"JFOpeningStageRealNameViewController" bundle:nil];
                    [_controller.navigationController pushViewController:realNameController animated:YES];
                });
                
            }else if([self.personItem.stageStep integerValue] == 1) {
                NSLog(@"去认证机构");
                dispatch_async(dispatch_get_main_queue(), ^{
                    JFOpeningStageCertificationInstitutionViewController *bindingBankController = [[JFOpeningStageCertificationInstitutionViewController alloc] initWithNibName:@"JFOpeningStageCertificationInstitutionViewController" bundle:nil];
                    [_controller.navigationController pushViewController:bindingBankController animated:YES];
                });
                
            }else if ([self.personItem.stageStep integerValue] == 2) {
                NSLog(@"去绑卡");
                dispatch_async(dispatch_get_main_queue(), ^{
                    JFOpeningStageBindingBankCardViewController *bindingBankCardController = [[JFOpeningStageBindingBankCardViewController alloc] initWithNibName:@"JFOpeningStageBindingBankCardViewController" bundle:nil];
                    [_controller.navigationController pushViewController:bindingBankCardController animated:YES];
                });
                
            }else if ([self.personItem.stageStep integerValue] == 10) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 下单接口
                    JFSubmitOrderViewController *orderController = [[JFSubmitOrderViewController alloc] initWithNibName:@"JFSubmitOrderViewController" bundle:nil];
                    orderController.detailsDictionary = self.userDictionary;
                    orderController.personItem = self.personItem;
                    [self.controller.navigationController pushViewController:orderController animated:YES];
                });
            }
            
        }else {
            
            // 白玩
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // 下单接口
                JFSubmitOrderViewController *orderController = [[JFSubmitOrderViewController alloc] initWithNibName:@"JFSubmitOrderViewController" bundle:nil];
                orderController.detailsDictionary = self.userDictionary;
                orderController.personItem = self.personItem;
                [self.controller.navigationController pushViewController:orderController animated:YES];
            });
            
        }
        
    }else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"errorMessage =%@",orderParser.message);
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:_controller tiptext:orderParser.message backgroundcolor:white];
            
        });
        
    }
    
}









@end

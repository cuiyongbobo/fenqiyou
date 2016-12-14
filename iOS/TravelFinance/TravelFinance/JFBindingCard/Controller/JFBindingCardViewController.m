//
//  JFBindingCardViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/9.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBindingCardViewController.h"

#import "JFBindingBankListViewController.h"
#import "JFBindingBuilder.h"
#import "JFBindingParser.h"
#import "JFNetworkAFN.h"
#import "JFTipsWindow.h"
#import "JFString.h"
#import "JFOrderPayBuilder.h"
#import "JFOrderPayParser.h"
#import "JFWebViewController.h"
#import "JFMacro.h"
#import "JFDevice.h"
#import "JFString.h"
#import "JFWKWebViewController.h"
#import "YKToastView.h"
#import "JFPullBankInformationBuilder.h"
#import "JFPullBankInformationParser.h"



@interface JFBindingCardViewController ()<JFURLConnectionDelegate,UITextFieldDelegate>

@end

@implementation JFBindingCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bindingDetermineButon.layer.cornerRadius = 4;
    self.bindingDetermineButon.layer.masksToBounds = YES;
    self.bindingPhoneText.delegate = self;
    if ([JFDevice screenHeight]<= 568) {
        self.phoneTextWidth.constant = 125.5*JFWidthRateScale;
        self.bindingPhoneText.font = [UIFont systemFontOfSize:12];
        self.reservePhoneLabel.font = [UIFont systemFontOfSize:12];
        self.bindingBankCardText.font = [UIFont systemFontOfSize:12];
    }
    [self configNavigation:@"绑定银行卡" showRightBtn:NO showLeftBtn:YES currentController:self];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 拉取用户银行卡
    
    //    NSMutableDictionary *informatonDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveOrderInformation"];
    //    NSLog(@"%@",informatonDict);
    //    NSDictionary *dict = informatonDict[@"details"];
    //    NSDictionary *detailDict = dict[@"details"];
    //    NSString *typeID = @"";
    //    if ([detailDict[@"orderType"] isEqualToString:@"bw"]) {
    //        typeID = @"0";
    //    }else {
    //        typeID = @"1";
    //    }
    
    YKToastView *toastView = [YKToastView sharedToastViewWWithIndicatorAndText:JFKLoadingMessage];
    [toastView showInView:self.view];
    
    // 请求接口
    JFPullBankInformationBuilder *pullBankInforBuilder = [JFPullBankInformationBuilder sharedPullBank];
    [pullBankInforBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] type:@"0"];
    
    JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
    [afnet requestHttpDataWithPath:pullBankInforBuilder.requestURL params:pullBankInforBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    afnet.connectionType = JFConnectionTypePullBankInformation;
    
    
}

#pragma mark navigation back
- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
}

#pragma mark handle Even

- (IBAction)handleDetermine:(id)sender {
    
    [self.bindingBankCardText resignFirstResponder];
    [self.bindingPhoneText resignFirstResponder];
    
    
    // 校验手机号
    if (![JFString judgeString:self.bindingBankCardText.text]) {
        
        if (![JFString judgeString:self.bindingPhoneText.text]) {
            
            if ([self isMobileNumber:self.bindingPhoneText.text]) {
                //                NSMutableDictionary *informatonDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveOrderInformation"];
                //                NSLog(@"%@",informatonDict);
                //                NSDictionary *dict = informatonDict[@"details"];
                //                NSDictionary *detailDict = dict[@"details"];
                //                NSString *typeID = @"";
                //                if ([detailDict[@"orderType"] isEqualToString:@"bw"]) {
                //                    typeID = @"0";
                //                }else {
                //                    typeID = @"1";
                //                }
                
                YKToastView *toastView = [YKToastView sharedToastViewWWithIndicatorAndText:JFKLoadingMessage];
                [toastView showInView:self.view];
                
                // 请求接口
                JFBindingBuilder *bindingBuilder = [JFBindingBuilder sharedBinding];
                [bindingBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] type:@"0" bankCardNo:self.bindingBankCardText.text mobile:self.bindingPhoneText.text verificationCode:self.bindingPhoneText.text];
                
                JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
                [afnet requestHttpDataWithPath:bindingBuilder.requestURL params:bindingBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
                afnet.connectionType = JFConnectionTypeBindingCard;
                
            }else {
                [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请输入有效手机号" backgroundcolor:white];
            }
            
            
        }else {
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请输入手机号" backgroundcolor:white];
        }
        
    }else {
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请输入卡号" backgroundcolor:white];
    }
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *verifyCode = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (verifyCode.length > 11) {
        return NO;
    }
    return YES;
    
}


- (BOOL)isMobileNumber:(NSString *)mobileNum {
    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if ([regextestmobile evaluateWithObject:mobileNum]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark touch Even

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 64;
        self.view.frame = frame;
        [self.bindingBankCardText resignFirstResponder];
        [self.bindingPhoneText resignFirstResponder];
    }];
}


#pragma mark responce Evne

- (void)jfURLConnection:(JFNetworkAFN *)jfURLConnection withError:(id)error {
    
    if (error) {
        NSLog(@"error = %@",error);
        [[YKToastView sharedToastView] hide];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:error backgroundcolor:white];
        });
        return;
    }
    switch (jfURLConnection.connectionType) {
            
        case JFConnectionTypeBindingCard:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            
            [self handleBindingResponse:responsedict];
        }
            break;
        case JFConnectionTyPepayment:
        {
            [[YKToastView sharedToastView] hide];
            
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            
            [self handleOrderPayResponse:responsedict];
            
            
        }
            break;
            
        case JFConnectionTypePullBankInformation:
        {
            [[YKToastView sharedToastView] hide];
            
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            
            [self handlePullBankInformationResponse:responsedict];
            
            
        }
            break;
            
        default:
            break;
    }
}

- (void)handleBindingResponse:(NSDictionary *)dictionary {
    
    NSLog(@"dic =%@",dictionary);
    
    JFBindingParser *bindingParser = [JFBindingParser sharedBindingParser];
    bindingParser.sourceData = dictionary;
    if (bindingParser.code == [JFKStatusCode integerValue]) {
        
        // 去支付
        // 获取参数
        NSMutableDictionary *informatonDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveOrderInformation"];
        NSLog(@"%@",informatonDict);
        NSDictionary *detailsDictionary = [[NSDictionary alloc] init];
        NSDictionary *peerInformationDictionary = [[NSDictionary alloc] init];
        NSDictionary *MyselfInformationDictionary = [[NSDictionary alloc] init];
        NSDictionary *recommendPersonDictionary = [[NSDictionary alloc] init];
        NSString *peerName = [[NSString alloc] init];
        NSString *peerIdCard = [[NSString alloc] init];
        NSString *peerMobile = [[NSString alloc] init];
        NSString *myselfPersonName = [[NSString alloc] init];
        NSString *myselfPersonMobile = [[NSString alloc] init];
        NSString *myselfPersonIdCard = [[NSString alloc] init];
        
        NSString *recommendPerson = [[NSString alloc] init];
        
        NSString *contactName = [[NSString alloc] init];
        NSString *contactTel = [[NSString alloc] init];
        
        //        if () {
        //            statements
        //        }
        
        if (informatonDict[@"details"] !=nil) {
            detailsDictionary = informatonDict[@"details"];
        }
        
        if (informatonDict[@"MyselfInformation"] !=nil) {
            
            MyselfInformationDictionary = informatonDict[@"MyselfInformation"];
            NSArray *myselfInformationArray = MyselfInformationDictionary[@"MyselfInformation"];
            myselfPersonName = myselfInformationArray[0];
            myselfPersonIdCard = myselfInformationArray[1];
            myselfPersonMobile = myselfInformationArray[2];
            contactName = myselfInformationArray[3];
            contactTel = myselfInformationArray[4];
            
        }
        
        if (informatonDict[@"peerInformation"] !=nil) {
            
            peerInformationDictionary = informatonDict[@"peerInformation"];
            NSArray *peerArray = peerInformationDictionary[@"peerInformation"];
            peerName = peerArray[0];
            peerIdCard = peerArray[1];
            peerMobile = peerArray[2];
            
        }
        
        if (informatonDict[@"recommendPerson"] !=nil) {
            
            recommendPersonDictionary = informatonDict[@"recommendPerson"];
            recommendPerson = recommendPersonDictionary[@"recommendPerson"];
            
        }
        
        NSString *typeID = @"";
        NSDictionary *details = detailsDictionary[@"details"];
        if ([details[@"orderType"] isEqualToString:@"bw"]) {
            typeID = @"0";
        }else {
            typeID = @"1";
        }
        
        
        if ([typeID isEqualToString:@"0"]) {
            // 白玩
            // 请求接口
            JFOrderPayBuilder *orderPayBuilder = [JFOrderPayBuilder sharedOrderPay];
            [orderPayBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] orderType:typeID tuanNo:details[@"tuanNo"] tuanId:details[@"tuanId"] stageOrFinancialId:details[@"productId"] peerName:peerName peerIdCard:peerIdCard peerMobile:peerMobile contactName:contactName contactTel:contactTel couponId:@"1" recommendMobile:recommendPerson selfMobile:myselfPersonMobile];
            
            JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
            [afnet requestHttpDataWithPath:orderPayBuilder.requestURL params:orderPayBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
            afnet.connectionType = JFConnectionTyPepayment;
        }else {
            // 分期
            // 请求接口
            JFOrderPayBuilder *orderPayBuilder = [JFOrderPayBuilder sharedOrderPay];
            [orderPayBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] orderType:typeID tuanNo:details[@"tuanNo"] tuanId:details[@"tuanId"] stageOrFinancialId:details[@"productId"] peerName:peerName peerIdCard:peerIdCard peerMobile:peerMobile contactName:contactName contactTel:contactTel couponId:@"1" recommendMobile:recommendPerson selfMobile:myselfPersonMobile];
            
            JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
            [afnet requestHttpDataWithPath:orderPayBuilder.requestURL params:orderPayBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
            afnet.connectionType = JFConnectionTyPepayment;
            
        }
        
        
    }else if (bindingParser.code == [JFKBankStatusCode integerValue]) {
        
        [[YKToastView sharedToastView] hide];
        
        self.navigationController.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else {
        
        [[YKToastView sharedToastView] hide];
        NSLog(@"errorMessage =%@",bindingParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:bindingParser.message backgroundcolor:white];
        
    }
}

- (void)handleOrderPayResponse:(NSDictionary *)dictionary  {
    NSLog(@"dic =%@",dictionary);
    JFOrderPayParser *orderPayParser = [JFOrderPayParser sharedOrderPayParser];
    orderPayParser.sourceData = dictionary;
    if (orderPayParser.code == [JFKStatusCode integerValue]) {
        
        if (SUPPORT_WKWEBVIEW) {
            
            JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
            payWebController.requestUrl = orderPayParser.dataDictnary[@"htmlStr"];
            payWebController.htmlSubmit =YES;
            payWebController.isShowNavigation = YES;
            payWebController.isNotShowCloseBtn = NO;
            payWebController.navigationItem.hidesBackButton = YES;
            [self.navigationController pushViewController:payWebController animated:YES];
            
        }else {
            JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
            payWebController.requestUrl = orderPayParser.dataDictnary[@"htmlStr"];
            payWebController.htmlSubmit =YES;
            payWebController.isShowNavigation = YES;
            payWebController.isNotShowCloseBtn = NO;
            payWebController.navigationItem.hidesBackButton = YES;
            [self.navigationController pushViewController:payWebController animated:YES];
        }
        
    }else {
        NSLog(@"errorMessage =%@",orderPayParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:orderPayParser.message backgroundcolor:white];
    }
}


- (void)handlePullBankInformationResponse:(NSDictionary *)dictionary  {
    NSLog(@"dic =%@",dictionary);
    JFPullBankInformationParser *pullBankParser = [JFPullBankInformationParser sharedPullBankParser];
    pullBankParser.sourceData = dictionary;
    if (pullBankParser.code == [JFKStatusCode integerValue]) {
        
        if (![JFString judgeString:pullBankParser.dataDictnary[@"bankCardNo"]]) {
            
            if ([pullBankParser.dataDictnary[@"modify"] integerValue] == 1) {
                
                self.bindingBankCardText.enabled = NO;
                self.bindingPhoneText.enabled = NO;
            }else {
                self.bindingBankCardText.enabled = YES;
                self.bindingPhoneText.enabled = YES;
            }
            self.bindingBankCardText.text = pullBankParser.dataDictnary[@"bankCardNo"];
            self.bindingPhoneText.text = pullBankParser.dataDictnary[@"mobile"];
            // bindingPhoneText
        }
    }
}



- (IBAction)handleBankInformation:(id)sender {
    
    JFBindingBankListViewController *bankListController = [[JFBindingBankListViewController alloc] initWithNibName:@"JFBindingBankListViewController" bundle:nil];
    [self.navigationController  pushViewController:bankListController animated:YES];
    
}
@end

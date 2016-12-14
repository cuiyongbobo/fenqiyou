//
//  JFOpeningStageBindingBankCardViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/16.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFOpeningStageBindingBankCardViewController.h"

#import "JFBindingBuilder.h"
#import "JFNetworkAFN.h"
#import "JFString.h"
#import "JFTipsWindow.h"
#import "JFBindingParser.h"
#import "JFOpeningStageCertificationInstitutionViewController.h"
#import "JFQuotaBuilder.h"
#import "JFQuotaParser.h"
#import "JFOpeningStageSuccessfulViewController.h"
#import "JFOpeningStageFailViewController.h"
#import "JFBindingBankListViewController.h"
#import "UIColor+Hex.h"
#import "JFSendCodeBuilder.h"
#import "JFSendCodeParser.h"
#import "YKToastView.h"
#import "JFPullBankInformationBuilder.h"
#import "JFPullBankInformationParser.h"

@interface JFOpeningStageBindingBankCardViewController ()

@end

@implementation JFOpeningStageBindingBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"开通分期" showRightBtn:NO showLeftBtn:YES currentController:self];
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
    [pullBankInforBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] type:@"1"];
    
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

- (IBAction)handleBindingConfirm:(id)sender {
    
    [self.bindingBankNoText resignFirstResponder];
    [self.bindingPhoneNumber resignFirstResponder];
    [self.bindingCodeText resignFirstResponder];
    
    YKToastView *toastView = [YKToastView sharedToastViewWWithIndicatorAndText:JFKLoadingMessage];
    [toastView showInView:self.view];
    // 请求接口
    JFBindingBuilder *bindingBuilder = [JFBindingBuilder sharedBinding];
    [bindingBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] type:@"1" bankCardNo:self.bindingBankNoText.text mobile:self.bindingPhoneNumber.text verificationCode:self.bindingCodeText.text];
    
    JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
    [afnet requestHttpDataWithPath:bindingBuilder.requestURL params:bindingBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    afnet.connectionType = JFConnectionTypeBindingCard;
    
}

- (IBAction)handleSendCodeButtonEvent:(id)sender {
    
    // 发送短信
    [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"验证码已发送"] backgroundcolor:white];
    
    [self openCountdown];
    JFSendCodeBuilder *sendCodeBuilder = [JFSendCodeBuilder sharedSendCode];
    [sendCodeBuilder buildPostData:self.bindingPhoneNumber.text type:@"4"];
    
    [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:sendCodeBuilder.requestURL params:sendCodeBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeSendCodeRegister;
}

- (IBAction)handlesupportBankList:(id)sender {
    
    JFBindingBankListViewController *bankListController = [[JFBindingBankListViewController alloc] initWithNibName:@"JFBindingBankListViewController" bundle:nil];
    [self.navigationController  pushViewController:bankListController animated:YES];
    
}


// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 90; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                //                [self.codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"Login_sendmessage_normal"] forState:UIControlStateNormal];
                [self.codeBtn setTitle:@"" forState:UIControlStateNormal];
                [self.codeBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 91;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                //                [self.codeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                
                [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"Login_sendmessage_select"] forState:UIControlStateNormal];
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%.2ds后重新发送",seconds] forState:0];
                
                [self.codeBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


#pragma mark responce Evne

- (void)jfURLConnection:(JFNetworkAFN *)jfURLConnection withError:(id)error {
    
    if (error) {
        [[YKToastView sharedToastView] hide];
        NSLog(@"error = %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:error backgroundcolor:white];
        });
        return;
    }
    
    switch (jfURLConnection.connectionType) {
            
        case JFConnectionTypeBindingCard:
        {
            [[YKToastView sharedToastView] hide];
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleBindingResponse:responsedict];
        }
            break;
        case JFConnectionTypeQuota:
        {
            [[YKToastView sharedToastView] hide];
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleQuotaResponse:responsedict];
        }
            break;
        case JFConnectionTypeSendCodeRegister:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            
            [self handleSendCodeResponse:responsedict];
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


- (void)handlePullBankInformationResponse:(NSDictionary *)dictionary  {
    NSLog(@"dic =%@",dictionary);
    JFPullBankInformationParser *pullBankParser = [JFPullBankInformationParser sharedPullBankParser];
    pullBankParser.sourceData = dictionary;
    if (pullBankParser.code == [JFKStatusCode integerValue]) {
        
        if (![JFString judgeString:pullBankParser.dataDictnary[@"bankCardNo"]]) {
            
            if ([pullBankParser.dataDictnary[@"modify"] integerValue] == 1) {
                
                self.bindingBankNoText.enabled = NO;
                self.bindingPhoneNumber.enabled = NO;
            }else {
                self.bindingBankNoText.enabled = YES;
                self.bindingPhoneNumber.enabled = YES;
            }
            
            self.bindingBankNoText.text = pullBankParser.dataDictnary[@"bankCardNo"];
            self.bindingPhoneNumber.text = pullBankParser.dataDictnary[@"mobile"];
        }
    }
}


- (void)handleSendCodeResponse:(NSDictionary *)dictionary {
    NSLog(@"message=%@",dictionary);
    JFSendCodeParser *phoneNumberParser = [JFSendCodeParser sharedSendCodeParser];
    phoneNumberParser.sourceData = dictionary;
    if (phoneNumberParser.code == [JFKStatusCode integerValue] ) {
        NSLog(@"发送验证码成功！");
    }else {
        [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:phoneNumberParser.message backgroundcolor:white];
    }
}


- (void)handleQuotaResponse:(NSDictionary *)dictionary {
    
    NSLog(@"dic =%@",dictionary);
    JFQuotaParser *quotaParser = [JFQuotaParser sharedQuotaParser];
    quotaParser.sourceData = dictionary;
    if (quotaParser.code == [JFKStatusCode integerValue]) {
        
        // 获取额度成功
        JFOpeningStageSuccessfulViewController *sucessfulController = [[JFOpeningStageSuccessfulViewController alloc] initWithNibName:@"JFOpeningStageSuccessfulViewController" bundle:nil];
        sucessfulController.auotaValues = quotaParser.quota;
        sucessfulController.navigationItem.hidesBackButton = YES;
        [self.navigationController pushViewController:sucessfulController animated:YES];
        
    }else {
        
        // 获取额度失败
        JFOpeningStageFailViewController *failController = [[JFOpeningStageFailViewController alloc]initWithNibName:@"JFOpeningStageFailViewController" bundle:nil];
        failController.navigationItem.hidesBackButton = YES;
        [self.navigationController pushViewController:failController animated:YES];
        NSLog(@"errorMessage =%@",quotaParser.message);
        //        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:sesameParser.message backgroundcolor:white];
    }
}



- (void)handleBindingResponse:(NSDictionary *)dictionary {
    NSLog(@"dic =%@",dictionary);
    JFBindingParser *bindingParser = [JFBindingParser sharedBindingParser];
    bindingParser.sourceData = dictionary;
    
    if (bindingParser.code == [JFKStatusCode integerValue]) {
        
        // 绑卡成功
        // 请求接口
        JFQuotaBuilder *quotaBuilder = [JFQuotaBuilder sharedQuota];
        [quotaBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
        
        JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
        [afnet requestHttpDataWithPath:quotaBuilder.requestURL params:quotaBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
        afnet.connectionType = JFConnectionTypeQuota;
        
    }else if (bindingParser.code == [JFKBankStatusCode integerValue]) {
        
        self.navigationController.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        
        NSLog(@"errorMessage =%@",bindingParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:bindingParser.message backgroundcolor:white];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.bindingBankNoText resignFirstResponder];
    [self.bindingPhoneNumber resignFirstResponder];
    [self.bindingCodeText resignFirstResponder];
}

@end

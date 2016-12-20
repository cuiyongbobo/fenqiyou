//
//  JFOpeningStageCertificationInstitutionViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/16.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFOpeningStageCertificationInstitutionViewController.h"

#import "JFOpeningStageCreditAuthorizationViewController.h"
#import "JFSesameAuthorizationBuilder.h"
#import "JFSesameAuthorizationParser.h"
#import "JFNetworkAFN.h"
#import "JFString.h"
#import "JFTipsWindow.h"
#import "UIColor+Hex.h"
#import "JFQuotaBuilder.h"
#import "JFQuotaParser.h"
#import "JFOpeningStageSuccessfulViewController.h"
#import "JFOpeningStageFailViewController.h"
#import "JFOpeningStageBindingBankCardViewController.h"
#import <ZMCreditSDK/ALCreditService.h>
#import "JFNavigationController.h"
#import "UIColor+Hex.h"
#import "JFColor.h"



@interface JFOpeningStageCertificationInstitutionViewController ()

@property (nonatomic, assign) BOOL isCreditAuthorization;
@property (nonatomic, assign) BOOL issesameAuthorization;
@end

@implementation JFOpeningStageCertificationInstitutionViewController


#pragma mark life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"机构认证" showRightBtn:NO showLeftBtn:YES currentController:self];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
    [self.bindingCreditView addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapSesameGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureSesameClick:)];
    [self.bindingSesameView addGestureRecognizer:tapSesameGesture];
    
}

#pragma mark navigation back
- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([UIDevice currentDevice].systemVersion.floatValue == 7) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithHexString:JFKNavigationBarBackgroundColor]];
    }else{
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:JFKNavigationBarBackgroundColor]];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:JFKSesameAuthorization] || [[NSUserDefaults standardUserDefaults] objectForKey:JFKCreditAuthorization]) {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:JFKCreditAuthorization]) {
            
            self.creditAuthorizationStateLabel.text = @"已授权";
            self.isCreditAuthorization = YES;
            [self.certificationImageview setHidden:YES];
            self.creditAuthorizationStateLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
            
        }else if ([[NSUserDefaults standardUserDefaults] objectForKey:JFKSesameAuthorization]) {
            
            self.sesameAuthorizationStateLabel.text = @"已授权";
            self.issesameAuthorization = YES;
            [self.sesameImageView setHidden:YES];
            self.sesameAuthorizationStateLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
            
        }
        
        [self.bindingNextButton setBackgroundImage:[UIImage imageNamed:@"openingstage_realConfirm"] forState:UIControlStateNormal];
        self.bindingNextButton.enabled = YES;
        
    }else {
        
        [self.bindingNextButton setBackgroundImage:[UIImage imageNamed:@"openingstage_realConfirm_select"] forState:UIControlStateNormal];
        self.bindingNextButton.enabled = NO;
        
    }
}


- (void)tapGestureClick:(UITapGestureRecognizer *)tap {
    NSLog(@"信用卡授权");
    if (self.isCreditAuthorization) {
        return;
    }
    JFOpeningStageCreditAuthorizationViewController *careditAuthoriza = [[JFOpeningStageCreditAuthorizationViewController alloc] initWithNibName:@"JFOpeningStageCreditAuthorizationViewController" bundle:nil];
    [self.navigationController pushViewController:careditAuthoriza animated:YES];
    
    careditAuthoriza.CreditAuthorizationResult = ^(BOOL result){
        
        if (result) {
            NSLog(@"信用卡授权成功");
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:weakSelf tiptext:@"信用卡授权成功" backgroundcolor:white];
                weakSelf.creditAuthorizationStateLabel.text = @"已授权";
                weakSelf.isCreditAuthorization = YES;
                [weakSelf.certificationImageview setHidden:YES];
                weakSelf.creditAuthorizationStateLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
                [weakSelf.bindingNextButton setBackgroundImage:[UIImage imageNamed:@"openingstage_realConfirm"] forState:UIControlStateNormal];
                weakSelf.bindingNextButton.enabled = YES;
                
                [[NSUserDefaults standardUserDefaults] setObject:@"信用卡授权" forKey:JFKCreditAuthorization];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
            });
        }
    };
}


- (void)tapGestureSesameClick:(UITapGestureRecognizer *)tap {
    NSLog(@"芝麻授权");
    if (self.issesameAuthorization) {
        return;
    }
    // 加密
    // 请求接口
    JFSesameAuthorizationBuilder *sesameBuilder = [JFSesameAuthorizationBuilder sharedSesameAuthorization];
    
    [sesameBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] crypto:@"encryp" channel:@"appsdk" params:@"" redirectUrl:@"" appId:@"" sign:@""];
    
    JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
    [afnet requestHttpDataWithPath:sesameBuilder.requestURL params:sesameBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    afnet.connectionType = JFConnectionTypeSesameAuthorizationEncryp;
    
}


#pragma mark responce Evne

- (void)jfURLConnection:(JFNetworkAFN *)jfURLConnection withError:(id)error {
    
    if (error) {
        NSLog(@"error = %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:error backgroundcolor:white];
        });
        return;
    }
    switch (jfURLConnection.connectionType) {
            
        case JFConnectionTypeSesameAuthorizationEncryp:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleTravelPersonResponse:responsedict];
        }
            break;
        case JFConnectionTypeSesameAuthorizationdecryp:
        {
            
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleSesameDecrypResponse:responsedict];
            
        }
            break;
        case JFConnectionTypeQuota:
        {
            
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleQuotaResponse:responsedict];
        }
            break;
            
        default:
            break;
    }
}

- (void)handleTravelPersonResponse:(NSDictionary *)dictionary {
    
    NSLog(@"dic =%@",dictionary);
    JFSesameAuthorizationParser *sesameParser = [JFSesameAuthorizationParser sharedSesameAuthorization];
    sesameParser.sourceData = dictionary;
    if (sesameParser.code == [JFKStatusCode integerValue]) {
        
        NSString *params = sesameParser.sourceDictionary[@"params"];
        NSString *appId = sesameParser.sourceDictionary[@"appId"];
        NSString *sign = sesameParser.sourceDictionary[@"sign"];
        
        [[ALCreditService sharedService] queryUserAuthReq:appId sign:sign params:params  extParams:nil selector:@selector(creditResult:) target:self];
        
    }else {
        
        NSLog(@"errorMessage =%@",sesameParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:sesameParser.message backgroundcolor:white];
    }
    
}


- (void)creditResult:(NSMutableDictionary*)dic {
    
    if ([UIDevice currentDevice].systemVersion.floatValue == 7) {
        // JFKNavigationBarBackgroundColor
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithHexString:JFKNavigationBarBackgroundColor]];
    }else{
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:JFKNavigationBarBackgroundColor]];
    }
    // 请求解密
    // 请求接口
    
    NSString *params = dic[@"params"];
    NSString *sign = dic[@"sign"];
    
    if ([dic[@"authResult"] isEqualToString:@"success"]) {
        JFSesameAuthorizationBuilder *sesameBuilder = [JFSesameAuthorizationBuilder sharedSesameAuthorization];
        [sesameBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] crypto:@"decryp" channel:@"appsdk" params:params redirectUrl:@"" appId:@"" sign:sign];
        JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
        [afnet requestHttpDataWithPath:sesameBuilder.requestURL params:sesameBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
        afnet.connectionType = JFConnectionTypeSesameAuthorizationdecryp;
    }
    
}

- (void)handleSesameDecrypResponse:(NSDictionary *)dictionary {
    
    NSLog(@"dic =%@",dictionary);
    JFSesameAuthorizationParser *sesameParser = [JFSesameAuthorizationParser sharedSesameAuthorization];
    sesameParser.sourceData = dictionary;
    if (sesameParser.code == [JFKStatusCode integerValue]) {
        
        // 芝麻授信成功
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:weakSelf tiptext:@"芝麻授信成功" backgroundcolor:white];
            weakSelf.sesameAuthorizationStateLabel.text = @"已授权";
            weakSelf.issesameAuthorization = YES;
            [weakSelf.sesameImageView setHidden:YES];
            weakSelf.sesameAuthorizationStateLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
            
            [weakSelf.bindingNextButton setBackgroundImage:[UIImage imageNamed:@"openingstage_realConfirm"] forState:UIControlStateNormal];
            weakSelf.bindingNextButton.enabled = YES;
            
            [[NSUserDefaults standardUserDefaults] setObject:@"芝麻分授权" forKey:JFKSesameAuthorization];
            [[NSUserDefaults standardUserDefaults]synchronize];
        });
        
    }else {
        
        NSLog(@"errorMessage =%@",sesameParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:sesameParser.message backgroundcolor:white];
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
        [self.navigationController pushViewController:sucessfulController animated:YES];
        
    }else {
        
        // 获取额度失败
        
        JFOpeningStageFailViewController *failController = [[JFOpeningStageFailViewController alloc]initWithNibName:@"JFOpeningStageFailViewController" bundle:nil];
        [self.navigationController pushViewController:failController animated:YES];
        NSLog(@"errorMessage =%@",quotaParser.message);
        //        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:sesameParser.message backgroundcolor:white];
    }
    
}


#pragma mark handle Even

- (IBAction)handleNext:(id)sender {
    
    //    if ([self.sesameAuthorizationStateLabel.text isEqualToString:@"已授权"]) {
    //        [[NSUserDefaults standardUserDefaults] setObject:@"芝麻分授权" forKey:JFKSesameAuthorization];
    //        [[NSUserDefaults standardUserDefaults]synchronize];
    //    }else if ([self.creditAuthorizationStateLabel.text isEqualToString:@"已授权"]) {
    //        [[NSUserDefaults standardUserDefaults] setObject:@"信用卡授权" forKey:JFKCreditAuthorization];
    //        [[NSUserDefaults standardUserDefaults]synchronize];
    //    }
    
    // 绑卡
    JFOpeningStageBindingBankCardViewController *bindingBankController = [[JFOpeningStageBindingBankCardViewController alloc] initWithNibName:@"JFOpeningStageBindingBankCardViewController" bundle:nil];
    [self.navigationController pushViewController:bindingBankController animated:YES];
    
}
@end

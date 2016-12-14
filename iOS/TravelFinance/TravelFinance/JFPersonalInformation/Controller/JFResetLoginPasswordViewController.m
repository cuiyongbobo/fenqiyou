//
//  JFResetLoginPasswordViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/15.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFResetLoginPasswordViewController.h"

#import "UIColor+Hex.h"
#import "JFTipsWindow.h"
#import "JFString.h"
#import "JFResetLoginPasswordBuilder.h"
#import "JFResetLoginPasswordParser.h"
#import "JFNetworkAFN.h"
#import "JFTipsWindow.h"
#import "JFSendCodeBuilder.h"
#import "JFSendCodeParser.h"
#import "JFMacro.h"


@interface JFResetLoginPasswordViewController ()<UITextFieldDelegate>

@end

@implementation JFResetLoginPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"重置登录密码" showRightBtn:NO showLeftBtn:YES currentController:self];
    if (DEVICE_5 || DEVICE_4S) {
        self.sendCodeWidth.constant = 105*JFWidthRateScale;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
            
        case JFConnectionTypeResetLoginPassword:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            
            [self handleResetLoginPasswordResponse:responsedict];
        }
            break;
        case JFConnectionTypeSendCodeRegister:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            
            [self handleSendCodeResponse:responsedict];
        }
            break;
            
        default:
            break;
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

- (void)handleResetLoginPasswordResponse:(NSDictionary *)dictionary {
    NSLog(@"dic =%@",dictionary);
    
    JFResetLoginPasswordParser *resetLoginPasswordParser = [JFResetLoginPasswordParser sharedResetLoginPasswordParser];
    resetLoginPasswordParser.sourceData = dictionary;
    if (resetLoginPasswordParser.code == [JFKStatusCode integerValue]) {
        
        // 跳转到主页
        self.navigationController.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }else {
        NSLog(@"errorMessage =%@",resetLoginPasswordParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:resetLoginPasswordParser.message backgroundcolor:white];
    }
}



#pragma mark navigation back
- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
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
                [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"personalInformation_sendCode"] forState:UIControlStateNormal];
                [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                [self.codeBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 91;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                //                [self.codeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                
                [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"personalInformation_sendCode_select"] forState:UIControlStateNormal];
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%.2ds后重新发送",seconds] forState:0];
                
                [self.codeBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (BOOL)isPassword:(NSString *)password {
    NSString * phoneRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if ([regextestmobile evaluateWithObject:password]) {
        return YES;
    }else{
        return NO;
    }
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

#pragma mark text delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _phoneText) {
        NSString *verifyCode = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (verifyCode.length > 11) {
            return NO;
        }
    }
    return YES;
}


#pragma mark handle Even

- (IBAction)handleSendCode:(id)sender {
    
    if ([self isMobileNumber:self.phoneText.text]) {
        
        [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"验证码已发送"] backgroundcolor:white];
        
        JFSendCodeBuilder *sendCodeBuilder = [JFSendCodeBuilder sharedSendCode];
        [sendCodeBuilder buildPostData:self.phoneText.text type:@"3"];
        
        [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:sendCodeBuilder.requestURL params:sendCodeBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
        [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeSendCodeRegister;
        
        [self openCountdown];
    }else {
        [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"请输入有效手机号"] backgroundcolor:white];
    }
}

- (IBAction)handleconfirm:(id)sender {
    
    [self.phoneText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.codeText resignFirstResponder];
    
    if ([self isMobileNumber:self.phoneText.text]) {
        if ([self isPassword:self.passwordText.text]) {
            
            if (![JFString judgeString:self.codeText.text]) {
                
                // 首页数据
                JFResetLoginPasswordBuilder *resetLoginpasswordBuilder = [JFResetLoginPasswordBuilder sharedResetLoginPassword];
                [resetLoginpasswordBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] mobile:self.phoneText.text checkNo:self.codeText.text newLoginPwd:self.passwordText.text];
                
                JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
                [afnet requestHttpDataWithPath:resetLoginpasswordBuilder.requestURL params:resetLoginpasswordBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
                afnet.connectionType = JFConnectionTypeResetLoginPassword;
                
                
            }else {
                [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"请输入验证码"] backgroundcolor:white];
            }
            
        }else {
            [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"请输入8-16位包含字母数字密码"] backgroundcolor:white];
        }
        
    }else {
        [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"请输入有效手机号"] backgroundcolor:white];
    }
    
    
}
@end

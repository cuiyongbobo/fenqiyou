//
//  JFInputPhoneNumberViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/24.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFInputPhoneNumberViewController.h"

#import "JFLoginViewController.h"
#import "JFRegisterViewController.h"
#import "JFInputPhoneNumberBuilder.h"
#import "JFNetworkAFN.h"
#import "JFConnectionType.h"
#import "JFInputPhoneNumberParser.h"
#import "JFNavigationController.h"
#import "JFDevice.h"
#import "JFLoginViewController.h"
#import "JFRegisterViewController.h"
#import "JFString.h"
#import "JFTipsWindow.h"
#import "UIColor+Hex.h"
#import "GestureViewController.h"
#import "JFInitialization.h"
#import "JFWebViewController.h"
#import "JFBaseLibCommon.h"
#import "YKToastView.h"
#import "JFWKWebViewController.h"
#import "JFMacro.h"


static BOOL change = YES;


@interface JFInputPhoneNumberViewController ()<JFURLConnectionDelegate,UITextFieldDelegate>
{
    UIImageView *_TitleImage;
    UILabel *companyAccount;
}

@property (weak, nonatomic) IBOutlet UITextField *inputphoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (nonatomic,assign) CGRect  Orginframe;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, assign) BOOL isSuccessCheck;

- (IBAction)handleCheckBoxButtonEvent:(id)sender;
- (IBAction)handleUserAgreementButtonEvent:(id)sender;
- (IBAction)handleNextButtonEvent:(id)sender;

@end


@implementation JFInputPhoneNumberViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNavigation:@"输入手机号" showRightBtn:NO showLeftBtn:YES currentController:self];
    _checkBoxButton.selected = YES;
    change = NO;
    self.inputphoneNumber.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    //    CGRect *orginsize = self.view.frame;
//    CGRect frame = self.view.frame;
//    if (frame.origin.y == 0) {
//        frame.origin.y = 64;
//    }
//    self.Orginframe = frame;
//}

#pragma  mark handle Even

- (IBAction)handleCheckBoxButtonEvent:(id)sender {
    //    if (change) {
    //        change = NO;
    //        UIButton *button = (UIButton *)sender;
    //        button.selected = YES;
    //
    //
    //    }else {
    //        change = YES;
    //        UIButton *button = (UIButton *)sender;
    //        button.selected = NO;
    //    }
    
}

- (IBAction)handleUserAgreementButtonEvent:(id)sender {
    NSLog(@"跳转链接");
    
    if (SUPPORT_WKWEBVIEW) {
        JFWKWebViewController *webViewController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
        NSString *AgreementRequestURL = @"/bwOrder/findAgreement?code=WZ";
        webViewController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:AgreementRequestURL];
        webViewController.navigationItem.hidesBackButton = YES;
        webViewController.isShowNavigation = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
        
    }else {
        JFWebViewController *webViewController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
        NSString *AgreementRequestURL = @"/bwOrder/findAgreement?code=WZ";
        webViewController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:AgreementRequestURL];
        webViewController.navigationItem.hidesBackButton = YES;
        webViewController.isShowNavigation = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
        
    }
    
    
}

- (IBAction)handleNextButtonEvent:(id)sender {
    
    [UIView animateWithDuration:0.3f animations:^{
        
        CGRect frame = self.view.frame;
        frame.origin.y = 64;
        self.view.frame = frame;
        //        if (!CGRectEqualToRect(self.Orginframe, self.view.frame)) {
        //            self.view.frame = self.Orginframe;
        //        }
        [self.inputphoneNumber resignFirstResponder];
    }];
    
    //    if (self.isSuccessCheck) {
    //        self.isSuccessCheck = NO;
    //        return;
    //    }
    // 判断手机号
    if (![JFString judgeString:self.inputphoneNumber.text]) {
        if ([self isMobileNumber:self.inputphoneNumber.text]) {
            
            YKToastView *toastView = [YKToastView sharedToastViewWWithIndicatorAndText:JFKLoadingMessage];
            [toastView showInView:self.view];
            
            JFInputPhoneNumberBuilder *loadWithdrawalsBuilder = [JFInputPhoneNumberBuilder sharedInputPhone];
            [loadWithdrawalsBuilder buildPostData:self.inputphoneNumber.text];
            
            [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:loadWithdrawalsBuilder.requestURL params:loadWithdrawalsBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
            [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypePhoneCheck;
        }else {
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请输入有效手机号" backgroundcolor:white];
        }
        
    }else {
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请输入手机号" backgroundcolor:white];
    }
}

#pragma mark touch Even

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 64;
        self.view.frame = frame;
        //        if (!CGRectEqualToRect(self.Orginframe, self.view.frame)) {
        //            self.view.frame = self.Orginframe;
        //        }
        [self.inputphoneNumber resignFirstResponder];
    }];
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
        case JFConnectionTypePhoneCheck:
        {
            [[YKToastView sharedToastView] hide];
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleCheckPhoneNumberResponse:responsedict];
        }
            break;
            
        default:
            break;
    }
}

- (void)handleCheckPhoneNumberResponse:(NSDictionary *)dictionary {
    
    NSLog(@"message=%@",dictionary);
    JFInputPhoneNumberParser *phoneNumberParser = [JFInputPhoneNumberParser sharedInputPhoneParser];
    phoneNumberParser.sourceData = dictionary;
    [[NSUserDefaults standardUserDefaults] setObject:self.inputphoneNumber.text forKey:JFKUserPhoneNumber];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (phoneNumberParser.code == [JFKStatusCode integerValue]) {
        
        //        self.isSuccessCheck = YES;
        // 保存手机号
        
        [[NSUserDefaults standardUserDefaults] setObject:self.inputphoneNumber.text forKey:@"saveCheckPhone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([phoneNumberParser.userType isEqualToString:@"oldUser"]) {
            JFLoginViewController * loginViewController = [[JFLoginViewController alloc] initWithNibName:@"JFLoginViewController" bundle:nil];
            [self.navigationController pushViewController:loginViewController animated:YES];
        }else if ([phoneNumberParser.userType isEqualToString:@"newUser"]) {
            JFRegisterViewController * registerViewController = [[JFRegisterViewController alloc] initWithNibName:@"JFRegisterViewController" bundle:nil];
            [self.navigationController pushViewController:registerViewController animated:YES];
        }
    }else {
        NSLog(@"errorMessage =%@",phoneNumberParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:phoneNumberParser.message backgroundcolor:white];
    }
}

#pragma mark navigation back
- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    
    if (_GestureLock) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
}

#pragma mark text delegate

- (void) registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.Orginframe = self.view.frame;
    if (self.view.frame.size.height -(self.nextButton.frame.origin.y+self.nextButton.frame.size.height)<height) {
        CGFloat Lowhight=height-(self.view.frame.size.height-(self.nextButton.frame.origin.y+self.nextButton.frame.size.height));
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = CGRectMake(self.Orginframe.origin.x, self.Orginframe.origin.y-Lowhight, self.Orginframe.size.width, self.Orginframe.size.height);
        }];
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

#pragma mark get

//- (CGRect)Orginframe {
//    _Orginframe = self.view.frame;
//    return _Orginframe;
//}

@end

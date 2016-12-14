//
//  JFLoginViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/24.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFLoginViewController.h"

#import "JFLoginBuilder.h"
#import "JFLoginParser.h"
#import "JFNetworkAFN.h"
#import "JFDynamicCodeLoginBuilder.h"
#import "JFDynamicCodeLoginParser.h"
#import "JFString.h"
#import "JFStagingTourViewController.h"
#import "JFTabBarController.h"
#import "JFTipsWindow.h"
#import "UIColor+Hex.h"
#import "JFSendCodeBuilder.h"
#import "JFSendCodeParser.h"
#import "GestureViewController.h"
#import "JFNavigationController.h"
#import "JFInitialization.h"
#import "JFDevice.h"
#import "JFMacro.h"
#import "JFString.h"

static BOOL change = YES;
//static BOOL sendCode = YES;

@interface JFLoginViewController ()<JFURLConnectionDelegate>
{
    NSString *_changeLoginStatus;
}
@property (weak, nonatomic) IBOutlet UIView *passwordLoginView;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIView *dynamicPasswordLoginView;
@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UIButton *passwordLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *dynamicPasswordLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic,assign) CGRect  Orginframe;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codebuttonWidth;


- (IBAction)handleShowPasswordButtonEvent:(id)sender;
- (IBAction)handleLoginButtonEvent:(id)sender;
- (IBAction)sendCodeButtonEvent:(id)sender;
- (IBAction)handlePasswordLoginButtonEvent:(id)sender;
- (IBAction)handleDynamicLoginButtonEvent:(id)sender;


@end

@implementation JFLoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.passwordLoginButton.selected = YES;
    self.dynamicPasswordLoginButton.selected = NO;
    [self.dynamicPasswordLoginView setHidden:YES];
    _changeLoginStatus = @"passwordLogin";
    if ([JFDevice screenHeight] <= 568) {
        self.codebuttonWidth.constant = 105*JFWidthRateScale;
    }
    [self configNavigation:@"登录" showRightBtn:NO showLeftBtn:YES currentController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void) registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    if (self.view.frame.size.height -(self.loginButton.frame.origin.y+self.loginButton.frame.size.height)<height) {
        CGFloat Lowhight=height-(self.view.frame.size.height-(self.loginButton.frame.origin.y+self.loginButton.frame.size.height));
        [UIView animateWithDuration:0.3f animations:^{
            self.Orginframe = self.view.frame;
            self.view.frame = CGRectMake(self.Orginframe.origin.x, self.Orginframe.origin.y-Lowhight, self.Orginframe.size.width, self.Orginframe.size.height);
        }];
    }
}

#pragma mark handle Even

- (IBAction)handleShowPasswordButtonEvent:(id)sender {
    
    UIButton *button = (UIButton *) sender;
    if (change) {
        button.selected = YES;
        change = NO;
        self.passwordText.secureTextEntry = NO;
    }else {
        button.selected = NO;
        change = YES;
        self.passwordText.secureTextEntry = YES;
    }
}

- (IBAction)handleLoginButtonEvent:(id)sender {
    
    [UIView animateWithDuration:0.3f animations:^{
        if (!CGRectEqualToRect(self.view.frame, self.Orginframe)) {
            self.view.frame = self.Orginframe;
        }
        [self.passwordText resignFirstResponder];
        [self.messageText resignFirstResponder];
    }];
    
    
    if ([_changeLoginStatus isEqualToString:@"passwordLogin"]) {
        
        if (![JFString judgeString:self.passwordText.text]) {
            JFLoginBuilder *loginBuilder = [JFLoginBuilder sharedLogin];
            [loginBuilder buildPostData:self.passwordText.text];
            
            [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:loginBuilder.requestURL params:loginBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
            [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeLogin;
            
        }else {
            
            // 请输入密码
            [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"请输入密码"] backgroundcolor:white];
        }
        
    }else if ([_changeLoginStatus isEqualToString:@"dynamicLogin"]) {
        
        if (![JFString judgeString:self.messageText.text]) {
            JFDynamicCodeLoginBuilder *dynamicLoginBuilder = [JFDynamicCodeLoginBuilder sharedDynamicCodeLogin];
            [dynamicLoginBuilder buildPostData:self.messageText.text];
            
            [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:dynamicLoginBuilder.requestURL params:dynamicLoginBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
            [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypedynamicLogin;
        }else {
           [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"请输入验证码"] backgroundcolor:white];
        }
        
    }
    
}

- (IBAction)sendCodeButtonEvent:(id)sender {
    
    [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"验证码已发送"] backgroundcolor:white];
    
    [self openCountdown];
    
    JFSendCodeBuilder *sendCodeBuilder = [JFSendCodeBuilder sharedSendCode];
    [sendCodeBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:@"saveCheckPhone"] type:@"2"];
    
    [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:sendCodeBuilder.requestURL params:sendCodeBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeSendCodeRegister;
    
}

- (IBAction)handlePasswordLoginButtonEvent:(id)sender {
    
    UIButton * loginbutton = (UIButton *) sender;
    loginbutton.selected = YES;
    [self.passwordLoginView setHidden:NO];
    // 切换登录方式
    self.dynamicPasswordLoginButton.selected = NO;
    [self.dynamicPasswordLoginView setHidden:YES];
    
    _changeLoginStatus = @"passwordLogin";
    
}

- (IBAction)handleDynamicLoginButtonEvent:(id)sender {
    UIButton * loginbutton = (UIButton *) sender;
    loginbutton.selected = YES;
    [self.dynamicPasswordLoginView setHidden:NO];
    
    self.passwordLoginButton.selected = NO;
    [self.passwordLoginView setHidden:YES];
    
    _changeLoginStatus = @"dynamicLogin";
    
}

#pragma net Response
- (void)jfURLConnection:(JFNetworkAFN *)jfURLConnection withError:(id)error {
    
    if (error) {
        NSLog(@"error");
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:error backgroundcolor:white];
        return;
    }
    switch (jfURLConnection.connectionType) {
        case JFConnectionTypeLogin:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleLoginResponse:responsedict];
        }
            break;
        case JFConnectionTypedynamicLogin:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handledynamicLoginResponse:responsedict];
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

- (void)handleLoginResponse:(NSDictionary *)dictionary {
    
    NSLog(@"message=%@",dictionary);
    JFLoginParser *loginParser = [JFLoginParser sharedLoginParser];
    loginParser.sourceData = dictionary;
    
    if (loginParser.code == [JFKStatusCode integerValue]) {
        [[NSUserDefaults standardUserDefaults] setObject:loginParser.userId forKey:JFKUserId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        [gestureVc setType:GestureViewControllerTypeSetting];
        gestureVc.currentViewController = self;
        [self presentViewController:gestureVc animated:YES completion:nil];
        
    }else {
        NSLog(@"errorMessage =%@",loginParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:loginParser.message backgroundcolor:white];
    }
}

- (void)handledynamicLoginResponse:(NSDictionary *)dictionary {
    
    NSLog(@"message=%@",dictionary);
    JFDynamicCodeLoginParser *dynamicParser = [JFDynamicCodeLoginParser sharedDynamicLoginParser];
    dynamicParser.sourceData = dictionary;
    
    if (dynamicParser.code == [JFKStatusCode integerValue]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:dynamicParser.userId forKey:JFKUserId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //        NSString *isreal = @"";
        //        if (![JFString judgeString:dynamicParser.isReal]) {
        //            isreal = dynamicParser.isReal;
        //        }
        //        [[NSUserDefaults standardUserDefaults] setObject:isreal forKey:JFKIsReal];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //        self.navigationController.tabBarController.selectedIndex = 0;
        //        [self.navigationController popToRootViewControllerAnimated:YES];
        
        //        [UIApplication sharedApplication].delegate.window.rootViewController = [[JFInitialization sharedInitial]loadHomePage];
        
        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        [gestureVc setType:GestureViewControllerTypeSetting];
        [self presentViewController:gestureVc animated:YES completion:nil];
        
        
    }else {
        NSLog(@"errorMessage =%@",dynamicParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:dynamicParser.message backgroundcolor:white];
    }
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
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%ds后重新发送",seconds] forState:0];
                
                [self.codeBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
}

#pragma mark get/set

- (CGRect)Orginframe {
    _Orginframe = self.view.frame;
    return _Orginframe;
}


@end

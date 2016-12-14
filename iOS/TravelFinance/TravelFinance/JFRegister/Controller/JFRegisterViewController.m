//
//  JFRegisterViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/24.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFRegisterViewController.h"

#import "JFSendCodeBuilder.h"
#import "JFSendCodeParser.h"
#import "JFNetworkAFN.h"
#import "JFRegisterBuilder.h"
#import "JFRegisterParser.h"
#import "JFString.h"
#import "JFTipsWindow.h"
#import "UIColor+Hex.h"
#import "JFInitialization.h"
#import "GestureViewController.h"


static BOOL change = YES;
//static BOOL sendCode = YES;

@interface JFRegisterViewController ()<JFURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *InputCodeText;
@property (weak, nonatomic) IBOutlet UITextField *setPasswordText;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (nonatomic,assign) CGRect  Orginframe;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;


- (IBAction)handleRegisterButtonEvent:(id)sender;
- (IBAction)handleSendCodeButtonEvent:(id)sender;
- (IBAction)handleShowPasswordButtonEvent:(id)sender;


@end

@implementation JFRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNavigation:@"注册" showRightBtn:NO showLeftBtn:YES currentController:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


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
    
    if (self.view.frame.size.height -(self.registerButton.frame.origin.y+self.registerButton.frame.size.height)<height) {
        CGFloat Lowhight=height-(self.view.frame.size.height-(self.registerButton.frame.origin.y+self.registerButton.frame.size.height));
        [UIView animateWithDuration:0.3f animations:^{
            self.Orginframe = self.view.frame;
            self.view.frame = CGRectMake(self.Orginframe.origin.x, self.Orginframe.origin.y-Lowhight, self.Orginframe.size.width, self.Orginframe.size.height);
        }];
    }
}


#pragma  mark handle Even

- (IBAction)handleRegisterButtonEvent:(id)sender {
    
    [UIView animateWithDuration:0.3f animations:^{
        if (!CGRectEqualToRect(self.Orginframe, self.view.frame)) {
            self.view.frame = self.Orginframe;
        }
        [self.InputCodeText resignFirstResponder];
        [self.setPasswordText resignFirstResponder];
    }];
    
    // 验证码
    if ([JFString judgeString:self.InputCodeText.text]) {
        
        [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:@"验证码为空" backgroundcolor:white];
    }else {
        // 密码
        if ([JFString judgeString:self.setPasswordText.text]) {
            NSLog(@"密码为空");
            [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:@"密码为空" backgroundcolor:white];
        }else {
            // 密码长度
            if ([self isPassword:self.setPasswordText.text]) {
                // 注册
                JFRegisterBuilder *registerBuilder = [JFRegisterBuilder sharedRegister];
                [registerBuilder buildPostData:self.InputCodeText.text userPassword:self.setPasswordText.text];
                
                [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:registerBuilder.requestURL params:registerBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
                [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeRegister;
            }else {
                
                [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:@"密码为8-16位数字和字母组合" backgroundcolor:white];
            }
        }
    }
}

- (IBAction)handleSendCodeButtonEvent:(id)sender {
    
    [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"验证码已发送"] backgroundcolor:white];
    
    [self openCountdown];
    JFSendCodeBuilder *sendCodeBuilder = [JFSendCodeBuilder sharedSendCode];
    [sendCodeBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:@"saveCheckPhone"] type:@"1"];
    
    [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:sendCodeBuilder.requestURL params:sendCodeBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeSendCodeRegister;
    
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



- (IBAction)handleShowPasswordButtonEvent:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (change) {
        button.selected = YES;
        change = NO;
        self.setPasswordText.secureTextEntry = NO;
    }else {
        button.selected = NO;
        change = YES;
        self.setPasswordText.secureTextEntry = YES;
    }
}

#pragma mark Net Event

- (void)jfURLConnection:(JFNetworkAFN *)jfURLConnection withError:(id)error {
    
    if (error) {
        NSLog(@"error");
        [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:error backgroundcolor:white];
        return;
    }
    switch (jfURLConnection.connectionType) {
        case JFConnectionTypeSendCodeRegister:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            
            [self handleSendCodeResponse:responsedict];
        }
            break;
        case JFConnectionTypeRegister:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleRegisterResponse:responsedict];
            
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

- (void)handleRegisterResponse:(NSDictionary *)dictionary {
    NSLog(@"message=%@",dictionary);
    JFRegisterParser *registerParser = [JFRegisterParser sharedRegisterParser];
    registerParser.sourceData = dictionary;
    if (registerParser.code == [JFKStatusCode integerValue]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:registerParser.userId forKey:JFKUserId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        [gestureVc setType:GestureViewControllerTypeSetting];
        [self presentViewController:gestureVc animated:YES completion:nil];
        
    }else {
        
        [[JFTipsWindow sharedTipview]HiddenTipView:NO viewcontroller:self tiptext:registerParser.message backgroundcolor:white];
    }
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

- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
}

#pragma mark get

- (CGRect)Orginframe {
    _Orginframe = self.view.frame;
    return _Orginframe;
}

@end



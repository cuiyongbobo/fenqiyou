
#import "GestureViewController.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"
#import "SYMConstantCenter.h"
//#import "LoginViewController.h"
//#import "SYMDataBaseCenter.h"
//#import "SYMDataBaseModel.h"
#import "JFInputPhoneNumberViewController.h"

#import "JFInitialization.h"

#import "JFString.h"
#import "AppDelegate.h"
#import "JFNavigationController.h"

#define GET_APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface GestureViewController ()<CircleViewDelegate>
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    int _recordErrorNumber;
}

/**
 *  重设按钮
 */
@property (nonatomic, strong) UIButton *resetBtn;

/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;

@end

@implementation GestureViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    if (self.type == GestureViewControllerTypeLogin) {
    //        [self.navigationController setNavigationBarHidden:NO animated:animated];
    //    }
    
    // 进来先清空存的第一个密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    [self initNavigationView];
    
    [self.view setBackgroundColor:CircleViewBackgroundColor];
    //[self.view setBackgroundColor:[UIColor redColor]];
    [self initNavigationView];
    // 1.界面相同部分生成器
    [self setupSameUI];
    // 2.界面不同部分生成器
    [self setupDifferentUI];
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
//    _TitleImage.image=[UIImage imageNamed:NULL];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"设置手势密码";
    
    //  定义Navigation 的左右按钮
    UIButton *Leftbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    Leftbutton.frame=CGRectMake(0, 0, 23/2, 41/2);
    Leftbutton.tag=300;
    [Leftbutton setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [Leftbutton addTarget:self action:@selector(LeftandRightClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemLeft=[[UIBarButtonItem alloc]initWithCustomView:Leftbutton];
    self.navigationItem.leftBarButtonItem=itemLeft;
    //公司账户
    companyAccount.textAlignment = NSTextAlignmentCenter;
    [companyAccount setTextColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1]];
    [_TitleImage addSubview:companyAccount];
}

-(void)LeftandRightClick:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建UIBarButtonItem
- (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = (CGRect){CGPointZero, {100, 20}};
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.tag = tag;
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button setHidden:YES];
    self.resetBtn = button;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - 界面不同部分生成器
- (void)setupDifferentUI
{
    switch (self.type) {
        case GestureViewControllerTypeSetting:
            [self setupSubViewsSettingVc];
            break;
        case GestureViewControllerTypeLogin:
            [self setupSubViewsLoginVc];
            break;
        default:
            break;
    }
}

#pragma mark - 界面相同部分生成器
- (void)setupSameUI
{
    // 创建导航栏右边按钮
    //self.navigationItem.rightBarButtonItem = [self itemWithTitle:@"重设" target:self action:@selector(didClickBtn:) tag:buttonTagReset];
    
    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14); // 14
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 10);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
    
}

#pragma mark - 设置手势密码界面
- (void)setupSubViewsSettingVc
{
    [self.lockView setType:CircleViewTypeSetting];
    //self.title = @"设置手势密码";
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    infoView.center = CGPointMake(kScreenW/2,CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame)/2 - 10);
    //infoView.center = CGPointMake(kScreenW/2,50);
    self.infoView = infoView;
    [self.view addSubview:infoView];
    
    // 跳过手势密码
    
    //    UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    //        [skipBtn setBackgroundColor:[UIColor redColor]];
    //    skipBtn.tag = buttonTagSkip;
    //    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    //    [skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [skipBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    //    [skipBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    //    [skipBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:skipBtn];
    //
    //
    //    skipBtn.translatesAutoresizingMaskIntoConstraints = NO;
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:skipBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:30]];
    //
    //    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:leftBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:20]];
    //
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:skipBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
}

#pragma mark - 登陆手势密码界面
- (void)setupSubViewsLoginVc
{
    [self.lockView setType:CircleViewTypeLogin];
    // 头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 65, 65);
    imageView.center = CGPointMake(kScreenW/2, kScreenH/10);
    
    NSString *personSex = [[NSUserDefaults standardUserDefaults] objectForKey:JFKSexSave];
    switch ([personSex integerValue]) {
        case 0:
        {
            [imageView setImage:[UIImage imageNamed:@"personalcenter_head_unknown"]];
        }
            break;
        case 1:
        {
            [imageView setImage:[UIImage imageNamed:@"personalcenter_head"]];
        }
            break;
        case 2:
        {
            [imageView setImage:[UIImage imageNamed:@"personalcenter_head_female"]];
        }
            break;
            
        default:
            break;
    }
    
    [self.view addSubview:imageView];
    
    // 手机号
    //    UILabel *account=[[UILabel alloc]init];
    //    account.text=[[NSUserDefaults standardUserDefaults]objectForKey:IPhonenumber];
    //    [account setTextColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:255/255.0f]];
    //    account.font =[UIFont systemFontOfSize:15];
    //    [self.view addSubview:account];
    //    account.translatesAutoresizingMaskIntoConstraints = NO;
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:account attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:13]];
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:account attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // 管理手势密码
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [leftBtn setBackgroundColor:[UIColor redColor]];
    leftBtn.tag = buttonTagManager;
    [leftBtn setTitle:@"忘记手势密码" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [leftBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    
    leftBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:leftBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-60]];
    
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:leftBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:leftBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    
    
    //    [self creatButton:leftBtn frame:CGRectMake(kScreenW/2-kScreenW/4, kScreenH - 60, kScreenW/2, 20) title:@"忘记手势密码" alignment:UIControlContentHorizontalAlignmentLeft tag:buttonTagManager];
    
    // 登录其他账户
    //    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self creatButton:rightBtn frame:CGRectMake(kScreenW/2 - CircleViewEdgeMargin - 20, kScreenH - 60, kScreenW/2, 20) title:@"登录其他账户" alignment:UIControlContentHorizontalAlignmentRight tag:buttonTagForget];
}

#pragma mark - 创建UIButton
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag
{
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - button点击事件
- (void)didClickBtn:(UIButton *)sender
{
    NSLog(@"%ld", (long)sender.tag);
    switch (sender.tag) {
        case buttonTagReset:
        {
            NSLog(@"点击了重设按钮");
            // 1.隐藏按钮
            [self.resetBtn setHidden:YES];
            
            // 2.infoView取消选中
            [self infoViewDeselectedSubviews];
            
            // 3.msgLabel提示文字复位
            [self.msgLabel showNormalMsg:gestureTextBeforeSet];
            
            // 4.清除之前存储的密码
            [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
        }
            break;
        case buttonTagManager:
        {
            NSLog(@"点击了忘记手势密码按钮");
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认重新登录重置手势密码?" preferredStyle: UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                // 删除 JFKUserId、gestureFinalSaveKey、JFKSetGesturePassword
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:JFKUserId];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gestureFinalSaveKey"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:JFKSetGesturePassword];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appdelegate.isforgetPassword = YES;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                        JFInputPhoneNumberViewController *loginController = [[JFInputPhoneNumberViewController alloc] initWithNibName:@"JFInputPhoneNumberViewController" bundle:nil];
                        loginController.GestureLock = YES;
                        JFNavigationController *rootNavigation = [[JFNavigationController alloc] initWithRootViewController:loginController];
                        [[self getCurrentVC] presentViewController:rootNavigation animated:YES completion:nil];
                    }];
                    
                });
                
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
            
        }
            break;
        case buttonTagForget:
        {
            NSLog(@"点击了登录其他账户按钮");
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认切换账号?" preferredStyle: UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
                // 删除原来这个userid
                //[[SYMDataBaseCenter defaultDatabase]deleteRecordByUserid:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN]];
                //                [[NSUserDefaults standardUserDefaults]removeObjectForKey:ISLogIN];
                //                [[NSUserDefaults standardUserDefaults]synchronize];
                // 登录
                //                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ForgetPassword];
                //                [[NSUserDefaults standardUserDefaults]synchronize];
                //                LoginViewController *login=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                //                [self.navigationController pushViewController:login animated:YES];
                //                login.backLogin=^{
                //                    // 登录成功
                //                };
                
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        }
            
            break;
        case buttonTagSkip:
        {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}


#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];
    
    // 看是否存在第一个密码
    if ([gestureOne length]) {
        [self.resetBtn setHidden:NO];
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    NSLog(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];
    
    // infoView展示对应选中的圆
    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    //    NSLog(@"获得第二个手势密码%@",gesture);
    if (equal) {
        NSLog(@"两次手势匹配！可以进行本地化保存了");
        
        // JFKSetGesturePassword
        [[NSUserDefaults standardUserDefaults] setObject:@"开启" forKey:JFKSetGesturePassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
        
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.tbc.selectedIndex = 0;
        JFNavigationController *nav = app.tbc.childViewControllers[1];
        JFNavigationController *navfirst = app.tbc.childViewControllers[0];
        [nav popToRootViewControllerAnimated:NO];
        [navfirst popToRootViewControllerAnimated:NO];
        
        //        [UIApplication sharedApplication].delegate.window.rootViewController = [[JFBaseTabBarViewController alloc] init];
        
        //                if (self.currentViewController) {
        //                    dispatch_async(dispatch_get_main_queue(), ^{
        //                       [self.currentViewController.navigationController popToRootViewControllerAnimated:NO];
        //                    });
        //
        //                }else {
        //
        //                    JFNavigationController *nav = app.tbc.childViewControllers[1];
        //                    JFNavigationController *navfirst = app.tbc.childViewControllers[0];
        //                    [nav popToRootViewControllerAnimated:NO];
        //                    [navfirst popToRootViewControllerAnimated:NO];
        //                }
        
        [self dismissViewControllerAnimated:NO completion:^{
            if (app.isforgetPassword) {
                app.isforgetPassword = NO;
                [[self getCurrentVC] dismissViewControllerAnimated:NO completion:nil];
            }
        }];
        
    } else {
        NSLog(@"两次手势不匹配！");
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        [self.resetBtn setHidden:NO];
    }
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        
        if (equal) {
            NSLog(@"登陆成功!");
            [[NSUserDefaults standardUserDefaults] setObject:@"开启" forKey:JFKSetGesturePassword];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            NSLog(@"密码错误！");
            [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"密码错误"]];
            //            _recordErrorNumber++;
            //            if (_recordErrorNumber>=5) {
            //
            //            }else{
            //
            //                // gestureTextGestureVerifyError
            //                //                [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"密码错误还可以输入%d次",(5-_recordErrorNumber)]];
            //
            //                [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"密码错误"]];
            //
            //            }
            
        }
    } else if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功，跳转到设置手势界面");
            
        } else {
            NSLog(@"原手势密码输入错误！");
            
        }
    }
}

#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView
{
    for (PCCircle *circle in circleView.subviews) {
        
        if (circle.state == CircleStateSelected || circle.state == CircleStateLastOneSelected) {
            
            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setState:CircleStateSelected];
                }
            }
        }
    }
}

#pragma mark - 让infoView对应按钮取消选中
- (void)infoViewDeselectedSubviews
{
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:CircleStateNormal];
    }];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end

//
//  JFBaseViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/24.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"
#import "JFDevice.h"
#import "JFColor.h"
#import "UIColor+Hex.h"
#import "JFMacro.h"

@interface JFBaseViewController ()<UIGestureRecognizerDelegate>

{
    UIImageView *_TitleImage;
    UILabel *companyAccount;
}
@property (nonatomic, strong) AFNetworkReachabilityManager *manager;

@end


@implementation JFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
}



- (void)configNavigation:(NSString *)navigationTitile showRightBtn:(BOOL)show showLeftBtn:(BOOL)showBtn currentController:(UIViewController *) controller {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    //    _TitleImage.image=[UIImage imageNamed:@""];
    controller.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=navigationTitile;
    
    if (show) {
        
        NSString *controllerName = NSStringFromClass([controller class]);
        UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([controllerName isEqualToString:@"JFNotLoginMyAccountViewController"]) {
            rightButton.frame=CGRectMake(0, 0, 15*JFWidthRateScale, 15*JFHeightRateScale);
            [rightButton setBackgroundImage:[UIImage imageNamed:@"personalcenter_notLogin"] forState:UIControlStateNormal];
        }else {
            rightButton.frame=CGRectMake(0, 0, 45/2*JFWidthRateScale, 11/2*JFHeightRateScale);
            [rightButton setBackgroundImage:[UIImage imageNamed:@"personalcenter_staging"] forState:UIControlStateNormal];
        }
        
        rightButton.tag=301;
        [rightButton addTarget:self action:@selector(LeftandRightClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *itemRight=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
        controller.navigationItem.rightBarButtonItem=itemRight;
    }
    
    if (showBtn) {
        //  定义Navigation 的左右按钮
        UIButton *Leftbutton=[UIButton buttonWithType:UIButtonTypeCustom];
        Leftbutton.frame=CGRectMake(0, 0, 23/2*JFWidthRateScale, 41/2*JFHeightRateScale);
        Leftbutton.tag=300;
        [Leftbutton setBackgroundImage:[UIImage imageNamed:@"Login_goback"] forState:UIControlStateNormal];
        [Leftbutton addTarget:self action:@selector(LeftandRightClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *itemLeft=[[UIBarButtonItem alloc]initWithCustomView:Leftbutton];
        controller.navigationItem.leftBarButtonItem=itemLeft;
    }
    //公司账户
    companyAccount.textAlignment = NSTextAlignmentCenter;
    [companyAccount setTextColor:[UIColor colorWithHexString:@"#ffffff"]];
    [_TitleImage addSubview:companyAccount];
}

-(void)LeftandRightClick:(UIButton *)button{
    if (button.tag==300) {
        [self navigationGobackHandleButtonEvent];
    }else if (button.tag==301){
        [self navigationRightHandleButtonEvent];
    }
}

- (void)navigationGobackHandleButtonEvent {
    
}

- (void)navigationRightHandleButtonEvent {
    
}


// 判断网络
- (BOOL)judgeCurrentNetAvailable {
    __block BOOL internetAvailable = NO;
    self.manager = [AFNetworkReachabilityManager manager];
    //    __weak typeof(self) weakSelf = self;
    [self.manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable: {
                //                [weakSelf loadMessage:@"网络不可用"];
                NSLog(@"网络不可用");
                internetAvailable = NO;
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                //                [weakSelf loadMessage:@"Wifi已开启"];
                NSLog(@"Wifi已开启");
                internetAvailable = YES;
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                //                [weakSelf loadMessage:@"你现在使用的流量"];
                NSLog(@"你现在使用的流量");
                internetAvailable = YES;
                break;
            }
                
            case AFNetworkReachabilityStatusUnknown: {
                //                [weakSelf loadMessage:@"你现在使用的未知网络"];
                NSLog(@"你现在使用的未知网络");
                internetAvailable = YES;
                break;
            }
            default:
                break;
        }
    }];
    [self.manager startMonitoring];
    return internetAvailable;
}



@end

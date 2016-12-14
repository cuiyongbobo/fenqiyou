//
//  AppDelegate.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTabBarViewController.h"
#import "JFSubmitOrderViewController.h"
#import "JFNavigationController.h"
#import "GestureViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (JFNavigationController *)rootNavigationCotroller;
+ (JFBaseViewController *)baseViewController;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tbc;
@property (nonatomic, strong) JFNavigationController *ykNavigationCotroller;
@property (nonatomic, strong) JFBaseViewController *ykBaseViewController;
@property (nonatomic, strong) GestureViewController *gestureLockViewController;//手势解锁VC

@property (nonatomic,assign) BOOL isforgetPassword;


@end


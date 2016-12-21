//
//  AppDelegate.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "AppDelegate.h"

#import "JFInitialization.h"
#import "JFString.h"
#import "JFNavigationController.h"
#import "JFBaseViewController.h"
#import <ZMCreditSDK/ALCreditService.h>
#import "ViewController.h"
#import "JFGuideViewController.h"
#import "JFUmengMgr.h"
#import "STIDCard.h"
#import "STAPIAccountInfo.h"
#import "JFBaseLibCommon.h"
#import "JFMacro.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[ALCreditService sharedService] resgisterApp];
    [[JFUmengMgr sharedUmengMgr] configUmengSettings];
    [STIDCard setupTheAPIAccountWithID:kJFACCOUNTAPIID andWithSecret:kJFACCOUNTAPISECRET];
    
    //    [NSThread sleepForTimeInterval:2.0];  //这里延时两秒
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:JFKImplementGuide]) {
        UIViewController *viewController = self.window.rootViewController;
        self.ykNavigationCotroller = (JFNavigationController*)viewController;
        self.ykBaseViewController = (JFBaseViewController *)viewController;
        UITabBarController *tab = [[JFBaseTabBarViewController alloc] init];
        self.window.rootViewController = tab;
        self.tbc = tab;
    }else {
        
        JFGuideViewController *guideController = [[JFGuideViewController alloc] initWithNibName:@"JFGuideViewController" bundle:nil];
        self.window.rootViewController = guideController;
        guideController.guideBlock = ^{
            NSLog(@"回调");
            [[NSUserDefaults standardUserDefaults] setObject:@"guide" forKey:JFKImplementGuide];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIViewController *viewController = self.window.rootViewController;
            self.ykNavigationCotroller = (JFNavigationController*)viewController;
            self.ykBaseViewController = (JFBaseViewController *)viewController;
            UITabBarController *tab = [[JFBaseTabBarViewController alloc] init];
            self.window.rootViewController = tab;
            self.tbc = tab;
        };
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:JFKSetGesturePassword] isEqualToString:@"开启"]) {
        if (self.gestureLockViewController) {
            self.gestureLockViewController = nil;
        }
        [[self getCurrentVC] presentViewController:self.gestureLockViewController animated:YES completion:nil];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[JFUmengMgr sharedUmengMgr] configUmengSettings];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -getter

- (GestureViewController *)gestureLockViewController  {
    if (!_gestureLockViewController) {
        _gestureLockViewController = [[GestureViewController alloc] init];
        _gestureLockViewController.type = GestureViewControllerTypeLogin;
        _gestureLockViewController.currentViewController = [self getCurrentVC];
    }
    return _gestureLockViewController;
}

#pragma mark - Class Method
+ (JFNavigationController *)rootNavigationCotroller{
    return ((AppDelegate*)[UIApplication sharedApplication].delegate).ykNavigationCotroller;
}

+ (JFBaseViewController *)baseViewController{
    return ((AppDelegate*)[UIApplication sharedApplication].delegate).ykBaseViewController;
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

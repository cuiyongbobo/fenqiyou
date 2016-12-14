//
//  JFNavigationController.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/29.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFNavigationController.h"

#import "JFDevice.h"
#import "JFColor.h"
#import "UIColor+Hex.h"


@interface JFNavigationController ()
//<UIGestureRecognizerDelegate>
@end

@implementation JFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationBar setTranslucent:NO];
    if ([UIDevice currentDevice].systemVersion.floatValue == 7) {
        // JFKNavigationBarBackgroundColor
        [self.navigationBar setTintColor:[UIColor colorWithHexString:JFKNavigationBarBackgroundColor]];
    }else{
        [self.navigationBar setBarTintColor:[UIColor colorWithHexString:JFKNavigationBarBackgroundColor]];
    }
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
//    self.interactivePopGestureRecognizer.delegate =  self;
    
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if (self.viewControllers.count <= 1 ) {
//        return NO;
//    }
//    return YES;
//}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed=YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end

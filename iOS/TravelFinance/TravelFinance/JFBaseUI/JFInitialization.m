//
//  JFInitialization.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFInitialization.h"

#import "JFNavigationController.h"
#import "JFStagingTourViewController.h"
#import "JFMyAccountViewController.h"

@implementation JFInitialization

+(JFInitialization *)sharedInitial
{
    static JFInitialization *initialliza=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        initialliza=[[JFInitialization alloc]init];
    });
    return initialliza;
}

- (JFTabBarController *)loadHomePage
{
    NSArray *controllersArr = @[@"JFStagingTour",@"JFMyAccount"];
    NSMutableArray *navArr = [[NSMutableArray alloc]init];
    [controllersArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *vcStr = [NSString stringWithFormat:@"%@ViewController",obj];
        Class controllerClass = NSClassFromString(vcStr);
        UIViewController *controller = [[controllerClass alloc]init];
        JFNavigationController *nav = [[JFNavigationController alloc]initWithRootViewController:controller];
        [navArr addObject:nav];
    }];
    JFTabBarController * tbc = [[JFTabBarController alloc] init];
    tbc.viewControllers = navArr;
    return tbc;
}


@end

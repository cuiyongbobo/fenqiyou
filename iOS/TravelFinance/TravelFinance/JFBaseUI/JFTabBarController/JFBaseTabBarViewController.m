//
//  JFBaseTabBarViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/30.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseTabBarViewController.h"

#import "JFNavigationController.h"

@interface JFBaseTabBarViewController ()

@end

@implementation JFBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *controllersArr = @[@"JFStagingTour",@"JFMyAccount"];
    NSArray *tabBarItemTitileArray = @[@"分期游",@"我的"];
    NSArray *tabBarItemImageNormalArray = @[@"main_bottombar_home_normal",@"main_bottombar_account_normal"];
    NSArray *tabBarItemImageSelectArray = @[@"main_bottombar_home_selected",@"main_bottombar_account_selected"];
    NSMutableArray *navArr = [[NSMutableArray alloc]init];
    [controllersArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *vcStr = [NSString stringWithFormat:@"%@ViewController",obj];
        Class controllerClass = NSClassFromString(vcStr);
        UIViewController *controller = [[controllerClass alloc]init];
        JFNavigationController *nav = [[JFNavigationController alloc]initWithRootViewController:controller];
        nav.tabBarItem = [self tabBarItemWithName :tabBarItemTitileArray[idx] imageName :tabBarItemImageNormalArray[idx] selectedImageName :tabBarItemImageSelectArray[idx]];
        [navArr addObject:nav];
    }];
    self.viewControllers = navArr;
}

#pragma mark - Private Method

- (UITabBarItem *)tabBarItemWithName :(NSString *)name imageName :(NSString *)imageName selectedImageName :(NSString *)selectedImageName {
    UIImage *imageNormal   = [[UIImage imageNamed :imageName] imageWithRenderingMode :UIImageRenderingModeAlwaysOriginal];
    UIImage *imageSelected = [[UIImage imageNamed :selectedImageName] imageWithRenderingMode :UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle :name image :imageNormal selectedImage :imageSelected];
    
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateNormal];
    
    [item setTitleTextAttributes :@{NSFontAttributeName :[UIFont boldSystemFontOfSize :11]} forState :UIControlStateSelected];
    return item;
}


@end

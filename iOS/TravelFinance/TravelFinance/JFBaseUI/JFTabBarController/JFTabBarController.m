//
//  JFTabBarController.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFTabBarController.h"

#import "JFTabBarView.h"
#import "JFTabBarItemView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "JFDevice.h"

@interface JFTabBarController ()

{
    JFTabBarView * _tabber;
    BOOL isReloadOrg;
}

@end

@implementation JFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdateNumberWith:) name:@"changUnReadCount" object:nil];
    // Do any additional setup after loading the view.
    [self addCustomTabBar];
}

- (void)addCustomTabBar{
    if(_tabber == nil){
        _tabber = [[JFTabBarView alloc] initWithFrame:CGRectMake(0, 0, [JFDevice screenWidth], 49) andNum:0];
        [self.tabBar addSubview:_tabber];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSArray * items = [tabBar items];
    for (int i = 0; i < items.count; i++) {
        if(item == items[i]){
            [_tabber.viewArr[i] selected];
        }else{
            [_tabber.viewArr[i] noSelect];
        }
    }
}

- (void)UpdateNumberWith:(NSNotification *)noti{
    NSNumber *count=noti.object;
    [_tabber.viewArr[0] UpdateNumber:count.intValue];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

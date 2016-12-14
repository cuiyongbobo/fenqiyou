//
//  JFGesturepasswordViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/15.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFGesturepasswordViewController.h"

@interface JFGesturepasswordViewController ()

@end

@implementation JFGesturepasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"手势密码" showRightBtn:NO showLeftBtn:YES currentController:self];
    
    
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

//
//  JFOpeningStageSuccessfulViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/16.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFOpeningStageSuccessfulViewController.h"

@interface JFOpeningStageSuccessfulViewController ()

@end

@implementation JFOpeningStageSuccessfulViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"开通成功" showRightBtn:NO showLeftBtn:NO currentController:self];
    self.auotaLabel.text = self.auotaValues;
}

#pragma mark navigation back
- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
}


#pragma mark Even

- (IBAction)handleToStage:(id)sender {
    
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)handleCollarIntegral:(id)sender {
    
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

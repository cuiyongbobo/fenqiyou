//
//  JFBaseViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/24.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface JFBaseViewController : UIViewController

//- (BOOL)judgeCurrentNetAvailable;

- (void)configNavigation:(NSString *)navigationTitile showRightBtn:(BOOL)show showLeftBtn:(BOOL)showBtn currentController:(UIViewController *) controller;

@end

//
//  JFNotLoginMyAccountViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"

#import "JFNavigationController.h"

@interface JFNotLoginMyAccountViewController : JFBaseViewController


@property (nonatomic, strong) JFNavigationController *previousController;
@property (weak, nonatomic) IBOutlet UITableView *notLoginMyAccountTableView;



@end

//
//  JFMyAccountViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/24.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"

#import "YKShareViewController.h"

@interface JFMyAccountViewController : JFBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *accountTableView;
@property (weak, nonatomic) IBOutlet UIView *listView;
@property (nonatomic, strong) YKShareViewController *shareVC;

- (IBAction)handleSetup:(id)sender;
- (IBAction)handleHelpCenter:(id)sender;


@end

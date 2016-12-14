//
//  JFOpeningStageCreditAuthorizationViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/16.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"


@interface JFOpeningStageCreditAuthorizationViewController : JFBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *creditText;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (nonatomic, copy) void(^CreditAuthorizationResult)(BOOL);



- (IBAction)HandleConfirm:(id)sender;

@end

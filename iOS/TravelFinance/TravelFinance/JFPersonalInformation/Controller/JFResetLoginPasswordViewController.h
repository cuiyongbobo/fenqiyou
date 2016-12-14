//
//  JFResetLoginPasswordViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/15.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"

@interface JFResetLoginPasswordViewController : JFBaseViewController



@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendCodeWidth;



- (IBAction)handleSendCode:(id)sender;
- (IBAction)handleconfirm:(id)sender;


@end

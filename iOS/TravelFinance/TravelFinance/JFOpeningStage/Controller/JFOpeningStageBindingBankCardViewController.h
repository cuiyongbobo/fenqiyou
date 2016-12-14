//
//  JFOpeningStageBindingBankCardViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/16.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"

@interface JFOpeningStageBindingBankCardViewController : JFBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *bindingConfirm;
@property (weak, nonatomic) IBOutlet UITextField *bindingBankNoText;
@property (weak, nonatomic) IBOutlet UITextField *bindingPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *bindingCodeText;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;



- (IBAction)handlesupportBankList:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *handlesupportBankList;

- (IBAction)handleBindingConfirm:(id)sender;
- (IBAction)handleSendCodeButtonEvent:(id)sender;


@end

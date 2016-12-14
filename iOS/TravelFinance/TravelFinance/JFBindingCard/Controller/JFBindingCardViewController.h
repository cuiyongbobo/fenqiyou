//
//  JFBindingCardViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/9.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"

@interface JFBindingCardViewController : JFBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *bindingDetermineButon;
@property (weak, nonatomic) IBOutlet UITextField *bindingBankCardText;
@property (weak, nonatomic) IBOutlet UITextField *bindingPhoneText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneTextWidth;
@property (weak, nonatomic) IBOutlet UILabel *reservePhoneLabel;



- (IBAction)handleDetermine:(id)sender;
- (IBAction)handleBankInformation:(id)sender;



@end

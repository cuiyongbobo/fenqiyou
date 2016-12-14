//
//  JFsubmitOrderguaranteeAgreementTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/7.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"

@interface JFsubmitOrderguaranteeAgreementTableViewCell : JFBaseTableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *borrowingButton;
@property (weak, nonatomic) IBOutlet UIButton *borrowingButtonPhone4;
@property (weak, nonatomic) IBOutlet UIButton *borrowingButtonphones4;
@property (nonatomic, strong) NSString *orderType;

//- (void)bindeDataWithViewModel:(NSString *) viewModel;

- (IBAction)handleTouristContractPhone:(id)sender;

- (IBAction)handleCheck:(id)sender;
- (IBAction)handleTouristContract:(id)sender;

@end

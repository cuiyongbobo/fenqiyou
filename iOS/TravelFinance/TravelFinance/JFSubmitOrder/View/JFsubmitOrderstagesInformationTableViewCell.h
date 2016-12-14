//
//  JFsubmitOrderstagesInformationTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/7.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"

@interface JFsubmitOrderstagesInformationTableViewCell : JFBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *submitPaymentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *submitLinebottomImageView;
@property (weak, nonatomic) IBOutlet UILabel *stagesNameLabel;

- (void)bindeDataWithViewModel:(NSDictionary *) viewModel;

@end

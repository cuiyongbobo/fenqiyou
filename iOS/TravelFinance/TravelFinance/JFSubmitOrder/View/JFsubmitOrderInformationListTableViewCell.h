//
//  JFsubmitOrderInformationListTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/7.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"

@interface JFsubmitOrderInformationListTableViewCell : JFBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *submitOrderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *submitOrderlineAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *submitOrderlineTravelTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *submitOrderlineTravelNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *submitOrderSingleDifferenceLabel;
@property (weak, nonatomic) IBOutlet UIView *submitOrderInformatonView;

- (void)bindeDataWithViewModel:(NSDictionary *) viewModel;

@end

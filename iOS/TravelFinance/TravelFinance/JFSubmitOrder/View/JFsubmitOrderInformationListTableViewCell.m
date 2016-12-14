//
//  JFsubmitOrderInformationListTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/7.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFsubmitOrderInformationListTableViewCell.h"

@implementation JFsubmitOrderInformationListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.submitOrderInformatonView.layer.cornerRadius = 4;
    self.submitOrderInformatonView.layer.masksToBounds = YES;
}


- (void)bindeDataWithViewModel:(NSDictionary *) viewModel {
     self.submitOrderTitleLabel.text = viewModel[@"orderTitle"];
     self.submitOrderlineAmountLabel.text = [NSString stringWithFormat:@"￥%@",viewModel[@"lineAmount"]];
     self.submitOrderlineTravelTimeLabel.text = viewModel[@"travelTime"];
     self.submitOrderlineTravelNumberLabel.text = viewModel[@"travelNumber"];
     self.submitOrderSingleDifferenceLabel.text = [NSString stringWithFormat:@"￥%@",viewModel[@"singleDifference"]];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

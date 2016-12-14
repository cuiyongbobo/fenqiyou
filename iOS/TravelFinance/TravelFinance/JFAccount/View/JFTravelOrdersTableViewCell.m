//
//  JFTravelOrdersTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFTravelOrdersTableViewCell.h"

@implementation JFTravelOrdersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)bindeDataWithViewModel:(JFTravelOrdersItem *) viewModel {
    
    self.travelOrderTitleLabel.text = viewModel.goodsName;
    self.goodsAmountLabel.text = viewModel.goodsAmount;
    self.travelTime.text = viewModel.ctDate;
    self.supplyMerchantLabel.text = viewModel.goodsDistributor;
}


- (void)bindeDataWithInvestmentWithViewModel:(JFInvestmentOrderItem *) viewModel {
    
    self.travelOrderTitleLabel.text = viewModel.goodsProductName;
    self.goodsAmountLabel.text = viewModel.redemptionTime;
    self.travelTime.text = viewModel.expctedEarning;
    self.supplyMerchantLabel.text = viewModel.amount;
    self.travelTimeTitleLabel.text = @"预期收益";
    self.supplyMerchantTitleLabel.text = @"持有金额";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

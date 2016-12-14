//
//  JFTravelOrdersTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"

#import "JFTravelOrdersItem.h"
#import "JFInvestmentOrderItem.h"

@interface JFTravelOrdersTableViewCell : JFBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *travelOrderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *travelTime;
@property (weak, nonatomic) IBOutlet UILabel *supplyMerchantLabel;
@property (weak, nonatomic) IBOutlet UILabel *travelTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplyMerchantTitleLabel;




- (void)bindeDataWithViewModel:(JFTravelOrdersItem *) viewModel;

- (void)bindeDataWithInvestmentWithViewModel:(JFInvestmentOrderItem *) viewModel;

@end

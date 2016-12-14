//
//  JFAccountAvailableCreditTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/13.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFAccountAvailableCreditTableViewCell.h"

@implementation JFAccountAvailableCreditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.openView.userInteractionEnabled = YES;
    UITapGestureRecognizer *openGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openClick:)];
    [self.openView addGestureRecognizer:openGesture];
}

- (void)openClick:(UIGestureRecognizer *) tap {
    
    if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
        [self.delegate clickCell:self tag:JFTableCellClickTypeOpenFinancial userinfo:self.indexPath];
    }
}

- (void)bindeDataWithViewModel:(NSIndexPath *)indexPath List:(JFPersonalCenterItem  *)viewModel {
    self.indexPath = indexPath;
//    self.availableCreditLabel.text = viewModel.availableCreditAmount;
//    self.totalAmountLabel.text = viewModel.totalAssets;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

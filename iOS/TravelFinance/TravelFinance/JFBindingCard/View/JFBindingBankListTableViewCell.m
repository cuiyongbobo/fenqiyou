//
//  JFBindingBankListTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/9.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBindingBankListTableViewCell.h"

@implementation JFBindingBankListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)bindeDataWithViewModel:(JFBankListModel *) viewModel {
    // 单笔限额5000元  单日500000元
    self.bindingBankNameLabel.text = viewModel.bankName;
    self.bindingBankLogoImageVIew.image = [UIImage imageNamed:viewModel.bankCode];
    self.bindingBankInformationLabel.text = [NSString stringWithFormat:@"单笔限额%@元  单日%@元",viewModel.singleQuota,viewModel.singleDayLimit];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

//
//  JFCouponTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/9.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFCouponTableViewCell.h"

@implementation JFCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.couponView.layer.cornerRadius = 4;
    self.couponView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

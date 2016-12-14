//
//  JFstagingTourplayFreeTtemView.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/3.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFstagingTourplayFreeTtemView.h"

#import "JFMacro.h"

@implementation JFstagingTourplayFreeTtemView


- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.freeTtemLogoImageVIew.layer.cornerRadius = 4;
    self.freeTtemLogoImageVIew.layer.masksToBounds = YES;
    
    self.InvestmentWidth.constant = 100*JFWidthRateScale;
    if (DEVICE_5 || DEVICE_4S) {
        self.freeTtemInvestmentAmountLabel.font = [UIFont systemFontOfSize:8];
        self.freeTtemClosedPeriodLabel.font = [UIFont systemFontOfSize:8];
        self.centerLine.font = [UIFont systemFontOfSize:8];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //        self.userInteractionEnabled = YES;
    }
    return self;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

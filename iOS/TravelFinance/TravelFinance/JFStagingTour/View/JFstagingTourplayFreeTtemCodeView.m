//
//  JFstagingTourplayFreeTtemCodeView.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/4.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFstagingTourplayFreeTtemCodeView.h"

#import "Masonry.h"

@implementation JFstagingTourplayFreeTtemCodeView

-(instancetype)init
{
    if (self = [super init]) {
        
        [self.freeTtemLogoImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(0);
            make.left.equalTo(self).with.offset(0);
            make.right.equalTo(self).with.offset(0);
            make.height.mas_equalTo(125);
        }];
        
        
        [self.freeTtemCityImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.freeTtemLogoImageVIew).with.offset(0);
            make.left.equalTo(self.freeTtemLogoImageVIew).with.offset(0);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(45);
        }];
        self.freeTtemCityImageVIew.image = [UIImage imageNamed:@"stagingtour_citybackground"];
        
        [self.freeTtemFromCitylabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.freeTtemCityImageVIew).with.offset(0);
            make.left.equalTo(self.freeTtemCityImageVIew).with.offset(0);
            make.height.mas_equalTo(11);
            make.width.mas_equalTo(37);
        }];
        self.freeTtemFromCitylabel.text = @"北京出发";
        
        
        [self.freeTtemTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.freeTtemLogoImageVIew).with.offset(0);
            make.centerX.equalTo(self);
        }];
        self.freeTtemTitlelabel.text = @"韩国韩流畅游系列精品酒店高端精品";
        
        
        [self.freeTtemPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.freeTtemTitlelabel).with.offset(8);
            make.centerX.equalTo(self);
        }];
        self.freeTtemPriceLabel.text = @"￥5000";
        
        
        [self.freeTtemtagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.freeTtemPriceLabel).with.offset(8);
            make.centerX.equalTo(self);
        }];
        self.freeTtemtagLabel.text = @"/";
        
        
        
        [self.freeTtemInvestmentAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.freeTtemtagLabel).with.offset(0);
            make.centerX.equalTo(self.freeTtemtagLabel);
        }];
        self.freeTtemInvestmentAmountLabel.text = @"投￥5419";
        
        
        [self.freeTtemClosedPeriodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.freeTtemtagLabel).with.offset(0);
            make.centerX.equalTo(self.freeTtemtagLabel);
        }];
        self.freeTtemClosedPeriodLabel.text = @"封闭期365天";
        
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

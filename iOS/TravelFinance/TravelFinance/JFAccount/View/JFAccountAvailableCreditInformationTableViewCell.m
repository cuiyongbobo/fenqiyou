//
//  JFAccountAvailableCreditInformationTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/13.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFAccountAvailableCreditInformationTableViewCell.h"

@implementation JFAccountAvailableCreditInformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapleftGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftClick:)];
    [self.leftLogoBDImageView addGestureRecognizer:tapleftGesture];
    
    UITapGestureRecognizer *taprightGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightClick:)];
    [self.rightLogoBDImageView addGestureRecognizer:taprightGesture];
    
}


- (void)leftClick:(UIGestureRecognizer *) tap {
    
    if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
        [self.delegate clickCell:self tag:JFTableCellClickTypeleftLogo userinfo:self.indexPath];
    }
}

- (void)rightClick:(UIGestureRecognizer *) tap {
    
    if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
        [self.delegate clickCell:self tag:JFTableCellClickTyperightLogo userinfo:self.indexPath];
    }
    
}

- (void)bindeDataWithViewModel:(NSIndexPath *)indexPath List:(NSMutableArray *)viewModelArray {
    
    self.indexPath = indexPath;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

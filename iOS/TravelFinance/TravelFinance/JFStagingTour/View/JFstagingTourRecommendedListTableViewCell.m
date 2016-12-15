//
//  JFstagingTourRecommendedListTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/29.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFstagingTourRecommendedListTableViewCell.h"

#import "JFStagingTourfqGoodsItem.h"
#import "UIImageView+WebCache.h"

@implementation JFstagingTourRecommendedListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.bytagesTagSecondImageView setHidden:YES];
    [self.bytagesTagSecondLabel setHidden:YES];
    [self.stagingtourOneTagImageView setHidden:YES];
    [self.bytagesIsFreeLabel setHidden:YES];
    self.bystagesImageLogoImageView.layer.cornerRadius = 4;
    self.bystagesImageLogoImageView.layer.masksToBounds = YES;
    
    
}


- (void)bindeDataWithViewModel:(JFStagingTourfqGoodsItem *) viewModel {
    
    [self.bystagesImageLogoImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.imageLogo] placeholderImage:[UIImage imageNamed:@"stagingtour_stagesselecteddefault"]];
    self.bystagesPushNameLabel.text = viewModel.pushName;
    self.bystagesLevelNameLabel.text = viewModel.levelName;
    self.bystagesDefFqAmountabel.text = [NSString stringWithFormat:@"%@",viewModel.defFqAmount];
    self.fromCityLabel.text = [NSString stringWithFormat:@"%@出发",viewModel.fromcity];
    [viewModel.fqGoodslistTagListItem enumerateObjectsUsingBlock:^(JFStagingTourfqGoodslistTagItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        if (idx == 0) {
            self.bytagesIsFreeLabel.text = obj.tagName;
            [self.stagingtourOneTagImageView setHidden:NO];
            [self.bytagesIsFreeLabel setHidden:NO];
        }else if (idx == 1) {
            
            self.bytagesTagSecondLabel.text = obj.tagName;
            [self.bytagesTagSecondImageView setHidden:NO];
            [self.bytagesTagSecondLabel setHidden:NO];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

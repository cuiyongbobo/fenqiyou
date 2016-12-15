//
//  JFPublicLineListTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/1.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFPublicLineListTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "JFMacro.h"

@implementation JFPublicLineListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.lineListTagThirdLabel setHidden:YES];
    [self.lineListTagSecondLabel setHidden:YES];
    [self.tagThirdImageView setHidden:YES];
    [self.tagSecondImageView setHidden:YES];
    self.lineImageViewHeight.constant = 150*JFHeightRateScale;
}

- (void)bindeDataWithViewModel:(JFStagingTourfqGoodsItem *) viewModel {
    
    [self.bystagesImageLogoImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.imageLogo] placeholderImage:[UIImage imageNamed:@"stagingtour_lineListnormal"]];
    self.lineListTitleLabel.text = viewModel.pushName;
    self.lineListSubtitleLabel.text = viewModel.levelName;
    self.goCityLabel.text = [NSString stringWithFormat:@"%@出发",viewModel.fromcity];
    
    if ([self.lineTag isEqualToString:@"FQ"]) {
        self.lineListInvestmentLabel.text = [NSString stringWithFormat:@"%@",viewModel.defFqAmount];
    }else if ([self.lineTag isEqualToString:@"BW"]) {
        
        self.lineListInvestmentLabel.text = [NSString stringWithFormat:@"%@",viewModel.defAmount];
    }else {
        self.lineListInvestmentLabel.text = [NSString stringWithFormat:@"%@",viewModel.defFqAmount];
    }
    
    [viewModel.fqGoodslistTagListItem enumerateObjectsUsingBlock:^(JFStagingTourfqGoodslistTagItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            self.lineListTagThirdLabel.text = obj.tagName;
            [self.lineListTagThirdLabel setHidden:NO];
            [self.tagThirdImageView setHidden:NO];
        }else if (idx == 1) {
            self.lineListTagSecondLabel.text = obj.tagName;
            [self.lineListTagSecondLabel setHidden:NO];
            [self.tagSecondImageView setHidden:NO];
        }
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

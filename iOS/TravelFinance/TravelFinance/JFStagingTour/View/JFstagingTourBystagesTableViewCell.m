//
//  JFstagingTourBystagesTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/29.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFstagingTourBystagesTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "JFStagingTourfqGoodsItem.h"

@interface JFstagingTourBystagesTableViewCell ()

@property (nonatomic, strong) JFStagingTourfqGoodsItem *fqGoodsItem;
@end
@implementation JFstagingTourBystagesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap:)];
    [self.bystagesListView addGestureRecognizer:tapViewGesture];
    
    UITapGestureRecognizer *tapDetailsViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handDetailsTap:)];
    [self.bystagesDetailsView addGestureRecognizer:tapDetailsViewGesture];
    
    [self.bytagesTagSecondLabel setHidden:YES];
    [self.tagSecondImageView setHidden:YES];
    [self.bytagesIsFreeLabel setHidden:YES];
    [self.bytagesTagOneImageView setHidden:YES];
    self.bystagesImageLogoImageView.layer.cornerRadius = 4;
    self.bystagesImageLogoImageView.layer.masksToBounds = YES;
}

- (void)bindeDataWithViewModel:(JFStagingTourfqGoodsItem *) viewModel {
    
    self.fqGoodsItem = viewModel;
    
    [self.bystagesImageLogoImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.imageLogo] placeholderImage:[UIImage imageNamed:@"stagingtour_stagesheaddefault"]];
    self.bystagesPushNameLabel.text = viewModel.pushName;
    self.bystagesLevelNameLabel.text = viewModel.levelName;
    self.bytagesIsCityNameLabel.text = [NSString stringWithFormat:@"%@出发",viewModel.fromcity];
    self.bystagesDefFqAmountabel.text = [NSString stringWithFormat:@"￥%@",viewModel.defFqAmount];
    [viewModel.fqGoodslistTagListItem enumerateObjectsUsingBlock:^(JFStagingTourfqGoodslistTagItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) {
            self.bytagesIsFreeLabel.text = obj.tagName;
            [self.bytagesTagOneImageView setHidden:NO];
            [self.bytagesIsFreeLabel setHidden:NO];
        }else if (idx == 1) {
            self.bytagesTagSecondLabel.text = obj.tagName;
            [self.tagSecondImageView setHidden:NO];
            [self.bytagesTagSecondLabel setHidden:NO];
        }
    }];
}

- (void) handTap:(UITapGestureRecognizer*) gesture {
    
    if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
        
        // self.fqGoodsItem.goodsId
        [self.delegate clickCell:self tag:JFTableCellClickTypefqGoods userinfo:@"FQ"];
    }
}

- (void) handDetailsTap:(UITapGestureRecognizer*) gesture {
    
    if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
        
//        [self.delegate clickCell:self tag:JFTableCellClickTypefqGoodsDetails userinfo:self.fqGoodsItem.goodsUrl];
        
         [self.delegate clickCell:self tag:JFTableCellClickTypefqGoodsDetails userinfo:self.fqGoodsItem];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    
}

@end

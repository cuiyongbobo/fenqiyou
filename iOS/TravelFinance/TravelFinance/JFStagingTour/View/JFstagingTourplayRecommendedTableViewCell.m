//
//  JFstagingTourplayRecommendedTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/29.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFstagingTourplayRecommendedTableViewCell.h"

@implementation JFstagingTourplayRecommendedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapRecommendGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hundleRecommend:)];
    [self.recommendedSelectedView addGestureRecognizer:tapRecommendGesture];
}

- (void)bindeDataWithViewModel:(NSMutableArray *) viewModel {
    
    
}

- (void)hundleRecommend:(UITapGestureRecognizer *)gesture {
    
    if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
        [self.delegate clickCell:self tag:JFTableCellClickTypeSelectRecommend userinfo:@"JX"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

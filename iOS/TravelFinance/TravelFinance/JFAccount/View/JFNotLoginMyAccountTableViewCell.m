//
//  JFNotLoginMyAccountTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFNotLoginMyAccountTableViewCell.h"

@implementation JFNotLoginMyAccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark handle Even

- (IBAction)handleLogin:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
        [self.delegate clickCell:self tag:JFTableCellClickTypeLogin userinfo:@""];
    }
}

- (void)bindeDataWithViewModel:(id *) viewModel viewModelList:(NSMutableArray *)viewModelArray {
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

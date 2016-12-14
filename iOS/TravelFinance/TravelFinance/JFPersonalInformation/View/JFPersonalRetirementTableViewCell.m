//
//  JFPersonalRetirementTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/15.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFPersonalRetirementTableViewCell.h"

@implementation JFPersonalRetirementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handleLoginout:(id)sender {
        if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
            [self.delegate clickCell:self tag:JFTableCellClickTypeLoginOut userinfo:@""];
        }
}
@end

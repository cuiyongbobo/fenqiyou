//
//  JFsubmitOrderFinishTableViewCellTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/8.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFsubmitOrderFinishTableViewCellTableViewCell.h"

@implementation JFsubmitOrderFinishTableViewCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.submitFinishButton.layer.cornerRadius = 4;
    self.submitFinishButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handleFinish:(id)sender {
     if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
     [self.delegate clickCell:self tag:JFTableCellClickTypesubmitOrderFinish userinfo:nil];
     }
}
@end

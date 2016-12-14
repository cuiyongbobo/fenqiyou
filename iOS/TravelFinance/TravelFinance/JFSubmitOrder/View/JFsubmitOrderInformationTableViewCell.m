//
//  JFsubmitOrderInformationTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/8.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFsubmitOrderInformationTableViewCell.h"


@interface JFsubmitOrderInformationTableViewCell ()

@end
@implementation JFsubmitOrderInformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//#pragma mark - textfieldDelegate
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    
//    UIView *view = textField.superview;
//    while (![view isKindOfClass:[UITableViewCell class]]) {
//        view = [view superview];
//    }
//    
//    UITableViewCell *cell = (UITableViewCell*)view;
//    
//    CGRect rect = [cell convertRect:cell.frame toView:self.view];
//    
//    
//    //    if (rect.origin.y / 2 + rect.size.height>=SCREEN_HEIGHT-216) {
//    //
//    //        _tabelView.contentInset = UIEdgeInsetsMake(0, 0, 216, 0);
//    //
//    //        [_tabelView scrollToRowAtIndexPath:[_tabelView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    //
//    //    }
//    
//    return YES;
//    
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

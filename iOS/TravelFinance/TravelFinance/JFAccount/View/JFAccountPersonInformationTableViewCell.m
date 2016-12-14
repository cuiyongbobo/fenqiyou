//
//  JFAccountPersonInformationTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/13.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFAccountPersonInformationTableViewCell.h"

@implementation JFAccountPersonInformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tripRecordGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripRecordClick:)];
    [self.tripRecordView addGestureRecognizer:tripRecordGesture];
    
    UITapGestureRecognizer *myCardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myCardClick:)];
    [self.myCardView addGestureRecognizer:myCardGesture];
    
    UITapGestureRecognizer *integralMallGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(integralMallClick:)];
    [self.integralMallView addGestureRecognizer:integralMallGesture];
    
}

- (void)tripRecordClick:(UIGestureRecognizer *) tap {
    
    // 出行记录
    if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
        [self.delegate clickCell:self tag:JFTableCellClickTypeTravelOrder userinfo:@""];
    }
}

//#pragma mark--UIGestureRecognizerDelegate
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if([touch.view isKindOfClass:[UIButton class]])
//    {
//        return NO;
//    }
//    return YES;
//}

- (void)myCardClick:(UIGestureRecognizer *) tap {
        if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
            [self.delegate clickCell:self tag:JFTableCellClickTypeCardVolume userinfo:@""];
        }
}

- (void)integralMallClick:(UIGestureRecognizer *) tap {
    
    //    if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
    //        [self.delegate clickCell:self tag:JFTableCellClickTypeleftLogo userinfo:self.indexPath];
    //    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)bindeDataWithViewModel:(JFPersonalCenterItem *) viewModel viewModelList:(NSMutableArray *)viewModelArray {
    
    self.nickNameLabel.text = viewModel.nickName;
    self.isRealLabel.text = viewModel.isReal;
}

#pragma mark handle Even

- (IBAction)handleMyInformation:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
        [self.delegate clickCell:self tag:JFTableCellClickTypeMyHeader userinfo:@""];
    }
}

@end

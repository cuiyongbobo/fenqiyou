//
//  JFAccountAvailableCreditInformationTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/13.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"

@interface JFAccountAvailableCreditInformationTableViewCell : JFBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *overdueRepaymentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overdueRepaymentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *overdueRepaymentImageView;
@property (weak, nonatomic) IBOutlet UILabel *monthlyRepaymentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthlyRepaymentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *monthlyRepaymentImageView;

@property (weak, nonatomic) IBOutlet UIImageView *leftLogoBDImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightLogoBDImageView;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)bindeDataWithViewModel:(NSIndexPath *)indexPath List:(NSMutableArray *)viewModelArray;

@end

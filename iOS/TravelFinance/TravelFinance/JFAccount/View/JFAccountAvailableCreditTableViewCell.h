//
//  JFAccountAvailableCreditTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/13.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"
#import "JFPersonalCenterItem.h"

@interface JFAccountAvailableCreditTableViewCell : JFBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *availableCreditTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableCreditLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UIView *openView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UILabel *productTypeLabel;



- (void)bindeDataWithViewModel:(NSIndexPath *)indexPath List:(JFPersonalCenterItem  *)viewModel;

@end

//
//  JFstagingTourBystagesTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/29.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"
#import "JFStagingTourfqGoodsItem.h"

@interface JFstagingTourBystagesTableViewCell : JFBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *bystagesListView;
@property (weak, nonatomic) IBOutlet UIView *bystagesDetailsView;
@property (weak, nonatomic) IBOutlet UIImageView *bystagesImageLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *bystagesPushNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bystagesLevelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bystagesDefFqAmountabel;
@property (weak, nonatomic) IBOutlet UILabel *bytagesIsFreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bytagesIsCityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bytagesTagSecondLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bytagesTagOneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tagSecondImageView;



- (void)bindeDataWithViewModel:(JFStagingTourfqGoodsItem *) viewModel;

@end

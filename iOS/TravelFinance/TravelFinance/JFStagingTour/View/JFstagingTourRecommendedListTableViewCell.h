//
//  JFstagingTourRecommendedListTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/29.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"
#import "JFStagingTourfqGoodsItem.h"

@interface JFstagingTourRecommendedListTableViewCell : JFBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *bystagesListView;
@property (weak, nonatomic) IBOutlet UIView *bystagesDetailsView;
@property (weak, nonatomic) IBOutlet UIImageView *bystagesImageLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *bystagesPushNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bystagesLevelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bystagesDefFqAmountabel;
@property (weak, nonatomic) IBOutlet UILabel *bytagesIsFreeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stagingtourOneTagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bytagesFromCityImageView;
@property (weak, nonatomic) IBOutlet UILabel *fromCityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bytagesTagSecondImageView;
@property (weak, nonatomic) IBOutlet UILabel *bytagesTagSecondLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bytagesBottomLineImageView;




- (void)bindeDataWithViewModel:(JFStagingTourfqGoodsItem *) viewModel;

@end

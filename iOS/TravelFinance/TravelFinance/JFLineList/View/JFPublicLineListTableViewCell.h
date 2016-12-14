//
//  JFPublicLineListTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/1.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"
#import "JFStagingTourfqGoodsItem.h"

@interface JFPublicLineListTableViewCell : JFBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *goCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineListTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineListSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineListInvestmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineListTagSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineListTagThirdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bystagesImageLogoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tagSecondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tagThirdImageView;
@property (nonatomic, strong) NSString *lineTag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineImageViewHeight;




- (void)bindeDataWithViewModel:(JFStagingTourfqGoodsItem *) viewModel;

@end

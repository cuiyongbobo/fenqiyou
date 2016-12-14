//
//  JFstagingTourSpecialTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/29.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"
#import "JFStagingTourlistSubjectItem.h"

@interface JFstagingTourSpecialTableViewCell : JFBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIView *specialLeftView;
@property (weak, nonatomic) IBOutlet UIView *specialRightTopView;
@property (weak, nonatomic) IBOutlet UIView *specialRightBottomView;
@property (weak, nonatomic) IBOutlet UILabel *specialTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *specialOneLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *specialSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialSecondTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialSecondSubtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *specialSecondLogoImageView;

@property (weak, nonatomic) IBOutlet UILabel *specialThirdTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialThirdSubtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stagingtour_specialThirdLogo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstSubjectwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondSubjectwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdSubjectwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondSubjectHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdSubjectHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstSubjectHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstWidth;




- (void)bindeDataWithViewModel:(JFStagingTourlistSubjectItem *) viewModel viewModelList:(NSMutableArray *)viewModelArray;


@end

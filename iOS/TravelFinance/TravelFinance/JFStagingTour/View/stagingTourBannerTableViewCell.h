//
//  stagingTourBannerTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/29.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"
#import "JFStagingTourBannerItem.h"

@interface stagingTourBannerTableViewCell : JFBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *bannerScrollview;
@property (weak, nonatomic) IBOutlet UIView *routeView;
@property (weak, nonatomic) IBOutlet UILabel *bannerinTegralLabel;
@property (weak, nonatomic) IBOutlet UILabel *bannerinByStagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *bannerinFreePlayLabel;
@property (weak, nonatomic) IBOutlet UILabel *bannerinTravelTreasureLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeight;



- (IBAction)integralClickFunc:(id)sender;
- (IBAction)stagesClickFunc:(id)sender;
- (IBAction)freeClickFunc:(id)sender;
- (IBAction)TravelTreasureClickFunc:(id)sender;


- (void)bindeDataWithViewModel:(JFStagingTourBannerItem *) viewModel viewModelList:(NSMutableArray *)viewModelArray;

@end

//
//  JFstagingTourplayRecommendedTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/29.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"

@interface JFstagingTourplayRecommendedTableViewCell : JFBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *recommendedSelectedView;

- (void)bindeDataWithViewModel:(NSMutableArray *) viewModel;

@end

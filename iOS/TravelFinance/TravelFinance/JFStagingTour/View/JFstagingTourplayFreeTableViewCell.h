//
//  JFstagingTourplayFreeTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/29.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"

@interface JFstagingTourplayFreeTableViewCell : JFBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *playFreeScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;



- (void)bindeDataWithViewModel:(NSMutableArray *) viewModel;

@end

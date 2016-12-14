//
//  JFGuideViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/22.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"


@interface JFGuideViewController : JFBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *guideFirstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *guideSecondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *guideThirdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *guideFourthImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *guideScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *guidePageControl;

@property (nonatomic, copy) void(^guideBlock)(void);

@end

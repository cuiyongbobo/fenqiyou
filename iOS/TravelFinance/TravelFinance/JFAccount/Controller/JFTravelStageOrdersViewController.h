//
//  JFTravelStageOrdersViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"

@interface JFTravelStageOrdersViewController : JFBaseViewController

@property (nonatomic, strong) UITableView *travelOrdersTableView;
@property (nonatomic, strong) UITableView *travelTableView;
@property (nonatomic, strong) UITableView *cancelTravelTableView;
@property (weak, nonatomic) IBOutlet UIImageView *waitTravelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *TravelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cancelTravelImageView;
@property (weak, nonatomic) IBOutlet UIView *travelTitleView;
@property (weak, nonatomic) IBOutlet UIScrollView *travelScrollView;


- (IBAction)handleWaitTravel:(id)sender;
- (IBAction)handleTravel:(id)sender;
- (IBAction)handleCancelTravel:(id)sender;



@end

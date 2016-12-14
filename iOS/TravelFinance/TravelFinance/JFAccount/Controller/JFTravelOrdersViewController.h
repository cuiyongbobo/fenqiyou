//
//  JFTravelOrdersViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"

@interface JFTravelOrdersViewController : JFBaseViewController

@property (nonatomic, weak)IBOutlet UITableView *travelOrdersTableView;
@property (nonatomic, weak)IBOutlet UITableView *travelTableView;
@property (nonatomic, weak)IBOutlet UITableView *cancelTravelTableView;


@property (weak, nonatomic) IBOutlet UIImageView *waitTravelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *TravelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cancelTravelImageView;
@property (weak, nonatomic) IBOutlet UIView *travelTitleView;
@property (weak, nonatomic) IBOutlet UIScrollView *travelScrollView;
@property (weak, nonatomic) IBOutlet UIButton *stayOutButton;
@property (weak, nonatomic) IBOutlet UIButton *alreadySetOutButton;
@property (weak, nonatomic) IBOutlet UIButton *alreadycanceledButton;
@property (weak, nonatomic) IBOutlet UIView *travelOrderNoDataView;
@property (weak, nonatomic) IBOutlet UIView *travelNoDataView;
@property (weak, nonatomic) IBOutlet UIView *cancelTravelNoDataView;






- (IBAction)handleWaitTravel:(id)sender;
- (IBAction)handleTravel:(id)sender;
- (IBAction)handleCancelTravel:(id)sender;



@end

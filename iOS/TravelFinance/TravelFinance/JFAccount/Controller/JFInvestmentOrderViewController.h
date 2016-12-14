//
//  JFInvestmentOrderViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"

@interface JFInvestmentOrderViewController : JFBaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *travelScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *waitTravelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *TravelImageView;
@property (nonatomic, weak) IBOutlet UITableView *travelOrdersTableView;
@property (nonatomic, weak) IBOutlet UITableView *travelTableView;
@property (weak, nonatomic) IBOutlet UIButton *InpossessionButton;
@property (weak, nonatomic) IBOutlet UIButton *alreadyquitButton;
@property (weak, nonatomic) IBOutlet UIView *travelNoDataView;
@property (weak, nonatomic) IBOutlet UIView *travelOrderNoDataView;




- (IBAction)handleinvestmentHold:(id)sender;
- (IBAction)handleinvestmentQuit:(id)sender;


@end

//
//  JFSubmitOrderViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/7.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"

#import "JFCreditPersonItem.h"
#import "JFTravelPedestrian.h"

@interface JFSubmitOrderViewController : JFBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *disbursementsLabel;
@property (nonatomic, strong) NSDictionary *detailsDictionary;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) JFCreditPersonItem *personItem;
@property (weak, nonatomic) IBOutlet UILabel *realPaymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *realPaymentNameLabel;
//@property (nonatomic, strong) JFTravelPedestrian *personInformation;



@end

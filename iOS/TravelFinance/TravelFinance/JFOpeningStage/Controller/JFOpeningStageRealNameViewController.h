//
//  JFOpeningStageRealNameViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/16.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"

#import "JFTravelPersonItem.h"

@interface JFOpeningStageRealNameViewController : JFBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *realNameText;
@property (weak, nonatomic) IBOutlet UITextField *identityCardText;
@property (weak, nonatomic) IBOutlet UIButton *realAuthentication;
@property (nonatomic, strong) JFTravelPersonItem *travelPerson;
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, strong) NSString *personInformationType;


- (IBAction)handleRealAuthentication:(id)sender;


@end

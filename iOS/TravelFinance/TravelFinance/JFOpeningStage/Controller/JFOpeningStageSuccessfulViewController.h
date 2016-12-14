//
//  JFOpeningStageSuccessfulViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/16.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"

@interface JFOpeningStageSuccessfulViewController : JFBaseViewController

@property (nonatomic, strong) NSString *auotaValues;
@property (weak, nonatomic) IBOutlet UILabel *auotaLabel;


- (IBAction)handleToStage:(id)sender;
- (IBAction)handleCollarIntegral:(id)sender;


@end

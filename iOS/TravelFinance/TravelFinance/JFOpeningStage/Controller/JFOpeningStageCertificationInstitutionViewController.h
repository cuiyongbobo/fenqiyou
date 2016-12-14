//
//  JFOpeningStageCertificationInstitutionViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/16.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"

@interface JFOpeningStageCertificationInstitutionViewController : JFBaseViewController

@property (weak, nonatomic) IBOutlet UIView *bindingCreditView;
@property (weak, nonatomic) IBOutlet UIView *bindingSesameView;
@property (weak, nonatomic) IBOutlet UIButton *bindingNextButton;
@property (weak, nonatomic) IBOutlet UILabel *creditAuthorizationStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sesameAuthorizationStateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *certificationImageview;
@property (weak, nonatomic) IBOutlet UIImageView *sesameImageView;



- (IBAction)handleNext:(id)sender;



@end

//
//  JFTravelPersonInformationViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/8.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"

#import "JFCreditPersonItem.h"
#import "JFTravelPedestrian.h"

@protocol backPersonInformationdelegate <NSObject>

-(void)backPerson:(JFTravelPedestrian *)information personType:(NSString *)type;

@end

@interface JFTravelPersonInformationViewController : JFBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *PersonInformationTableView;
@property (nonatomic,strong) NSString *personType;
@property (nonatomic, strong) JFCreditPersonItem *personItem;
@property (nonatomic, strong) NSString *orderType;
//@property (nonatomic, strong) JFTravelPedestrian *personInformation;
@property (assign,nonatomic) id<backPersonInformationdelegate> persondelegate;



@end

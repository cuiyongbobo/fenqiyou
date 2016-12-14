//
//  JFAccountPersonInformationTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/13.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"
#import "JFPersonalCenterItem.h"

@interface JFAccountPersonInformationTableViewCell : JFBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *tripRecordView;
@property (weak, nonatomic) IBOutlet UIView *myCardView;
@property (weak, nonatomic) IBOutlet UIView *integralMallView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isRealImageView;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (weak, nonatomic) IBOutlet UILabel *isRealLabel;


- (IBAction)handleMyInformation:(id)sender;
- (void)bindeDataWithViewModel:(JFPersonalCenterItem *) viewModel viewModelList:(NSMutableArray *)viewModelArray;


@end

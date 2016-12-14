//
//  JFsubmitOrderFinishTableViewCellTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/8.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"

@interface JFsubmitOrderFinishTableViewCellTableViewCell : JFBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *submitFinishButton;

- (IBAction)handleFinish:(id)sender;

@end

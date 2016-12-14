//
//  JFNotLoginMyAccountTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"

@interface JFNotLoginMyAccountTableViewCell : JFBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *notLoginTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *notLoginSubtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *handleLogin;

- (IBAction)handleLogin:(id)sender;

- (void)bindeDataWithViewModel:(id *) viewModel viewModelList:(NSMutableArray *)viewModelArray;

@end

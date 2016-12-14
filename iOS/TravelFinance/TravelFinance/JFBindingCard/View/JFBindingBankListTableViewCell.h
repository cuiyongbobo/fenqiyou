//
//  JFBindingBankListTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/9.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseTableViewCell.h"
#import "JFBankListModel.h"


@interface JFBindingBankListTableViewCell : JFBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bindingBankLogoImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *bindingBankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bindingBankInformationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bindingBottomImageView;

- (void)bindeDataWithViewModel:(JFBankListModel *) viewModel;

@end

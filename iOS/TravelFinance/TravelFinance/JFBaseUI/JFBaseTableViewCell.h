//
//  JFBaseTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/31.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFMacro.h"

@protocol JFBaseTableViewCellDelegate <NSObject>
@optional
- (void)clickCell:(id)cell tag:(JFTableCellClickType) tag userinfo:(id)userinfo;
@end

@interface JFBaseTableViewCell : UITableViewCell


@property (nonatomic, weak) id<JFBaseTableViewCellDelegate> delegate;


- (void)bindeDataWithViewModel:(id) viewModel;

@end

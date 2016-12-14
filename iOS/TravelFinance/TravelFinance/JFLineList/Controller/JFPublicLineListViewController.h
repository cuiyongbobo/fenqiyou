//
//  JFPublicLineListViewController.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/1.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseViewController.h"

@interface JFPublicLineListViewController : JFBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *LineListTableView;
@property (nonatomic,copy) NSString *lineTag;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UIImageView *list_noitemImageView;



@end

//
//  JFPersonaGesturepasswordTableViewCell.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/15.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFPersonaGesturepasswordTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UISwitch *gestursSwitch;

- (IBAction)handleSwitchAction:(id)sender;

@end

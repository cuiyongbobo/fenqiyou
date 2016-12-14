//
//  JFPersonaGesturepasswordTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/15.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFPersonaGesturepasswordTableViewCell.h"

#import "JFString.h"

@implementation JFPersonaGesturepasswordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:JFKSetGesturePassword] isEqualToString:@"开启"]) {
        [self.gestursSwitch setOn:YES];
    }else {
        [self.gestursSwitch setOn:NO];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)handleSwitchAction:(id)sender {
    
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"开启");
        
        //        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"gestureFinalSaveKey"]) {
        //
        //        }else {
        //
        //
        //        }
        
        [[NSUserDefaults standardUserDefaults] setObject:@"开启" forKey:JFKSetGesturePassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }else {
        NSLog(@"关闭");
        [[NSUserDefaults standardUserDefaults] setObject:@"关闭" forKey:JFKSetGesturePassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
@end

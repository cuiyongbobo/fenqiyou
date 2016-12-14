//
//  YKUpdateVersionViewController.h
//  Yinker
//
//  Created by cuiyong on 16/5/23.
//  Copyright © 2016年 Yinker. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFUpdateVersionItem.h"

@interface YKUpdateVersionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *updateBDView;
@property (weak, nonatomic) IBOutlet UIView *updateInfoView;
@property (weak, nonatomic) IBOutlet UIView *updateButtonView;
@property (nonatomic, strong) JFUpdateVersionItem *updateVersionItem;

//隐藏关闭按钮
- (void)hideClostBtn:(BOOL)buttonHidden;


@end

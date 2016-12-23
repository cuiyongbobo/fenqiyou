//
//  JFResultViewController.h
//  OcrID
//
//  Created by cuiyong on 16/12/20.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFBaseViewController.h"

@interface JFResultViewController :JFBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *frontIDImageView;
@property (weak, nonatomic) IBOutlet UIImageView *behindIDImageView;
@property (nonatomic, strong) NSMutableDictionary *dicfrontRecogResult;
@property (nonatomic, strong) NSMutableDictionary *dicbehindRecogResult;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *frontHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *biendHeight;




- (IBAction)handleDetermine:(id)sender;


@end

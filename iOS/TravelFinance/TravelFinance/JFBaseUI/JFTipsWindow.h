//
//  JFTipsWindow.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/28.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, backgroundcolor) {
    white=1,
    black,
};

@interface JFTipsWindow : UIWindow

+ (instancetype)sharedTipview;

- (void)HiddenTipView:(BOOL)value viewcontroller:(UIViewController *)viewcontroller tiptext:(NSString *)tiptext backgroundcolor:(backgroundcolor)backgroundcolor;

@end

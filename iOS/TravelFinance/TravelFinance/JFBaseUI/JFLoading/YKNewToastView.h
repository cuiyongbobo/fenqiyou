//
//  YKNewToastView.h
//  SimpleFinance
//
//  Created by 刘江涛 on 15/8/4.
//  Copyright (c) 2015年 yinker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YKNewToastViewCompletionBlock)(BOOL finished);

@interface YKNewToastView : UIView

+ (YKNewToastView *)sharedNewToastView;
+ (YKNewToastView *)sharedNewToastViewWithText:(NSString*)text;

+ (YKNewToastView *)newToastViewWithText:(NSString *)text;

- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
- (void)showInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay completion:(YKNewToastViewCompletionBlock) completion;
- (void)hide;

@end

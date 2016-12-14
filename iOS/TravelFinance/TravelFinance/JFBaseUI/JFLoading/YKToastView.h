//
//  YKToastView.h
//  YKNetwork
//
//  Created by kAir on 15/2/23.
//  Copyright (c) 2015年 yinker. All rights reserved.
//

#import <UIKit/UIKit.h>


static const CGFloat KYKToastShowErrorTime = 1.5;

static const CGFloat KYKToastShowErrorTimeForBuying = 3;

static const NSInteger KYKToastShowWaitingTime = 30;

static const NSInteger KYKToastShowConnectionTypeErrorTime = 3.0;

typedef void (^YKToastViewCompletionBlock)(BOOL finished);

/**
 *  黑色弹框
 */
@interface YKToastView : UIView

/**
 *  单例的黑色弹框
 *
 *  @return YKToastView
 */
+ (YKToastView *)sharedToastView;

/**
 *  单例的黑色弹框：：文字
 *
 *  @return YKToastView
 */
+ (YKToastView *)sharedToastViewWithText:(NSString*)text isTipsBackgrounds:(BOOL)isTipsBackground;

/**
 *  单例的黑色弹框：转菊花带文字
 *
 *  @return YKToastView
 */
+ (YKToastView *)sharedToastViewWWithIndicatorAndText:(NSString*)text;


/**
 *  创建黑色弹框：带文字
 *
 *  @return YKToastView
 */
+ (YKToastView *)toastViewWithText:(NSString *)text;

/**
 *  创建黑色弹框：转菊花带文字
 *
 *  @return YKToastView
 */
+ (YKToastView *)toastViewWithIndicatorAndText:(NSString *)text;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
- (void)showInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay completion:(YKToastViewCompletionBlock) completion;
- (void)hide;

+ (UIView *)topView;

@property (nonatomic, assign) BOOL passthroughTouches;
@property (nonatomic, assign) BOOL isTipsBackground;

@end

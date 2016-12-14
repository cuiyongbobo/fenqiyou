//
//  JFColor.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  定义公共颜色及转换函数
 */

@interface JFColor : NSObject


+ (UIColor *)colorWithValue:(NSUInteger)colorValue;

+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a;

+ (UIColor *)mainColor;

@end

/**
 *  定义常量颜色
 */

/**
 *  桔色，主色
 */

static NSUInteger const KYKMainColor = 0xFF976a01;
static NSString  *JFKNavigationBarBackgroundColor = @"#3e93f0";
static NSUInteger const KYKNavigationBarTitleColorForBlackBackground = 0xffc8a556;

static NSUInteger const KYKMainPrsColor = 0xFFef870d;
static NSUInteger const KYKMainThinColor = 0xFFfdb336;
static NSUInteger const KYKLightBlackColor = 0xFF666666;
static NSUInteger const KYKLightGrayColor = 0xFFeeeeee;
static NSUInteger const KYKSegmentControlTextColorNomral = 0xFF999999;
static NSUInteger const KYKSegmentSpliteLineColor = 0xFFe5e5e5;
static NSUInteger const KYKSegmentLightGrayBackgroundColor = 0xFFf5f5f5;
static NSUInteger const KYKDarkBlackColor = 0xFF333333;
static NSUInteger const KYKDarkGrayColor = 0xFFcccccc;
static NSUInteger const KYKMainGreenColor = 0xFFa4c327;
static NSUInteger const KYKLightMainColor = 0xFFffe7c0;
static NSUInteger const KYKBuyActionTopTipsColor = 0xFFe21b2e;
static NSUInteger const KYKAnnouncemenTableViewCellSelectedColor = 0xFFF2F2F2;
static NSUInteger const KYKSumOfMoneyTextColor = 0xFF976a01;
static NSUInteger const KYKLightSumOfMoneyTextColor = 0xFFe2d7c8;

//所有白底上的长按钮字体颜色使用如下颜色，字号为24
static NSUInteger const KYKButtonTitleTextColorForNormalOverWhite = 0xff412f07;
static NSUInteger const KYKButtonTitleTextColorForDisableOverWhite = 0xff999999;
static NSUInteger const KYKButtonTitleTextColorForHighlightOverWhite = KYKButtonTitleTextColorForNormalOverWhite;

static NSUInteger const KYKButtonTitleShadowColorForNormalOverWhite = 0xfff1dead;
static NSUInteger const KYKButtonTitleShadowColorForDisableOverWhite = 0xffd4d4d4;
static NSUInteger const KYKButtonTitleShadowColorForHighlightOverWhite = KYKButtonTitleTextColorForNormalOverWhite;


//所有深灰色的底上的长按钮字体颜色使用如下颜色，字号为24
static NSUInteger const KYKButtonTitleTextColorForNormalOverBlack = 0xff5c430b;
static NSUInteger const KYKButtonTitleTextColorForDisableOverBlack = 0xff5c430b ;
static NSUInteger const KYKButtonTitleTextColorForHighlightOverBlack = KYKButtonTitleTextColorForNormalOverBlack;

static NSUInteger const KYKButtonTitleShadowColorForNormalOverBlack = 0xfff1dead;
static NSUInteger const KYKButtonTitleShadowColorForDisableOverBlack = 0xffd4d4d4;
static NSUInteger const KYKButtonTitleShadowColorForHighlightOverBlack = KYKButtonTitleTextColorForNormalOverBlack;






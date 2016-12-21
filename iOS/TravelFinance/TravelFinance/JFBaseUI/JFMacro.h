//
//  JFMacro.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/30.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFDevice.h"
#ifndef JFMacro_h
#define JFMacro_h

/**
 *  比例
 */

#define JFHeightRateScale ([JFDevice screenHeight]/667)
#define JFWidthRateScale ([JFDevice screenWidth]/375)

//#define JFHeightRateScale ([JFDevice screenHeight]>667?[JFDevice screenHeight]/667:1)
//#define JFWidthRateScale ([JFDevice screenWidth]>375?[JFDevice screenWidth]/375:1)

/* 屏幕 */
#define SCREEN_320_480      CGSizeEqualToSize(CGSizeMake(320,480),   [[[UIScreen mainScreen] currentMode] size])
#define SCREEN_640_960      CGSizeEqualToSize(CGSizeMake(640,960),   [[[UIScreen mainScreen] currentMode] size])
#define SCREEN_640_1136     CGSizeEqualToSize(CGSizeMake(640,1136),  [[[UIScreen mainScreen] currentMode] size])
#define SCREEN_750_1334     CGSizeEqualToSize(CGSizeMake(750,1334),  [[[UIScreen mainScreen] currentMode] size])
#define SCREEN_1242_2208    CGSizeEqualToSize(CGSizeMake(1242,2208),  [[[UIScreen mainScreen] currentMode] size])
#define SCREEN_1125_2001    CGSizeEqualToSize(CGSizeMake(1125,2001),  [[[UIScreen mainScreen] currentMode] size])
#define SCREEN_768_1024     CGSizeEqualToSize(CGSizeMake(768,1024),  [[[UIScreen mainScreen] currentMode] size])
#define SCREEN_1536_2048    CGSizeEqualToSize(CGSizeMake(1536,2048), [[[UIScreen mainScreen] currentMode] size])
#define DEVICE_4S SCREEN_640_960
#define DEVICE_5  SCREEN_640_1136
#define DEVICE_6  SCREEN_750_1334
#define DEVICE_6P SCREEN_1242_2208

#define FIXEDCONSTRAINT(x) x/[UIScreen mainScreen].scale //固定约束适配屏幕

//#define ACCOUNT_API_ID (@"1bac2ddf9deb4a389d751ab9f374b59a")
//#define ACCOUNT_API_SECRET (@"6969bf68de994b3383943ad602d9c69c")


/* 系统 */
#define iOS_8 UIDevice.currentDevice.systemVersion.intValue == 8
#define iOS_8_AND_LATER UIDevice.currentDevice.systemVersion.intValue >= 8
#define iOS_8_4_NOT UIDevice.currentDevice.systemVersion.doubleValue < 8.4 || UIDevice.currentDevice.systemVersion.doubleValue >= 8.5
#define iOS_7 UIDevice.currentDevice.systemVersion.intValue == 7
#define iOS_7_0_X UIDevice.currentDevice.systemVersion.doubleValue >= 7.0 && UIDevice.currentDevice.systemVersion.doubleValue < 7.1
#define iOS_7_AND_LATER UIDevice.currentDevice.systemVersion.intValue >= 7
#define iOS_6 UIDevice.currentDevice.systemVersion.intValue == 6
#define iOS_6_AND_LATER UIDevice.currentDevice.systemVersion.intValue >= 6
#define iOS_5 UIDevice.currentDevice.systemVersion.intValue == 5
#define iOS_5_AND_LATER UIDevice.currentDevice.systemVersion.intValue >= 5
#define iOS_5_BEFORE UIDevice.currentDevice.systemVersion.intValue < 5
#define iOS_10_AND_LATER UIDevice.currentDevice.systemVersion.intValue >= 10

//支持WKWebView
#define SUPPORT_WKWEBVIEW NSClassFromString(@"WKWebView") != Nil

typedef NS_ENUM(NSInteger, JFTableCellClickType) {
    JFTableCellClickTypeTouristContract = 0,
    
    //****** Home - Root ******
    JFTableCellClickTypeHeaderBanner,   //Banner
    JFTableCellClickTypefqGoods,          //fqGoods
    JFTableCellClickTypefqGoodsDetails,          //注册
    JFTableCellClickTypeFreePlay,          //白玩
    
    JFTableCellClickTypeSpecialone,          //专题1
    JFTableCellClickTypeSpecialSecond,     //专题2
    JFTableCellClickTypeHomeSpecialThird,  //专题3
    JFTableCellClickTypeSelectRecommend,   // 进入红包页
    
    JFTableCellClickTypeintegral,
    JFTableCellClickTypestages,            //投资
    
    JFTableCellClickTypefree,  //设置
    JFTableCellClickTypeTravel,  //个人信息
    JFTableCellClickTypesubmitOrderFinish,  //提交订单
    JFTableCellClickTypeMyHeader,  //我的头像
    JFTableCellClickTypeLogin,       //立即登录
    JFTableCellClickTypeTravelOrder,   //提现
    JFTableCellClickTypeleftLogo,  //添加完成
    
    //****** ChargeOrWithdraw******
    JFTableCellClickTyperightLogo,  //绑卡
    JFTableCellClickTypeOpenFinancial,  //充值
    JFTableCellClickTypeOpenStaging,  //提现
    JFTableCellClickTypeLoginOut, //允许操作
    
    //****** Setting ******
    JFTableCellClickTypeAntimoneylaundering,  //设置手势密码
    
    //****** Common ******
    JFTableCellClickTypeServiceAgreement, //刷新table
    JFTableCellClickTypeFinancingModel,   //弹层
    
    //Debt转让
    JFTableCellClickTypeCardVolume,//我的卡劵
    YKTableCellClickTypeFee, //手续费
    YKCellClickType6
};


#endif /* JFMacro_h */

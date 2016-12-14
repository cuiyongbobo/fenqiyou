//
//  JFDevice.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

/**
 *  设备屏幕尺寸类型
 */
typedef NS_ENUM(NSUInteger, JFDeviceScreenSizeType){
    /**
     *  初始化
     */
    JFDeviceScreenSizeTypeNone,
    /**
     *  4s设备的屏幕分辨率
     */
    JFDeviceScreenSizeType4S,
    /**
     *  5S设备的屏幕分辨率
     */
    JFDeviceScreenSizeType5S,
    /**
     *  6设备的屏幕分辨率
     */
    JFDeviceScreenSizeType6,
    /**
     *  6Plus设备的屏幕分辨率
     */
    JFDeviceScreenSizeType6Plus,
};


@interface JFDevice : NSObject

+ (instancetype)sharedYKDevice;

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, readonly) CGFloat uiScale;
@property (nonatomic, readonly) CGFloat uiScaleForWidth;
@property (nonatomic, readonly) JFDeviceScreenSizeType deviceScreenSizeType;

+ (BOOL)laterIOS7;

+ (BOOL)laterIOS8;

+ (CGFloat)screenWidth;

+ (CGFloat)screenHeight;

+ (CGFloat)statusBarHeight;

//+ (CGFloat)navigationBarHeight;
//
//+ (CGFloat)viewControllerTopBarHeight;

@end

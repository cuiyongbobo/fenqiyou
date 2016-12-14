//
//  JFDevice.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFDevice.h"

#import <sys/utsname.h>
#import <sys/sysctl.h>
#import <sys/types.h>
#import <UIKit/UIDevice.h>
#import <CoreGraphics/CoreGraphics.h>
#import "AppDelegate.h"
#import "JFNavigationController.h"

#define EMPTY_UUID @"00000000-0000-0000-0000-000000000000"

static NSString *const KYKUuidKey = @"YKUuidKey";

static const  CGSize KYKDeviceScreenSize4S = {320,480};
static const  CGSize KYKDeviceScreenSize5S = {320,568};
static const  CGSize KYKDeviceScreenSize6 = {375,667};
static const  CGSize KYKDeviceScreenSize6Plus = {414,736};

@interface JFDevice ()

/**机型**/
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, readwrite) CGFloat uiScale;
@property (nonatomic, readwrite) CGFloat uiScaleForWidth;
@property (nonatomic, readwrite) JFDeviceScreenSizeType deviceScreenSizeType;
@property (nonatomic, assign) CGSize deviceScreenSize;

@end

static JFDevice *sharedDevice = nil;

@implementation JFDevice

+ (instancetype)sharedYKDevice {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDevice = [[JFDevice alloc] init];
    });
    
    return sharedDevice;
}

- (id)init {
    self = [super init];
    
    if (self) {
        [self setupDeviceUUID];
        
        self.deviceScreenSize = [UIScreen mainScreen].bounds.size;
        
        if (CGSizeEqualToSize(_deviceScreenSize, KYKDeviceScreenSize4S)) {
            
            self.deviceScreenSizeType = JFDeviceScreenSizeType4S;
        }
        else if(CGSizeEqualToSize(_deviceScreenSize, KYKDeviceScreenSize5S)){
            self.deviceScreenSizeType = JFDeviceScreenSizeType5S;
        }
        else if(CGSizeEqualToSize(_deviceScreenSize, KYKDeviceScreenSize6)){
            self.deviceScreenSizeType = JFDeviceScreenSizeType6;
        }
        else if(CGSizeEqualToSize(_deviceScreenSize, KYKDeviceScreenSize6Plus)){
            self.deviceScreenSizeType = JFDeviceScreenSizeType6Plus;
        }
        self.uiScaleForWidth = _deviceScreenSize.width/375.0;
        self.uiScale = _deviceScreenSize.height/667.0;
    }
    
    return self;
}

+ (BOOL)laterIOS7 {
    return UIDevice.currentDevice.systemVersion.intValue > 7;
}

+ (BOOL)laterIOS8 {
    return UIDevice.currentDevice.systemVersion.intValue >= 8;
}

- (void)setupDeviceUUID {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [defaults objectForKey:KYKUuidKey];
    if (uuid && uuid.length > 0) {
        self.uuid = uuid;
    } else {
        CFUUIDRef uuidObj = CFUUIDCreate(nil);
        NSString *uuidString =
        (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
        self.uuid = uuidString;
        CFRelease(uuidObj);
        
        [[NSUserDefaults standardUserDefaults] setObject:_uuid forKey:KYKUuidKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (CGFloat)screenWidth {
    return [JFDevice sharedYKDevice].deviceScreenSize.width;
}

+ (CGFloat)screenHeight {
    return [JFDevice sharedYKDevice].deviceScreenSize.height;
}

+ (CGFloat)statusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}
//+ (CGFloat)navigationBarHeight {
//    return [AppDelegate rootNavigationCotroller].navigationBar.frame.size.height;
//}

//+ (CGFloat)viewControllerTopBarHeight {
//    return CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) +
//    CGRectGetHeight(
//                    [AppDelegate rootNavigationCotroller].navigationBar.frame);
//}


@end

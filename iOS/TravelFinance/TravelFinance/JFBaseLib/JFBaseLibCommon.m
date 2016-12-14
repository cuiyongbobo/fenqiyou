//
//  JFBaseLibCommon.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBaseLibCommon.h"

#import <AdSupport/AdSupport.h>
#include <sys/xattr.h>
#import "YKReachability.h"
#import "YKReachabilityMgr.h"

@interface JFBaseLibCommon (){
    YKSimpleFinanceAppType _simpleFinanceAppType;
}

@property (nonatomic, strong) NSString *appLocalVersion;
@property (nonatomic, strong) NSString *appPackageName;

- (void)setSimpleFinanceAppType:(YKSimpleFinanceAppType)simpleFinanceAppType;
- (YKSimpleFinanceAppType)simpleFinanceAppType;

@end

static JFBaseLibCommon *sharedBaseLibCommon = nil;

@implementation JFBaseLibCommon

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBaseLibCommon = [[JFBaseLibCommon alloc]init];
    });
    
    return sharedBaseLibCommon;
}

- (void)setSimpleFinanceAppType:(YKSimpleFinanceAppType)simpleFinanceAppType {
    _simpleFinanceAppType = simpleFinanceAppType;
}

- (YKSimpleFinanceAppType)simpleFinanceAppType {
    return YKSimpleFinanceAppTypeDefault;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        NSDictionary *infoDictionary =  [[NSBundle mainBundle] infoDictionary];
        self.appLocalVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        self.appPackageName = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    }
    return self;
}

+ (NSString *)baseURL {
#if DEBUG
    return KYKRootURLDevelop;
#elif RELEASE
    return KYKRootURLOnline;
#endif
}


+ (NSString *)baseH5URL {
#if DEBUG
    return KYKRootH5URLDevelop;
#elif RELEASE
    return KYKRootH5URLOnline;
#endif
    
}

+ (void)goToAppStore{
    
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSStibCoring stringWithFormat:@"https://itunes.apple.com/cn/app/id%@",@""]]];
}

+ (NSString *)appVersion{
    
    return [JFBaseLibCommon sharedInstance].appLocalVersion;
}

+ (NSString *)URLEncodedString:(NSString *)string {
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)string,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

+ (NSString *)URLDecodedString:(NSString *)string {
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)string, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}


+ (NSString *)umAppKey {
    
    switch ([JFBaseLibCommon sharedInstance].simpleFinanceAppType) {
        case YKSimpleFinanceAppTypeDefault:
        {
            return KYKUMAppDefaultKey;
        }
            break;
        case YKSimpleFinanceAppTypeDefaultTest:
        {
            return KYKUMAppDefaultKey;
        }
            break;
        default: {
            return KYKUMAppDefaultKey;
        }
            break;
    }
}

+ (NSString *)tencentAppId {
    switch ([JFBaseLibCommon sharedInstance].simpleFinanceAppType) {
        case YKSimpleFinanceAppTypeDefault:
        case YKSimpleFinanceAppTypeDefaultTest: {
            return kYKTencentDefaultAppID;
        }
            break;
        default: {
            return kYKTencentDefaultAppID;
        }
            break;
    }
}

+ (NSString *)tencentAppKey {
    switch ([JFBaseLibCommon sharedInstance].simpleFinanceAppType) {
        case YKSimpleFinanceAppTypeDefault:
        case YKSimpleFinanceAppTypeDefaultTest: {
            return kYKTencentDefaultAppKey;
        }
            break;
        default: {
            return kYKTencentDefaultAppKey;
        }
            break;
    }
}

+ (NSString *)jfWXAppId {
    switch ([JFBaseLibCommon sharedInstance].simpleFinanceAppType) {
        case YKSimpleFinanceAppTypeDefault:
        case YKSimpleFinanceAppTypeDefaultTest: {
            return kYKWeChatDefaultAppID;
        }
            break;
        default: {
            return kYKWeChatDefaultAppID;
        }
            break;
    }
}

+ (NSString *)jfWXAppSecret {
    switch ([JFBaseLibCommon sharedInstance].simpleFinanceAppType) {
        case YKSimpleFinanceAppTypeDefault:
        case YKSimpleFinanceAppTypeDefaultTest: {
            return kYKWeChatDefaultAppSecret;
        }
            break;
        default: {
            return kYKWeChatDefaultAppSecret;
        }
            break;
    }
}

+ (NSString *)appAppleID {
    
    switch ([JFBaseLibCommon sharedInstance].simpleFinanceAppType) {
        case YKSimpleFinanceAppTypeDefault:
        case YKSimpleFinanceAppTypeDefaultTest:
        {
            return kYKAppDefaultID;
        }
            break;
        default: {
            return kYKAppDefaultID;
        }
            break;
    }
}

+ (BOOL)checkNetStatusNotReachable {
    YKNetworkStatus networkStatus = [YKReachabilityMgr sharedReachabilityMgr].currentReachabilityStatus;
    if (networkStatus == YKNotReachable) {
        return YES;
    }
    return NO;
}




@end

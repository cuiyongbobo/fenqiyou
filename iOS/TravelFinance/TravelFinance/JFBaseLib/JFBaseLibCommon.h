//
//  JFBaseLibCommon.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#ifndef TravelFinance_JFBaseLibCommon_h
#define TravelFinance_JFBaseLibCommon_h

#import <Foundation/Foundation.h>

static NSString *const KYKRootURLName = @"jianlc.com/";

/**
 *  线上服务URL
 */

static NSString *const KYKRootURLOnline = @"https://api.u9fenqiyou.cn";
static NSString *const KYKRootH5URLOnline = @"https://www.u9fenqiyou.cn";

/**
 *  开发服务URL
 */

//static NSString *const KYKRootURLDevelop = @"https://api.u9fenqiyou.cn";
//
//static NSString *const KYKRootH5URLDevelop = @"https://www.u9fenqiyou.cn";

static NSString *const KYKRootURLDevelop = @"http://139.129.237.13/fqy_server";

static NSString *const KYKRootH5URLDevelop = @"http://139.129.237.13/fqy/webapp";


/**
 *  优玖App类型
 */
typedef NS_ENUM(NSUInteger, YKSimpleFinanceAppType){
    /**
     *  优玖
     */
    YKSimpleFinanceAppTypeDefault,
    /**
     *  优玖test
     */
    YKSimpleFinanceAppTypeDefaultTest
};

static NSString * const KYKUMAppDefaultKey = @"583be3b02ae85b5ced000249";
static NSString * const KYKUMAppDefaultKeyTest = @"583be3b02ae85b5ced000249";

static NSString * const kYKTencentDefaultAppKey = @"T4xfpTfVoyLHkuZb";
static NSString * const kYKTencentDefaultAppID = @"1105776941";

static NSString * const kYKWeChatDefaultAppID = @"wx12f011751a445199";
static NSString * const kYKWeChatDefaultAppSecret = @"ee3dcd01b67d104ede9a42a56a423f5a";

static NSString * const kYKAppDefaultID = @"987830667";


static NSString * const kJFACCOUNTAPIID = @"1bac2ddf9deb4a389d751ab9f374b59a";
static NSString *const kJFACCOUNTAPISECRET = @"6969bf68de994b3383943ad602d9c69c";


/**
 *  工具函数
 */
@interface JFBaseLibCommon : NSObject

/**
 *  native请求使用的base url
 *
 *  @return url
 */
+ (NSString *)baseURL;

/**
 *  h5请求使用的base url
 *
 *  @return url
 */
+ (NSString *)baseH5URL;


/**
 *  appSource QQ、QQ空间分享的AppID
 *
 *  @return tencentAppId
 */
+ (NSString *)tencentAppId;

/**
 *  appSource QQ、QQ空间分享的AppKey
 *
 *  @return tencentAppKey
 */
+ (NSString *)tencentAppKey;


/**
 *  appSource 微信、朋友圈分享的AppID
 *
 *  @return tencentAppId
 */
+ (NSString *)jfWXAppId;

/**
 *  appSource 微信、朋友圈分享的AppKey
 *
 *  @return tencentAppKey
 */
+ (NSString *)jfWXAppSecret;

/**
 *  苹果AppId
 *
 *  @return 苹果AppId
 */
+ (NSString *)appAppleID;

/**
 *  对URL String进行encode
 */
+ (NSString *)URLEncodedString:(NSString *)string;

/**
 *  对URL String进行decode
 */
+ (NSString *)URLDecodedString:(NSString *)string;

/**
 *  跳转AppStore
 */
+ (void)goToAppStore;


/**
 *  App版本
 *
 *  @return  App版本
 */
+ (NSString *)appVersion;

/**
 *  umeng app key
 *
 *  @return  umeng app key
 */
+ (NSString *)umAppKey;

/**
 *  check net status
 *
 *  @return  net status
 */

+ (BOOL)checkNetStatusNotReachable;

@end

#endif





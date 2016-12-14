//
//  JFUmengMgr.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/25.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFUmengMgr.h"

#import "UMMobClick/MobClick.h"
#import "JFBaseLibCommon.h"

@implementation JFUmengMgr

static JFUmengMgr *sharedUmengMgr = nil;

+ (instancetype)sharedUmengMgr {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUmengMgr = [[JFUmengMgr alloc] init];
    });
    return sharedUmengMgr;
}

- (void)configUmengSettings {
    
    UMConfigInstance.appKey = [JFBaseLibCommon umAppKey];
    UMConfigInstance.ePolicy = BATCH;
    UMConfigInstance.bCrashReportEnabled = NO;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:[JFBaseLibCommon appVersion]];
}


@end

//
//  JFSesameAuthorizationBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/17.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFSesameAuthorizationBuilder.h"

#import "NSMutableDictionary+HexDict.h"
#import "JFBaseLibCommon.h"
#import "JFString.h"

static NSString *const KJSesameRequestURL = @"/credit/zhimaParams";

@implementation JFSesameAuthorizationBuilder

+ (instancetype)sharedSesameAuthorization {
    static JFSesameAuthorizationBuilder *sesameBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sesameBuilder = [[JFSesameAuthorizationBuilder alloc] init];
    });
    return sesameBuilder;
}

- (void)buildPostData:(NSString *)userId crypto:(NSString *)crypto channel:(NSString *)channel params:(NSString *)params redirectUrl:(NSString *)redirectUrl appId:(NSString *)appId sign:(NSString *) sign  {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    [paramDict setAllObject:channel forKey:@"channel"];
    [paramDict setAllObject:crypto forKey:@"crypto"];
    [paramDict setAllObject:params forKey:@"params"];
    [paramDict setAllObject:redirectUrl forKey:@"redirectUrl"];
    [paramDict setAllObject:appId forKey:@"appId"];
    [paramDict setAllObject:sign forKey:@"sign"];
    
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJSesameRequestURL];
}


@end

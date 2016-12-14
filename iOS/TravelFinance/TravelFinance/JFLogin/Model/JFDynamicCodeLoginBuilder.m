//
//  JFDynamicCodeLoginBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/28.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFDynamicCodeLoginBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KJFDynamicLoginRequestURL = @"/user/quickLogin";

@implementation JFDynamicCodeLoginBuilder

+ (instancetype)sharedDynamicCodeLogin {
    static JFDynamicCodeLoginBuilder *dynamicCodeloginBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dynamicCodeloginBuilder = [[JFDynamicCodeLoginBuilder alloc] init];
    });
    return dynamicCodeloginBuilder;
}

- (void)buildPostData:(NSString *)messageCode {
    
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:JFKUserPhoneNumber];
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"]; //appVersion
    [paramDict setAllObject:messageCode forKey:@"checkNo"];
    [paramDict setAllObject:phoneNumber forKey:@"mobile"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJFDynamicLoginRequestURL];
    
}


@end

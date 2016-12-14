//
//  JFLoginBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/28.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFLoginBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"
#import "MD5Util.h"

static NSString *const KJFLoginRequestURL = @"/user/login";

@implementation JFLoginBuilder

+ (instancetype)sharedLogin {
    static JFLoginBuilder *loginBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginBuilder = [[JFLoginBuilder alloc] init];
    });
    return loginBuilder;
}

- (void)buildPostData:(NSString *)password {
    
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:JFKUserPhoneNumber];
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:[MD5Util md532BitUpper:password] forKey:@"loginPwd"];
    [paramDict setAllObject:phoneNumber forKey:@"mobile"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJFLoginRequestURL];
    
}

@end

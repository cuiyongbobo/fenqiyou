//
//  JFRegisterBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/27.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFRegisterBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"
#import "JFMD5Util.h"

static NSString *const KJFRegisterRequestURL = @"/user/register";

@implementation JFRegisterBuilder

+ (instancetype)sharedRegister {
    static JFRegisterBuilder *registerBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        registerBuilder = [[JFRegisterBuilder alloc] init];
    });
    return registerBuilder;
}

- (void)buildPostData:(NSString *)verificationCode userPassword:(NSString *)password {
    
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:JFKUserPhoneNumber];
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:phoneNumber forKey:@"mobile"];
    [paramDict setAllObject:[JFMD5Util md532BitUpper:password] forKey:@"loginPwd"];
    [paramDict setAllObject:verificationCode forKey:@"checkNo"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJFRegisterRequestURL];
}


@end

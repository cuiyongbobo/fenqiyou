//
//  JFSendCodeBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/28.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFSendCodeBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KJFSendCodeRequestURL = @"/open/sendSms";

@implementation JFSendCodeBuilder

+ (instancetype)sharedSendCode {
    static JFSendCodeBuilder *sendCodeBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sendCodeBuilder = [[JFSendCodeBuilder alloc] init];
    });
    return sendCodeBuilder;
}

- (void)buildPostData:(NSString *)phoneNumber type:(NSString *)type {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:phoneNumber forKey:@"mobile"];
    [paramDict setAllObject:type forKey:@"type"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJFSendCodeRequestURL];
}

@end

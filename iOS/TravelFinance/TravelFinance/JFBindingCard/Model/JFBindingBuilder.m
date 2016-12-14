//
//  JFBindingBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/10.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBindingBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KJBindingRequestURL = @"/credit/bindBankCard";

@implementation JFBindingBuilder


+ (instancetype)sharedBinding {
    static JFBindingBuilder *bindingBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bindingBuilder = [[JFBindingBuilder alloc] init];
    });
    return bindingBuilder;
}

- (void)buildPostData:(NSString *)userId type:(NSString *)type bankCardNo:(NSString *)bankCardNo mobile:(NSString *)mobile verificationCode:(NSString *)verificationCode {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    [paramDict setAllObject:type forKey:@"type"];
    [paramDict setAllObject:bankCardNo forKey:@"bankCardNo"];
    [paramDict setAllObject:mobile forKey:@"mobile"];
    [paramDict setAllObject:verificationCode forKey:@"verificationCode"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJBindingRequestURL];
}


@end

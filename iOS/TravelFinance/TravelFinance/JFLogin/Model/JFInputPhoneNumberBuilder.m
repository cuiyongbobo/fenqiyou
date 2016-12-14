//
//  JFInputPhoneNumberBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/26.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFInputPhoneNumberBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"



static NSString *const KJFLoginCheckRequestURL = @"/user/checkUser";

@implementation JFInputPhoneNumberBuilder

+ (instancetype)sharedInputPhone {
    static JFInputPhoneNumberBuilder *inputPhoneBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inputPhoneBuilder = [[JFInputPhoneNumberBuilder alloc] init];
    });
    return inputPhoneBuilder;
}

- (void)buildPostData:(NSString *)phoneNumber {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:phoneNumber forKey:@"mobile"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJFLoginCheckRequestURL];
    
}

@end

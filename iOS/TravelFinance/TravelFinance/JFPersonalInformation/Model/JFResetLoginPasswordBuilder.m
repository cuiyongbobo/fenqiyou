//
//  JFResetLoginPasswordBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/21.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFResetLoginPasswordBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"
#import "JFMD5Util.h"

static NSString *const KJResetLoginPasswordRequestURL = @"/user/resetLoginPwd";

@implementation JFResetLoginPasswordBuilder

+ (instancetype)sharedResetLoginPassword {
    static JFResetLoginPasswordBuilder *resetLoginPasswordBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        resetLoginPasswordBuilder = [[JFResetLoginPasswordBuilder alloc] init];
    });
    return resetLoginPasswordBuilder;
}

- (void)buildPostData:(NSString *)userId mobile:(NSString *)mobile checkNo:(NSString *)checkNo newLoginPwd:(NSString *)newLoginPwd {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    [paramDict setAllObject:mobile forKey:@"mobile"];
    [paramDict setAllObject:checkNo forKey:@"checkNo"];
    [paramDict setAllObject:[JFMD5Util md532BitUpper:newLoginPwd] forKey:@"newLoginPwd"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJResetLoginPasswordRequestURL];
}


@end

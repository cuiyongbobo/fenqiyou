//
//  JFPullBankInformationBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/12/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFPullBankInformationBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KJPullBankRequestURL = @"/credit/ beforeBindBankCard";

@implementation JFPullBankInformationBuilder


+ (instancetype)sharedPullBank {
    static JFPullBankInformationBuilder *pullBankBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pullBankBuilder = [[JFPullBankInformationBuilder alloc] init];
    });
    return pullBankBuilder;
}

- (void)buildPostData:(NSString *)userId type:(NSString *)type{
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    [paramDict setAllObject:type forKey:@"type"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJPullBankRequestURL];
    
}

@end

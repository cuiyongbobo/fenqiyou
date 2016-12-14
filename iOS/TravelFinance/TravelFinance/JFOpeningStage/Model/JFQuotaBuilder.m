//
//  JFQuotaBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/17.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFQuotaBuilder.h"

#import "NSMutableDictionary+HexDict.h"
#import "JFBaseLibCommon.h"
#import "JFString.h"

static NSString *const KJQuotaRequestURL = @"/credit/getQuota";

@implementation JFQuotaBuilder

+ (instancetype)sharedQuota {
    static JFQuotaBuilder *quotaBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        quotaBuilder = [[JFQuotaBuilder alloc] init];
    });
    return quotaBuilder;
}

- (void)buildPostData:(NSString *)userId  {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJQuotaRequestURL];
}


@end

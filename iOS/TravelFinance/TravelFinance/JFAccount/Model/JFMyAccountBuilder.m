//
//  JFMyAccountBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/18.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFMyAccountBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KJOrderRequestURL = @"/my/center/userCenterIndex";

@implementation JFMyAccountBuilder

+ (instancetype)sharedAccount {
    static JFMyAccountBuilder *accountBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accountBuilder = [[JFMyAccountBuilder alloc] init];
    });
    return accountBuilder;
}

- (void)buildPostData:(NSString *)userId {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJOrderRequestURL];
}

@end

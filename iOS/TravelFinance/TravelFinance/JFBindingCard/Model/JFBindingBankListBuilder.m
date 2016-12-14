//
//  JFBindingBankListBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/11.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBindingBankListBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KbankListRequestURL = @"/user/supportBankCard";

@implementation JFBindingBankListBuilder

+ (instancetype)sharedBankList {
    static JFBindingBankListBuilder *bankListBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bankListBuilder = [[JFBindingBankListBuilder alloc] init];
    });
    return bankListBuilder;
}

- (void)buildPostData  {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KbankListRequestURL];
}


@end

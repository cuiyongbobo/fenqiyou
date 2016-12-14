//
//  JFInvestmentOrderBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/20.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFInvestmentOrderBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KJInvestmentOrderRequestURL = @"/my/center/productOrder";

@implementation JFInvestmentOrderBuilder

+ (instancetype)sharedInvestmentOrder {
    static JFInvestmentOrderBuilder *investmentOrderBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        investmentOrderBuilder = [[JFInvestmentOrderBuilder alloc] init];
    });
    return investmentOrderBuilder;
}


- (void)buildPostData:(NSString *)userId orderStateType:(NSString *)orderStateType {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    [paramDict setAllObject:orderStateType forKey:@"orderStateType"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJInvestmentOrderRequestURL];
    
}


@end

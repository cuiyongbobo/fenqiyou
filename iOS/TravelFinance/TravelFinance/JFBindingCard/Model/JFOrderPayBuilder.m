//
//  JFOrderPayBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/10.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFOrderPayBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KJorderPayRequestURL = @"/order/orderAndPay";

@implementation JFOrderPayBuilder


+ (instancetype)sharedOrderPay {
    static JFOrderPayBuilder *orderBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        orderBuilder = [[JFOrderPayBuilder alloc] init];
    });
    return orderBuilder;
}

- (void)buildPostData:(NSString *)userId orderType:(NSString *)orderType tuanNo:(NSString *)tuanNo tuanId:(NSString *)tuanId stageOrFinancialId:(NSString *)stageOrFinancialId peerName:(NSString *)peerName peerIdCard:(NSString *)peerIdCard peerMobile:(NSString *)peerMobile contactName:(NSString *)contactName contactTel:(NSString *)contactTel couponId:(NSString *)couponId recommendMobile:(NSString *) recommendMobile selfMobile:(NSString *)selfMobile {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    [paramDict setAllObject:orderType forKey:@"payType"];
    [paramDict setAllObject:tuanNo forKey:@"tuanNo"];
    [paramDict setAllObject:tuanId forKey:@"tuanId"];
    [paramDict setAllObject:stageOrFinancialId forKey:@"stageOrFinancialId"];
    
    [paramDict setAllObject:peerName forKey:@"peerName"];
    [paramDict setAllObject:peerIdCard forKey:@"peerIdCard"];
    [paramDict setAllObject:peerMobile forKey:@"peerMobile"];
    [paramDict setAllObject:contactName forKey:@"contactName"];
    
    [paramDict setAllObject:contactTel forKey:@"contactTel"];
    [paramDict setAllObject:couponId forKey:@"couponId"];
    [paramDict setAllObject:recommendMobile forKey:@"recommendMobile"];
    [paramDict setAllObject:selfMobile forKey:@"selfMobile"];
    
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJorderPayRequestURL];
}


@end

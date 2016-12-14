//
//  JFSubmitOrderBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/7.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFSubmitOrderBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KJOrderRequestURL = @"/credit/validateForStep";

@implementation JFSubmitOrderBuilder


+ (instancetype)sharedOrder {
    static JFSubmitOrderBuilder *orderBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        orderBuilder = [[JFSubmitOrderBuilder alloc] init];
    });
    return orderBuilder;
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

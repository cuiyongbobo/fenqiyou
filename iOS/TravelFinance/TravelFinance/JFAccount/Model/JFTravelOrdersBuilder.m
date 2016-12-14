//
//  JFTravelOrdersBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/18.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFTravelOrdersBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KJTravelOrderRequestURL = @"/my/center/tripOrder";

@implementation JFTravelOrdersBuilder

+ (instancetype)sharedTravelOrder {
    static JFTravelOrdersBuilder *travelOrderBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        travelOrderBuilder = [[JFTravelOrdersBuilder alloc] init];
    });
    return travelOrderBuilder;
}


- (void)buildPostData:(NSString *)userId orderStateType:(NSString *)orderStateType {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    [paramDict setAllObject:orderStateType forKey:@"orderStateType"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJTravelOrderRequestURL];
}


@end

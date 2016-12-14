//
//  JFOpeningStageCreditBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/17.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFOpeningStageCreditBuilder.h"

#import "NSMutableDictionary+HexDict.h"
#import "JFBaseLibCommon.h"
#import "JFString.h"

static NSString *const KJOpeningStageRequestURL = @"/credit/creditCard";

@implementation JFOpeningStageCreditBuilder

+ (instancetype)sharedOpeningStage {
    static JFOpeningStageCreditBuilder *openingStageBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        openingStageBuilder = [[JFOpeningStageCreditBuilder alloc] init];
    });
    return openingStageBuilder;
}

- (void)buildPostData:(NSString *)userId creditCardNo:(NSString *)creditCardNo  {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    [paramDict setAllObject:creditCardNo forKey:@"creditCardNo"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJOpeningStageRequestURL];
}


@end

//
//  JFTravelPersonBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/10.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFTravelPersonBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KTravelPersonRequestURL = @"/credit/peopleAuth";

@implementation JFTravelPersonBuilder

+ (instancetype)sharedTravelPerson {
    static JFTravelPersonBuilder *travelPersonBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        travelPersonBuilder = [[JFTravelPersonBuilder alloc] init];
    });
    return travelPersonBuilder;
}

- (void)buildPostData:(NSString *)userId realName:(NSString *)realName idCardNo:(NSString *)idCardNo validateBlack:(NSString *)validateBlack isSelf:(NSString *)isSelf type:(NSString *)type {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    [paramDict setAllObject:realName forKey:@"realName"];
    [paramDict setAllObject:idCardNo forKey:@"idCardNo"];
    [paramDict setAllObject:validateBlack forKey:@"validateBlack"];
    [paramDict setAllObject:isSelf forKey:@"isSelf"];
    [paramDict setAllObject:type forKey:@"type"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KTravelPersonRequestURL];
}


@end

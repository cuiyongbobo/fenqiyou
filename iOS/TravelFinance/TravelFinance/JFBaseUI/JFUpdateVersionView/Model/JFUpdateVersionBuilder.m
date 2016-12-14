//
//  JFUpdateVersionBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/25.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFUpdateVersionBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KJUpdateVerisonRequestURL = @"/version/checkVersion";


@implementation JFUpdateVersionBuilder

+ (instancetype)sharedUpdateVersion {
    static JFUpdateVersionBuilder *updateVersionBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        updateVersionBuilder = [[JFUpdateVersionBuilder alloc] init];
    });
    return updateVersionBuilder;
}

- (void)buildPostData {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJUpdateVerisonRequestURL];
}


@end

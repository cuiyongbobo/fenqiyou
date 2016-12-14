//
//  JFPersonalInformationBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/21.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFPersonalInformationBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KJPersonInformationRequestURL = @"/user/userInfo";

@implementation JFPersonalInformationBuilder

+ (instancetype)sharedPersonalInformation {
    static JFPersonalInformationBuilder *personInformationBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        personInformationBuilder = [[JFPersonalInformationBuilder alloc] init];
    });
    return personInformationBuilder;
}

- (void)buildPostData:(NSString *)userId {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJPersonInformationRequestURL];
}


@end

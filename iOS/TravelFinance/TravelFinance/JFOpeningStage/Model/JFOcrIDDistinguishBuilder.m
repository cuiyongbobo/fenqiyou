//
//  JFOcrIDDistinguishBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/12/20.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFOcrIDDistinguishBuilder.h"

#import "NSMutableDictionary+HexDict.h"
#import "JFBaseLibCommon.h"
#import "JFString.h"

static NSString *const KJDistingRequestURL = @"http://139.129.237.13/fqy_server/authentication/uploadFile";

@implementation JFOcrIDDistinguishBuilder

+ (instancetype)sharedDisting {
    static JFOcrIDDistinguishBuilder *distingBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        distingBuilder = [[JFOcrIDDistinguishBuilder alloc] init];
    });
    return distingBuilder;
}

- (void)buildPostData:(NSString *)userId type:(NSString *)type dataDict:(NSMutableDictionary *)dataDict  {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    [paramDict setAllObject:type forKey:@"type"];
    [paramDict setAllObject:dataDict[@"frontimage"] forKey:@"idCardA"];
    [paramDict setAllObject:dataDict[@"binedimage"] forKey:@"idCardB"];
    [paramDict setAllObject:dataDict[@"name"] forKey:@"name"];
    [paramDict setAllObject:dataDict[@"gender"] forKey:@"gender"];
    [paramDict setAllObject:dataDict[@"nation"] forKey:@"nation"];
    [paramDict setAllObject:dataDict[@"birth"] forKey:@"birth"];
    [paramDict setAllObject:dataDict[@"address"] forKey:@"address"];
    [paramDict setAllObject:dataDict[@"number"] forKey:@"number"];
    [paramDict setAllObject:dataDict[@"organization"] forKey:@"organization"];
    [paramDict setAllObject:dataDict[@"validityDate"] forKey:@"validityDate"];
    self.postData = paramDict;
    self.requestURL = KJDistingRequestURL;
//    [[JFBaseLibCommon baseURL] stringByAppendingString:KJDistingRequestURL];
}

@end

//
//  JFFaceDetectionBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/12/21.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFFaceDetectionBuilder.h"

#import "NSMutableDictionary+HexDict.h"
#import "JFBaseLibCommon.h"
#import "JFString.h"

static NSString *const KJFaceRequestURL = @"http://139.129.237.13/fqy_server/authentication/uploadFile";


@implementation JFFaceDetectionBuilder

+ (instancetype)sharedFace {
    static JFFaceDetectionBuilder *faceBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        faceBuilder = [[JFFaceDetectionBuilder alloc] init];
    });
    return faceBuilder;
}

- (void)buildPostData:(NSString *)userId type:(NSString *)type dataImageStr:(NSString *)dataImageStr  {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    [paramDict setAllObject:type forKey:@"type"];
    [paramDict setAllObject:dataImageStr forKey:@"faceImg"];
    self.postData = paramDict;
//    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJFaceRequestURL];
    self.requestURL = KJFaceRequestURL;
    
}


@end

//
//  JFStagingTourListBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/31.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFStagingTourListBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KJStagingTourListRequestURL = @"/goods/findChoiceGoodsData";

@implementation JFStagingTourListBuilder

+ (instancetype)sharedStagingTourList {
    static JFStagingTourListBuilder *stagingTourListBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stagingTourListBuilder = [[JFStagingTourListBuilder alloc] init];
    });
    return stagingTourListBuilder;
}

- (void)buildPostData:(NSString *)userId pageNumber:(NSString *)pageNumber total:(NSString *)total {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    [paramDict setAllObject:pageNumber forKey:@"pageNumber"];
    [paramDict setAllObject:total forKey:@"total"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJStagingTourListRequestURL];
    
}


- (void)buildPostData:(NSString *)userId pageNumber:(NSString *)pageNumber {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    [paramDict setAllObject:pageNumber forKey:@"pageNumber"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJStagingTourListRequestURL];
}

@end

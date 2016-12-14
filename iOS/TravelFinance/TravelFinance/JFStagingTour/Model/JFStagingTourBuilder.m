//
//  JFStagingTourBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/31.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFStagingTourBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KJStagingTourRequestURL = @"/index/findIndexData";

@implementation JFStagingTourBuilder

+ (instancetype)sharedStagingTour {
    static JFStagingTourBuilder *stagingTourBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stagingTourBuilder = [[JFStagingTourBuilder alloc] init];
    });
    return stagingTourBuilder;
}

- (void)buildPostData:(NSString *)userId {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJStagingTourRequestURL];
}

@end

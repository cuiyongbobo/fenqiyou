//
//  JFSpecialBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/1.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFSpecialBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KJFSpecialRequestURL = @"/goods/findSubjectGoodsData";

@implementation JFSpecialBuilder

+ (instancetype)sharedSpecialBuilder {
    static JFSpecialBuilder *specialBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        specialBuilder = [[JFSpecialBuilder alloc] init];
    });
    return specialBuilder;
}

- (void)buildPostData:(NSString *)userId subjectId:(NSString *)subjectId pageNumber:(NSString *)pageNumber total:(NSString *)total {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    [paramDict setAllObject:subjectId forKey:@"subjectId"];
    [paramDict setAllObject:pageNumber forKey:@"pageNumber"];
    [paramDict setAllObject:total forKey:@"total"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJFSpecialRequestURL];
    
}


@end

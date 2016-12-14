//
//  JFLineListBuilder.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/1.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFLineListBuilder.h"

#import "JFBaseLibCommon.h"
#import "JFString.h"
#import "NSMutableDictionary+HexDict.h"

static NSString *const KJFFindGoodsRequestURL = @"/goods/findGoodsData";

@implementation JFLineListBuilder


+ (instancetype)sharedLineListBuilder {
    static JFLineListBuilder *lineListBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lineListBuilder = [[JFLineListBuilder alloc] init];
    });
    return lineListBuilder;
}

- (void)buildPostData:(NSString *)userId goodsType:(NSString *)goodsType pageNumber:(NSString *)pageNumber total:(NSString *)total {
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    [paramDict setAllObject:JFKTerminalType forKey:@"terminalType"];
    [paramDict setAllObject:[JFBaseLibCommon appVersion] forKey:@"requestVersion"];
    [paramDict setAllObject:userId forKey:@"userId"];
    [paramDict setAllObject:goodsType forKey:@"goodsType"];
    [paramDict setAllObject:pageNumber forKey:@"pageNumber"];
    [paramDict setAllObject:total forKey:@"total"];
    self.postData = paramDict;
    self.requestURL = [[JFBaseLibCommon baseURL] stringByAppendingString:KJFFindGoodsRequestURL];
    
}


@end

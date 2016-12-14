//
//  JFLoginParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/28.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFLoginParser.h"

@implementation JFLoginParser

+ (instancetype)sharedLoginParser {
    static JFLoginParser *loginParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginParser = [[JFLoginParser alloc] init];
    });
    return loginParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData{
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        //  解析data
        _userId = jsonData[@"userId"];
        _nickName = jsonData[@"nickName"];
        _isReal = jsonData[@"isReal"];
    }
}

@end

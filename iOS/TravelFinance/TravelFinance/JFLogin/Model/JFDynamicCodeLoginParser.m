//
//  JFDynamicCodeLoginParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/28.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFDynamicCodeLoginParser.h"

@implementation JFDynamicCodeLoginParser

+ (instancetype)sharedDynamicLoginParser {
    static JFDynamicCodeLoginParser *dynamicLoginParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dynamicLoginParser = [[JFDynamicCodeLoginParser alloc] init];
    });
    return dynamicLoginParser;
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

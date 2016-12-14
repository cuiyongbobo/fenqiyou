//
//  JFQuotaParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/17.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFQuotaParser.h"

@implementation JFQuotaParser

+ (instancetype)sharedQuotaParser {
    static JFQuotaParser *quotaParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        quotaParser = [[JFQuotaParser alloc] init];
    });
    return quotaParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData {
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        
        self.quota = jsonData[@"quota"];
    }
}


@end

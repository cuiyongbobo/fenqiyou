//
//  JFPullBankInformationParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/12/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFPullBankInformationParser.h"

@implementation JFPullBankInformationParser

+ (instancetype)sharedPullBankParser {
    static JFPullBankInformationParser *pullBankParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pullBankParser = [[JFPullBankInformationParser alloc] init];
    });
    return pullBankParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData {
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        self.dataDictnary = jsonData;
    }
}


@end

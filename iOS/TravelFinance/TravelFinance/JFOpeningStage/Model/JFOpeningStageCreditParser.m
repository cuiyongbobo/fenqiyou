//
//  JFOpeningStageCreditParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/17.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFOpeningStageCreditParser.h"


@implementation JFOpeningStageCreditParser


+ (instancetype)sharedOpeningStageParser {
    static JFOpeningStageCreditParser *opendingStageParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        opendingStageParser = [[JFOpeningStageCreditParser alloc] init];
    });
    return opendingStageParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData {
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        
    }
}


@end

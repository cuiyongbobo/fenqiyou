//
//  JFResetLoginPasswordParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/21.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFResetLoginPasswordParser.h"

@implementation JFResetLoginPasswordParser

+ (instancetype)sharedResetLoginPasswordParser {
    static JFResetLoginPasswordParser *resetLoginpasswordParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        resetLoginpasswordParser = [[JFResetLoginPasswordParser alloc] init];
    });
    return resetLoginpasswordParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData{
    
}

@end

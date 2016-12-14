//
//  JFOrderPayParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/10.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFOrderPayParser.h"

@implementation JFOrderPayParser

+ (instancetype)sharedOrderPayParser {
    static JFOrderPayParser *orderPayParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        orderPayParser = [[JFOrderPayParser alloc] init];
    });
    return orderPayParser;
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

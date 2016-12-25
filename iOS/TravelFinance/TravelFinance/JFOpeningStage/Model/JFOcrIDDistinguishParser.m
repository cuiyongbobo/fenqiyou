//
//  JFOcrIDDistinguishParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/12/20.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFOcrIDDistinguishParser.h"

@implementation JFOcrIDDistinguishParser

+ (instancetype)sharedDistingParser {
    static JFOcrIDDistinguishParser *distingParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        distingParser = [[JFOcrIDDistinguishParser alloc] init];
    });
    return distingParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData {
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        
        self.sourceDictionary = jsonData;
        
    }
}



@end

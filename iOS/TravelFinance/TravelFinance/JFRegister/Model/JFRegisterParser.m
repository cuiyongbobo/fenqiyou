//
//  JFRegisterParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/27.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFRegisterParser.h"

@implementation JFRegisterParser

+ (instancetype)sharedRegisterParser {
    static JFRegisterParser *registerParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        registerParser = [[JFRegisterParser alloc] init];
    });
    return registerParser;
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
        NSLog(@"message = %@",self.message);
        _userId = jsonData[@"userId"];
    }
}

@end

//
//  JFBindingParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/10.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBindingParser.h"

@implementation JFBindingParser

+ (instancetype)sharedBindingParser {
    static JFBindingParser *bindingParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bindingParser = [[JFBindingParser alloc] init];
    });
    return bindingParser;
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

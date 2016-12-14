//
//  JFSesameAuthorizationParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/17.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFSesameAuthorizationParser.h"

@implementation JFSesameAuthorizationParser

+ (instancetype)sharedSesameAuthorization {
    static JFSesameAuthorizationParser *sesameParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sesameParser = [[JFSesameAuthorizationParser alloc] init];
    });
    return sesameParser;
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

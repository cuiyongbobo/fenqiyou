//
//  JFInputPhoneNumberParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/27.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFInputPhoneNumberParser.h"


@implementation JFInputPhoneNumberParser

+ (instancetype)sharedInputPhoneParser {
    static JFInputPhoneNumberParser *inputNumberParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inputNumberParser = [[JFInputPhoneNumberParser alloc] init];
    });
    return inputNumberParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData{
    
    _userType = [[NSString alloc] init];
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        //  解析data
        _isReal = jsonData[@"isReal"];
        if ([jsonData[@"registerFlag"] isEqualToString:@"1"]) {
            _userType = @"oldUser";
        }else if ([jsonData[@"registerFlag"] isEqualToString:@"0"]) {
             _userType = @"newUser";
        }
        NSLog(@"message = %@",self.message);
    }
}

- (NSString *)userType {
    return _userType;
}

@end

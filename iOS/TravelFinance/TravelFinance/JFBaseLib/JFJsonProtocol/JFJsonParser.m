//
//  JFJsonParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/27.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"
#import "JFString.h"

@implementation JFJsonParser

- (id)init{
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)setSourceData:(NSDictionary *)sourceData{
    _sourceData = sourceData;
    
    _code = [_sourceData[@"code"] integerValue];
    _message = _sourceData[@"message"];
    if (_code == [JFKStatusCode integerValue]) {
        id data = _sourceData[@"data"];
        if ([data isKindOfClass:[NSDictionary class]]) {
            [self parseData:data];
        }
    }
}

- (void)parseData:(id)jsonData{
    NSLog(@"....");
}

@end

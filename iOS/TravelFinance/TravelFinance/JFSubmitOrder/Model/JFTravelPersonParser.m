//
//  JFTravelPersonParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/10.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFTravelPersonParser.h"

#import "JFTravelPersonItem.h"

@implementation JFTravelPersonParser

+ (instancetype)sharedTravelPersonParser {
    static JFTravelPersonParser *travelPersonParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        travelPersonParser = [[JFTravelPersonParser alloc] init];
    });
    return travelPersonParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData {
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        
        JFTravelPersonItem *travelPerson = [[JFTravelPersonItem alloc] init];
        travelPerson.isReal = jsonData[@"isReal"];
        travelPerson.isBlack = jsonData[@"isBlack"];
        travelPerson.blackState = jsonData[@"blackState"];
        travelPerson.message = jsonData[@"message"];
        self.travelPerson = travelPerson;
    }
}


@end

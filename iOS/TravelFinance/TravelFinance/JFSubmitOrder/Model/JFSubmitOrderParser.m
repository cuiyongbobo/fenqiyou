//
//  JFSubmitOrderParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/10.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFSubmitOrderParser.h"



@implementation JFSubmitOrderParser

+ (instancetype)sharedOrderParser {
    static JFSubmitOrderParser *orderParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        orderParser = [[JFSubmitOrderParser alloc] init];
    });
    return orderParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData {
 
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        self.personItem = [[JFCreditPersonItem alloc] init];
        
        self.personItem.couponCount = jsonData[@"couponCount"];
        self.personItem.financingStep = jsonData[@"financingStep"];
        self.personItem.idCardNo = jsonData[@"idCardNo"];
        self.personItem.mobile = jsonData[@"mobile"];
        self.personItem.realName = jsonData[@"realName"];
        self.personItem.stageStep = jsonData[@"stageStep"];
    }
}

@end

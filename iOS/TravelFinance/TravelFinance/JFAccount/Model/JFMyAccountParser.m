//
//  JFMyAccountParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/18.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFMyAccountParser.h"

@implementation JFMyAccountParser

+ (instancetype)sharedAccountParser {
    static JFMyAccountParser *accountParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accountParser = [[JFMyAccountParser alloc] init];
    });
    return accountParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData {
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        self.personalCenterItem = [[JFPersonalCenterItem alloc] init];
        self.personalCenterItem.addUpToToday = jsonData[@"addUpToToday"];
        self.personalCenterItem.availableCreditAmount = jsonData[@"availableCreditAmount"];
        self.personalCenterItem.availableScore = jsonData[@"availableScore"];
        self.personalCenterItem.financingStep = jsonData[@"financingStep"];
        self.personalCenterItem.isReal = jsonData[@"isReal"];
        self.personalCenterItem.mobile = jsonData[@"mobile"];
        self.personalCenterItem.nickName = jsonData[@"nickName"];
        self.personalCenterItem.overdueTotalAmount = jsonData[@"overdueTotalAmount"];
        self.personalCenterItem.predictExpire = jsonData[@"predictExpire"];
        self.personalCenterItem.repayment = jsonData[@"repayment"];
        self.personalCenterItem.stageStep = jsonData[@"stageStep"];
        self.personalCenterItem.todayEarnings = jsonData[@"todayEarnings"];
        self.personalCenterItem.toolCreditAmount = jsonData[@"toolCreditAmount"];
        self.personalCenterItem.totalAssets = jsonData[@"totalAssets"];
        self.personalCenterItem.totalScore = jsonData[@"totalScore"];
        self.personalCenterItem.usedScore = jsonData[@"usedScore"];
        self.personalCenterItem.userId = jsonData[@"userId"];
        self.personalCenterItem.userPicurl = jsonData[@"userPicurl"];
        self.personalCenterItem.sex = jsonData[@"sex"];
    }
}


@end

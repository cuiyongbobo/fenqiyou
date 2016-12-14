//
//  JFBindingBankListParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/11.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBindingBankListParser.h"

#import "JFBankListModel.h"

@implementation JFBindingBankListParser

+ (instancetype)sharedbankListParser {
    static JFBindingBankListParser *bankListParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bankListParser = [[JFBindingBankListParser alloc] init];
    });
    return bankListParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData {
    self.BankModelArray = (NSMutableArray<JFBankListModel *> *)[NSMutableArray array];
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        
        NSArray *bankArray =  jsonData[@"bankCardList"];
        
        [bankArray enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            JFBankListModel *bankListModel = [[JFBankListModel alloc] init];
            bankListModel.singleDayLimit = obj[@"singleDayLimit"];
            bankListModel.singleQuota = obj[@"singleQuota"];
            bankListModel.bankName = obj[@"bankName"];
            bankListModel.url = obj[@"url"];
            bankListModel.bankCode = obj[@"bankCode"];
            [self.BankModelArray addObject:bankListModel];
        }];
        
    }
}

@end

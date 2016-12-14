//
//  JFInvestmentOrderParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/20.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFInvestmentOrderParser.h"

@implementation JFInvestmentOrderParser

+ (instancetype)sharedInvestmentOrderParser {
    static JFInvestmentOrderParser *investmentOrderParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        investmentOrderParser = [[JFInvestmentOrderParser alloc] init];
    });
    return investmentOrderParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData {
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        
        self.investmentOrderArray = (NSMutableArray<JFInvestmentOrderItem *> *)[NSMutableArray array];
        NSArray *orderList = jsonData[@"orderList"];
        [orderList enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JFInvestmentOrderItem *investmentOrderItem = [[JFInvestmentOrderItem alloc] init];
            investmentOrderItem.amount = [NSString stringWithFormat:@"%@",obj[@"amount"]];
            investmentOrderItem.expctedEarning =[NSString stringWithFormat:@"%@",obj[@"expctedEarning"]] ;
            investmentOrderItem.goodsProductName = obj[@"goodsProductName"];
            investmentOrderItem.orderNo = obj[@"orderNo"];
            investmentOrderItem.orderUrl = obj[@"orderUrl"];
            investmentOrderItem.redemptionTime = obj[@"redemptionTime"];
            [self.investmentOrderArray addObject:investmentOrderItem];
            
        }];
    }
}


@end

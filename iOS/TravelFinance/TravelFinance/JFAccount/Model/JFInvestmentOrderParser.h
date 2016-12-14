//
//  JFInvestmentOrderParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/20.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

#import "JFInvestmentOrderItem.h"

@interface JFInvestmentOrderParser : JFJsonParser

@property (nonatomic, strong) NSMutableArray<JFInvestmentOrderItem *> *investmentOrderArray;

+ (instancetype)sharedInvestmentOrderParser;

@end

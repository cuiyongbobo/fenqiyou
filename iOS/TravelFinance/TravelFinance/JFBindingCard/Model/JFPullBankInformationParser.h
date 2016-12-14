//
//  JFPullBankInformationParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/12/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

@interface JFPullBankInformationParser : JFJsonParser

@property (nonatomic, strong) NSDictionary *dataDictnary;

+ (instancetype)sharedPullBankParser;

@end

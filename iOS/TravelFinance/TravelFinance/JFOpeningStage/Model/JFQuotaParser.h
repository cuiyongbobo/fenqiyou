//
//  JFQuotaParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/17.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

@interface JFQuotaParser : JFJsonParser

@property (nonatomic, strong) NSString *quota;

+ (instancetype)sharedQuotaParser;

@end

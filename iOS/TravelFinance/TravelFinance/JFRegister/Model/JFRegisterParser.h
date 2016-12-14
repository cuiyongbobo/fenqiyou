//
//  JFRegisterParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/27.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

#import "JFJsonParser.h"

@interface JFRegisterParser : JFJsonParser

@property (nonatomic, copy) NSString *userId;

+ (instancetype)sharedRegisterParser;

@end

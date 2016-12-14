//
//  JFOrderPayParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/10.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

@interface JFOrderPayParser : JFJsonParser

@property (nonatomic, strong) NSDictionary *dataDictnary;

+ (instancetype)sharedOrderPayParser;

@end

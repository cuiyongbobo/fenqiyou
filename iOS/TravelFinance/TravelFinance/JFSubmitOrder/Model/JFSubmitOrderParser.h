//
//  JFSubmitOrderParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/10.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

#import "JFCreditPersonItem.h"

@interface JFSubmitOrderParser : JFJsonParser

@property (nonatomic, strong) JFCreditPersonItem *personItem;

+ (instancetype)sharedOrderParser;

@end

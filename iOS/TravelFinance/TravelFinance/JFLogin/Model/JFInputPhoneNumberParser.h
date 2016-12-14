//
//  JFInputPhoneNumberParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/27.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JFJsonParser.h"

@interface JFInputPhoneNumberParser : JFJsonParser

@property (nonatomic, copy) NSString *userType;
@property (nonatomic, copy) NSString *isReal;


+ (instancetype)sharedInputPhoneParser;

@end

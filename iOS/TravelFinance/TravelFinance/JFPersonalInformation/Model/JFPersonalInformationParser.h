//
//  JFPersonalInformationParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/21.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

#import "JFPersonalInformationItem.h"

@interface JFPersonalInformationParser : JFJsonParser

@property (nonatomic, strong) JFPersonalInformationItem *personInformationItem;

+ (instancetype)sharedPersonInformationParser;

@end

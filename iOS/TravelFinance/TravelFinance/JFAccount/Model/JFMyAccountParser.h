//
//  JFMyAccountParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/18.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

#import "JFPersonalCenterItem.h"

@interface JFMyAccountParser : JFJsonParser

@property (nonatomic, strong) JFPersonalCenterItem *personalCenterItem;

+ (instancetype)sharedAccountParser;

@end

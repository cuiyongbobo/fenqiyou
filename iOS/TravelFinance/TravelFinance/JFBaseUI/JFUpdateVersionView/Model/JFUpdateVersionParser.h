//
//  JFUpdateVersionParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/25.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

#import "JFUpdateVersionItem.h"

@interface JFUpdateVersionParser : JFJsonParser

@property (nonatomic, strong) JFUpdateVersionItem *updateVersionItem;

+ (instancetype)sharedupdateVersionParser;

@end

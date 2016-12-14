//
//  JFTravelPersonParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/10.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

#import "JFTravelPersonItem.h"

@interface JFTravelPersonParser : JFJsonParser

@property (nonatomic, strong) JFTravelPersonItem *travelPerson;

+ (instancetype)sharedTravelPersonParser;

@end

//
//  JFTravelOrdersParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/18.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

#import "JFTravelOrdersItem.h"

@interface JFTravelOrdersParser : JFJsonParser

@property (nonatomic, strong) NSMutableArray<JFTravelOrdersItem *> *travelOrderArray;

+ (instancetype)sharedTravelOrderParser;

@end

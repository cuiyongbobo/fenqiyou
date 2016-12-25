//
//  JFOcrIDDistinguishParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/12/20.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

@interface JFOcrIDDistinguishParser : JFJsonParser

@property (nonatomic, strong) NSMutableDictionary *sourceDictionary;

+ (instancetype)sharedDistingParser;

@end

//
//  JFFaceDetectionParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/12/21.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

@interface JFFaceDetectionParser : JFJsonParser

@property (nonatomic, strong) NSMutableDictionary *sourceDictionary;

+ (instancetype)sharedFaceParser;

@end

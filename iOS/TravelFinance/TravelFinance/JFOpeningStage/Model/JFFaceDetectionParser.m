//
//  JFFaceDetectionParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/12/21.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFFaceDetectionParser.h"

@implementation JFFaceDetectionParser

+ (instancetype)sharedFaceParser {
    static JFFaceDetectionParser *faceParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        faceParser = [[JFFaceDetectionParser alloc] init];
    });
    return faceParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData {
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        
        
    }
}


@end

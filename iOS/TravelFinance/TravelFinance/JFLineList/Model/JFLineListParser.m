//
//  JFLineListParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/1.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFLineListParser.h"

@implementation JFLineListParser

+ (instancetype)sharedLineListParser {
    static JFLineListParser *lineListParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lineListParser = [[JFLineListParser alloc] init];
    });
    return lineListParser;
}

- (id)init {
    self = [super init];
    if (self) {
        //        self.itemList = (NSMutableArray<YKDreamPlanListItem *>*)[NSMutableArray array];
        
    }
    return self;
}

- (void)parseData:(id)jsonData{
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        //  解析data
        
        NSLog(@"message = %@",self.message);
    }
}

@end

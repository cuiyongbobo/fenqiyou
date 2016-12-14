//
//  JFSpecialParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/1.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFSpecialParser.h"

@implementation JFSpecialParser

+ (instancetype)sharedSpecialParser {
    static JFSpecialParser *specialParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        specialParser = [[JFSpecialParser alloc] init];
    });
    return specialParser;
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

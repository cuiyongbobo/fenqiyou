//
//  JFTravelOrdersParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/18.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFTravelOrdersParser.h"

@implementation JFTravelOrdersParser


+ (instancetype)sharedTravelOrderParser {
    static JFTravelOrdersParser *travelOrderParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        travelOrderParser = [[JFTravelOrdersParser alloc] init];
    });
    return travelOrderParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData {
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        
        self.travelOrderArray = (NSMutableArray<JFTravelOrdersItem *> *)[NSMutableArray array];
        NSArray *orderList = jsonData[@"orderList"];
        
        [orderList enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JFTravelOrdersItem *travelOrderItem = [[JFTravelOrdersItem alloc] init];
            travelOrderItem.ctDate = obj[@"ctDate"];
            travelOrderItem.goodsAmount =[NSString stringWithFormat:@"%@",obj[@"goodsAmount"]] ;
            travelOrderItem.goodsDistributor = obj[@"goodsDistributor"];
            travelOrderItem.goodsName = obj[@"goodsName"];
            travelOrderItem.orderNo = obj[@"orderNo"];
            travelOrderItem.orderUrl = obj[@"orderUrl"];
            [self.travelOrderArray addObject:travelOrderItem];
            
        }];
    }
}



@end

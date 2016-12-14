//
//  JFInvestmentOrderBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/20.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFInvestmentOrderBuilder : NSObject


@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedInvestmentOrder;

- (void)buildPostData:(NSString *)userId orderStateType:(NSString *)orderStateType;

@end

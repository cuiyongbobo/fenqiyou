//
//  JFTravelOrdersBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/18.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFTravelOrdersBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedTravelOrder;

- (void)buildPostData:(NSString *)userId orderStateType:(NSString *)orderStateType;

@end

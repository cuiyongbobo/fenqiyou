//
//  JFQuotaBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/17.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFQuotaBuilder : NSObject


@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedQuota;

- (void)buildPostData:(NSString *)userId;

@end

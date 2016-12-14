//
//  JFOrderPayBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/10.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFOrderPayBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedOrderPay;

- (void)buildPostData:(NSString *)userId orderType:(NSString *)orderType tuanNo:(NSString *)tuanNo tuanId:(NSString *)tuanId stageOrFinancialId:(NSString *)stageOrFinancialId peerName:(NSString *)peerName peerIdCard:(NSString *)peerIdCard peerMobile:(NSString *)peerMobile contactName:(NSString *)contactName contactTel:(NSString *)contactTel couponId:(NSString *)couponId recommendMobile:(NSString *) recommendMobile selfMobile:(NSString *)selfMobile;


@end

//
//  JFPullBankInformationBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/12/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFPullBankInformationBuilder : NSObject


@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedPullBank;

- (void)buildPostData:(NSString *)userId type:(NSString *)type;

@end

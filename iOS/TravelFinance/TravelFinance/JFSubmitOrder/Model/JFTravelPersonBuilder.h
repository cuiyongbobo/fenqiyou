//
//  JFTravelPersonBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/10.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFTravelPersonBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedTravelPerson;

- (void)buildPostData:(NSString *)userId realName:(NSString *)realName idCardNo:(NSString *)idCardNo validateBlack:(NSString *)validateBlack isSelf:(NSString *)isSelf type:(NSString *)type;

@end

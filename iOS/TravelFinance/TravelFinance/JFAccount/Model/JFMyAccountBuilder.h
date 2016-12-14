//
//  JFMyAccountBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/18.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFMyAccountBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedAccount;

- (void)buildPostData:(NSString *)userId;

@end

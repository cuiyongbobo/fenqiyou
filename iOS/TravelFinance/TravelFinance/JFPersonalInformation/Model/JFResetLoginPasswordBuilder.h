//
//  JFResetLoginPasswordBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/21.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFResetLoginPasswordBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedResetLoginPassword;

- (void)buildPostData:(NSString *)userId mobile:(NSString *)mobile checkNo:(NSString *)checkNo newLoginPwd:(NSString *)newLoginPwd;

@end

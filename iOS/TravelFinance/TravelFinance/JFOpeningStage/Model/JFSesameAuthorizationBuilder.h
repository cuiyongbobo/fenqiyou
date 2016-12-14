//
//  JFSesameAuthorizationBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/17.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFSesameAuthorizationBuilder : NSObject


@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedSesameAuthorization;

- (void)buildPostData:(NSString *)userId crypto:(NSString *)crypto channel:(NSString *)channel params:(NSString *)params redirectUrl:(NSString *)redirectUrl appId:(NSString *)appId sign:(NSString *) sign;

@end

//
//  JFRegisterBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/27.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFRegisterBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;

+ (instancetype)sharedRegister;

- (void)buildPostData:(NSString *)verificationCode userPassword:(NSString *) password;

@end

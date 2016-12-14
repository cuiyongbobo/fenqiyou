//
//  JFBindingBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/10.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface JFBindingBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedBinding;

- (void)buildPostData:(NSString *)userId type:(NSString *)type bankCardNo:(NSString *)bankCardNo mobile:(NSString *)mobile verificationCode:(NSString *)verificationCode;

@end

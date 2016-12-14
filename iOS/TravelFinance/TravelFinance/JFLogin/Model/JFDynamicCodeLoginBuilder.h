//
//  JFDynamicCodeLoginBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/28.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFDynamicCodeLoginBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedDynamicCodeLogin;

- (void)buildPostData:(NSString *)messageCode;

@end

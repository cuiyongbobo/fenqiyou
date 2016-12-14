//
//  JFInputPhoneNumberBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/26.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface JFInputPhoneNumberBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedInputPhone;

- (void)buildPostData:(NSString *)phoneNumber;

@end

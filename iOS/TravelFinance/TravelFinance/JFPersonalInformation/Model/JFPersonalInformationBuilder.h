//
//  JFPersonalInformationBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/21.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFPersonalInformationBuilder : NSObject


@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedPersonalInformation;

- (void)buildPostData:(NSString *)userId;

@end

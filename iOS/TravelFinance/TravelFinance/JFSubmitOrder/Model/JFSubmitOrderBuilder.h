//
//  JFSubmitOrderBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/7.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFSubmitOrderBuilder : NSObject


@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedOrder;

- (void)buildPostData:(NSString *)userId;

@end

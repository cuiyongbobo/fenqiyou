//
//  JFBindingBankListBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/11.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFBindingBankListBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedBankList;

- (void)buildPostData;

@end

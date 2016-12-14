//
//  JFOpeningStageCreditBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/17.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFOpeningStageCreditBuilder : NSObject


@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedOpeningStage;

- (void)buildPostData:(NSString *)userId creditCardNo:(NSString *)creditCardNo;
;

@end

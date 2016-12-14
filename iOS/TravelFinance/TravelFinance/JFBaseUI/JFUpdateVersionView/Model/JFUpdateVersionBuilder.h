//
//  JFUpdateVersionBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/25.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFUpdateVersionBuilder : NSObject


@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedUpdateVersion;

- (void)buildPostData;

@end

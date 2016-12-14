//
//  JFSpecialBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/1.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFSpecialBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedSpecialBuilder;

- (void)buildPostData:(NSString *)userId subjectId:(NSString *)subjectId pageNumber:(NSString *)pageNumber total:(NSString *)total;

@end

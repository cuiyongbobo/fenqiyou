//
//  JFOcrIDDistinguishBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/12/20.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFOcrIDDistinguishBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedDisting;

- (void)buildPostData:(NSString *)userId type:(NSString *)type dataDict:(NSMutableDictionary *)dataDict;

@end

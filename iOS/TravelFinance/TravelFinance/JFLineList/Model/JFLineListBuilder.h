//
//  JFLineListBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/1.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFLineListBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedLineListBuilder;

- (void)buildPostData:(NSString *)userId goodsType:(NSString *)goodsType pageNumber:(NSString *)pageNumber total:(NSString *)total;

@end

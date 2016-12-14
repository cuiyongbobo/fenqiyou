//
//  JFStagingTourListBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/31.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFStagingTourListBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedStagingTourList;

- (void)buildPostData:(NSString *)userId pageNumber:(NSString *)pageNumber total:(NSString *)total;

@end

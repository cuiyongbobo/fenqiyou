//
//  JFFaceDetectionBuilder.h
//  TravelFinance
//
//  Created by cuiyong on 16/12/21.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFFaceDetectionBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary *postData;
@property (nonatomic, copy)   NSString *requestURL;


+ (instancetype)sharedFace;

- (void)buildPostData:(NSString *)userId type:(NSString *)type dataImageStr:(NSString *)dataImageStr;


@end

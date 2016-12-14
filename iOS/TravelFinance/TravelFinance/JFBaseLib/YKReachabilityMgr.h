//
//  YKReachabilityMgr.h
//  SimpleFinance
//
//  Created by ksnowlv on 15/3/3.
//  Copyright (c) 2015年 yinker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKReachability.h"

@interface YKReachabilityMgr : NSObject

+ (instancetype)sharedReachabilityMgr;

@property (nonatomic, strong) NSString* netType;

- (YKNetworkStatus)currentReachabilityStatus;




@end

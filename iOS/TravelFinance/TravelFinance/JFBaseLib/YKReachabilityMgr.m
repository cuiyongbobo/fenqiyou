//
//  YKReachabilityMgr.m
//  SimpleFinance
//
//  Created by ksnowlv on 15/3/3.
//  Copyright (c) 2015年 yinker. All rights reserved.
//

#import "YKReachabilityMgr.h"



static NSString *const KYKReachabilityURL = @"www.qq.com";
static YKReachabilityMgr *sharedReachabilityMgr = nil;

@interface YKReachabilityMgr ()
@property (nonatomic, strong) YKReachability *reachability;

@end




@implementation YKReachabilityMgr

+ (instancetype)sharedReachabilityMgr{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedReachabilityMgr = [[YKReachabilityMgr alloc] init];
    });
    
    return sharedReachabilityMgr;
}

- (id)init{
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleReachabilityChanged:)
                                                     name: kReachabilityChangedNotification
                                                   object: nil];
        
        
        self.reachability = [YKReachability reachabilityWithHostName:KYKReachabilityURL];
        [_reachability startNotifier];
        
        [self handleReachabilityChanged:nil];
    }
    
    return self;
}

- (void)dealloc{
    [_reachability stopNotifier];
}

- (void)handleReachabilityChanged:(NSNotification *)notification{
    
    switch ([self.reachability currentReachabilityStatus]) {
        case YKNotReachable:{
            self.netType = @"NotReachable";
        }
            break;
        case YKReachableViaWWAN:{
            self.netType = @"2G/3G";
        }
            break;
        case YKReachableViaWiFi:{
            self.netType = @"wifi";
        }
            break;
        default:
            
            break;
    }
}


- (YKNetworkStatus)currentReachabilityStatus{
    return _reachability.currentReachabilityStatus;
}


@end

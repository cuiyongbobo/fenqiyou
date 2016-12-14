//
//  JFUmengMgr.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/25.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFUmengMgr : NSObject

+ (instancetype)sharedUmengMgr;

- (void)configUmengSettings;

@end

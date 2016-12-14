//
//  JFUpdateVersionItem.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/25.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, updateVersionType) {
    LatestVersion,
    UpdatedVersion,
    forceUpdatedVersion,
};

@interface JFUpdateVersionItem : NSObject

@property (nonatomic, strong) NSString *curVersion;
@property (nonatomic, strong) NSString *firstVersion;
@property (nonatomic, strong) NSString *isUpdate;
@property (nonatomic, strong) NSString *downUrl;
@property (nonatomic, strong) NSString *memo;

@end

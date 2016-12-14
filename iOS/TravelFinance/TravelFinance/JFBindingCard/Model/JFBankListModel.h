//
//  JFBankListModel.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/11.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFBankListModel : NSObject

@property (nonatomic, strong) NSString *singleDayLimit;
@property (nonatomic, strong) NSString *singleQuota;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *bankCode;

@end

//
//  JFDynamicCodeLoginParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/28.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

@interface JFDynamicCodeLoginParser : JFJsonParser


@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *isReal;



+ (instancetype)sharedDynamicLoginParser;

@end

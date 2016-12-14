//
//  JFJsonParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/27.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  解析json的数据类，包含头部和业务数据两部分。
 */
@interface JFJsonParser : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSDictionary* sourceData;
@property (nonatomic, strong) NSString *message;


@end

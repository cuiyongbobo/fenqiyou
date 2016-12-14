//
//  JFSesameAuthorizationParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/17.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

@interface JFSesameAuthorizationParser : JFJsonParser

@property (nonatomic, strong) NSDictionary *sourceDictionary;

+ (instancetype)sharedSesameAuthorization;

@end

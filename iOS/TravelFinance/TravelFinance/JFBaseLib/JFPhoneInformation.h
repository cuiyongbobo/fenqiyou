//
//  JFPhoneInformation.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/28.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface JFPhoneInformation : NSObject

+(instancetype)sharedPhoneInformation;

-(NSDictionary *)dataInfo;

@end

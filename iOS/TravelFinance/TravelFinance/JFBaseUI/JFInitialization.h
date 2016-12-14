//
//  JFInitialization.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFTabBarController.h"

@interface JFInitialization : NSObject

+ (JFInitialization *)sharedInitial;

- (JFTabBarController *)loadHomePage;

@end

//
//  NSMutableArray+Hex.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/10.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "NSMutableArray+Hex.h"

@implementation NSMutableArray (Hex)

- (void)addllObject:(id)anObject {
    if (anObject ==nil) {
        [self addObject:@""];
    }else {
        [self addObject:anObject];
    }
    
}
@end

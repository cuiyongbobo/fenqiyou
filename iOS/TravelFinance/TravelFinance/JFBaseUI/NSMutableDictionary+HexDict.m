//
//  NSMutableDictionary+HexDict.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/28.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "NSMutableDictionary+HexDict.h"

@implementation NSMutableDictionary (HexDict)

- (void)setAllObject:(NSObject *)anObject forKey:(NSString *)allKey {
    if (anObject != nil) {
        
        [self setObject:anObject forKey:allKey];
    }else {
        [self setObject:@"" forKey:allKey];
    }
}

@end

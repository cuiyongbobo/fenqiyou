//
//  JFColor.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFColor.h"

#import <CoreGraphics/CoreGraphics.h>

static UIColor *sharedMainColor = nil;

@implementation JFColor

+ (UIColor *)colorWithValue:(NSUInteger)colorValue {
    
    CGFloat red = ((colorValue & 0x00FF0000) >> 16) / 255.0;
    
    CGFloat green = ((colorValue & 0x0000FF00) >> 8) / 255.0;
    
    CGFloat blue = (colorValue & 0x000000FF) / 255.0;
    
    CGFloat alpha = ((colorValue & 0xFF000000) >> 24) / 255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a {
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:a];
}

+ (UIColor *)mainColor {
    
    if (nil == sharedMainColor) {
        sharedMainColor = [JFColor colorWithValue:KYKMainColor];
    }
    
    return sharedMainColor;
}

@end

//
//  UIImage+Custom.m
//  inKer
//
//  Created by 杨志达 on 14-10-23.
//  Copyright (c) 2014年 Zhi Da Yang. All rights reserved.
//

#import "UIImage+Custom.h"
#import "JFMacro.h"

@implementation UIImage (Custom)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color withFrame:(CGRect)frame
{
    CGRect rect = frame;
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*) circleImage:(UIColor *) color withParam:(CGFloat) inset {
    
    UIImage *image = [UIImage imageWithColor:color];
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2);
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    [image drawInRect:rect];
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextStrokePath(context);
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
}

+ (UIImage *)imageWithFileName:(NSString *)fileName
{
    return [UIImage imageWithFileName:fileName ofType:@"png"];
}


+ (UIImage *)imageWithFileName:(NSString *)fileName ofType:(NSString *)ext
{
    NSString *path = nil;
 
    if (SCREEN_320_480)
    {
        path = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
    }
    else if (SCREEN_640_960)
    {
        path = [[NSBundle mainBundle] pathForResource:[fileName stringByAppendingString:@"@2x"] ofType:ext];
    }
    else if (SCREEN_640_1136)
    {
        path = [[NSBundle mainBundle] pathForResource:[fileName stringByAppendingString:@"~1136h"] ofType:ext];
    }
    else if (SCREEN_750_1334)
    {
        path = [[NSBundle mainBundle] pathForResource:[fileName stringByAppendingString:@"~1334h"] ofType:ext];
    }
    else if (SCREEN_1242_2208 || SCREEN_1125_2001)
    //iPhone 6 Plus SCREEN_1125_2201
    {
        path = [[NSBundle mainBundle] pathForResource:[fileName stringByAppendingString:@"~2208h"] ofType:ext];
    }
    
    if (path == nil)
    {
        path = [[NSBundle mainBundle] pathForResource:[fileName stringByAppendingString:@"@2x"] ofType:ext];
    }
    
    return [UIImage imageWithContentsOfFile:path];
}

@end



















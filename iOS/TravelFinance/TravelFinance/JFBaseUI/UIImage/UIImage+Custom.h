//
//  UIImage+Custom.h(通过颜色值创建Image对象)
//  inKer
//
//  Created by 杨志达 on 14-10-23.
//  Copyright (c) 2014年 Zhi Da Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Custom)

/**
 *  获得纯色UIImage对象
 *
 *  @param color 色值
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color withFrame:(CGRect)frame;

+ (UIImage *)circleImage:(UIColor *)color withParam:(CGFloat) inset;

+ (UIImage *)imageWithFileName:(NSString *)fileName;

+ (UIImage *)imageWithFileName:(NSString *)fileName ofType:(NSString *)ext;

@end

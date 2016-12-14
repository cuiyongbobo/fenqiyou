//
//  JFTabBarItemView.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFTabBarItemView.h"

#import <QuartzCore/QuartzCore.h>

@implementation JFTabBarItemView

- (id)initWithFrame:(CGRect)frame andNum:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _number = number;
        [self createUI];
    }
    return self;
}

//创建UIVIew
- (void)createUI{
    self.backgroundColor = [UIColor clearColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-12, 5, 24, 24)];
    [self addSubview:_imageView];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 49-15, self.frame.size.width, 15)];
    _titleLab.font = [UIFont systemFontOfSize:10];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.textColor = [UIColor grayColor];
    [self addSubview:_titleLab];
    
    float width = [self calculation];
    _numberLab = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.frame.size.width+_imageView.frame.origin.x-width/2-5, 3, width, 16)];
    _numberLab.backgroundColor = [UIColor redColor];
    _numberLab.text = [self selectNumbar:_number];
    if (_number == 0) {
        _numberLab.alpha = 0;
    }
    _numberLab.layer.cornerRadius = 8;
    [[_numberLab layer] setMasksToBounds:YES];
    _numberLab.textColor = [UIColor whiteColor];
    _numberLab.textAlignment = NSTextAlignmentCenter;
    // _numberLab.font = [UIFont systemFontOfSize:kCellInfoFont];
    [self addSubview:_numberLab];
}

//选中效果
- (void)selected{
    _imageView.image = self.highLightImage;
}

//普通效果
- (void)noSelect{
    _imageView.image = self.image;
}

//修改未读信息
- (void)UpdateNumber:(int)number{
    if (number==0) {
        _numberLab.alpha=0;
    }else{
        _numberLab.alpha=1;
    }
    _number = number;
    float width = [self calculation];
    _numberLab.frame = CGRectMake(_imageView.frame.size.width+_imageView.frame.origin.x-width/2-5, 3, width, 16);
    NSString * numString = [self selectNumbar:number];
    _numberLab.text = numString;
}

//判断未读取的信息
- (NSString *)selectNumbar:(int)number{
    if(number > 99){
        return @"99+";
    }else if(number == 0){
        _numberLab.alpha=0;
        return @"0";
    }else{
        return [NSString stringWithFormat:@"%d",number];
    }
}

//判断当前的number返回numberLab的宽度
- (float)calculation{
    if(_number/10 <= 0){
        return 16.0;
    }else if (_number/10 > 0 && _number/100 == 0){
        return 22.0;
    }else if (_number/100 > 0){
        return 28.0;
    }else{
        return 0;
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

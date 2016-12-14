//
//  JFTipsWindow.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/28.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFTipsWindow.h"

#import "JFString.h"
#import "JFDevice.h"
#import "JFMacro.h"



@interface JFTipsWindow ()
{
    UIImageView *_tipimageview;
    NSTimer *_myTimer;
}

@end

@implementation JFTipsWindow


+ (instancetype)sharedTipview {
    static JFTipsWindow *tipview=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tipview=[[JFTipsWindow alloc]initWithFrame:CGRectMake([JFDevice screenWidth]/2-230*JFWidthRateScale/2,[JFDevice screenHeight]-100*JFHeightRateScale, 230*JFWidthRateScale, 32*JFHeightRateScale)];
    });
    tipview.backgroundColor=[UIColor clearColor];
    tipview.windowLevel = UIWindowLevelAlert;
    [tipview makeKeyAndVisible];
    return tipview;
}


- (void)HiddenTipView:(BOOL)value viewcontroller:(UIViewController *)viewcontroller tiptext:(NSString *)tiptext backgroundcolor:(backgroundcolor)backgroundcolor {
    
   
    if (_tipimageview == nil) {
        _tipimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,230*JFWidthRateScale,32*JFHeightRateScale)];
        //Tipimageview=[[UIImageView alloc]init];
        //自适应图片宽高比例
        if (tiptext.length>9) {
            
        }else{
            _tipimageview.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    if (!value) {
        if (backgroundcolor==1) {
//            _tipimageview.layer.masksToBounds=YES;
//            _tipimageview.layer.cornerRadius=10.0f; //设置为图片宽度的一半出来为圆形
            _tipimageview.image=[UIImage imageNamed:@"public_tips_black"];
//            _tipimageview.backgroundColor = [UIColor blackColor];
        }else{
            _tipimageview.image=[UIImage imageNamed:@"public_tips_white"];
//            _tipimageview.backgroundColor = [UIColor whiteColor];
        }
        UILabel *label;
        if ([[_tipimageview subviews] count] > 0 ) {
            label = [_tipimageview subviews][0];
        }
        else{
            label=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 230*JFWidthRateScale, 30*JFHeightRateScale)];
            //label.frame=Tipimageview.bounds;
        }
        
        label.text=tiptext;
        label.textAlignment = NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=[[UIColor alloc]initWithRed:255.0 green:255.0 blue:255.0 alpha:1];
        [_tipimageview addSubview:label];
        [self addSubview:_tipimageview];
    }
    if ([_myTimer isValid]) {
        [_myTimer invalidate];
        _myTimer =nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(functonstips) userInfo:nil repeats:NO];
    });
}

-(void)functonstips
{
    [_tipimageview removeFromSuperview];
    _tipimageview=nil;
    self.hidden=YES;
    if ([_myTimer isValid]) {
        [_myTimer invalidate];
        _myTimer =nil;
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

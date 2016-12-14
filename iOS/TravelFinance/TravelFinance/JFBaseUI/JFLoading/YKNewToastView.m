//
//  YKNewToastView.m
//  SimpleFinance
//
//  Created by 刘江涛 on 15/8/4.
//  Copyright (c) 2015年 yinker. All rights reserved.
//

#import "YKNewToastView.h"
//#import "YKFont.h"
//#import "YKColor.h"
#import "UIColor+Hex.h"

static YKNewToastView *_sharedToastView = nil;

@interface YKNewToastView ()

@property (nonatomic, strong) UIImageView *loadingAnimationView;
@property (nonatomic, strong) UIView *whiteBgView;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, assign) BOOL showLoadingAnimationView;
@property (nonatomic, copy) YKNewToastViewCompletionBlock completionBlock;

@end

@implementation YKNewToastView

#pragma mark - 创建
+ (YKNewToastView *)sharedNewToastView
{
    if (nil == _sharedToastView) {
        _sharedToastView = [[self alloc] initWithFrame:CGRectZero];
    }
    
    return _sharedToastView;
}

+ (YKNewToastView *)sharedNewToastViewWithText:(NSString*)text
{
    YKNewToastView *newToastView =  [YKNewToastView sharedNewToastView];
    [newToastView hide];
    newToastView.textLabel.text = text;
    newToastView.showLoadingAnimationView = YES;
    return newToastView;
}

+ (YKNewToastView *)newToastViewWithText:(NSString *)text {
    
    YKNewToastView *newToastView = [[self alloc] initWithFrame:CGRectZero];
    newToastView.textLabel.text = text;
    newToastView.showLoadingAnimationView = YES;
    return newToastView;
}

#pragma mark - 展示
- (void)showInView:(UIView *)view
{
    if (view == self)
    {
        return;
    }
    
    [self hide];
    
    self.frame = view.bounds;
    [view addSubview:self];
    
    [self layoutView];
}

- (void)showInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
{
    [self showInView:view];
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay + 1.0];
}

- (void)showInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay completion:(void (^)(BOOL finished))completion
{
    [self showInView:view];
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay + 1.0];
    
    self.completionBlock = completion;
}

#pragma mark - 隐藏销毁
- (void)hide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self removeFromSuperview];
    
    if (self.completionBlock) {
        self.completionBlock(YES);
    }
}

#pragma mark - 调整
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.whiteBgView = [[UIView alloc] init];
        self.whiteBgView.backgroundColor = [UIColor whiteColor];
        self.whiteBgView.alpha = 1;
        [self addSubview:self.whiteBgView];
        
        NSMutableArray *imageList = [NSMutableArray array];
        for (int i = 1; i < 12; ++i) {
            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_animation_%d",i]];
            [imageList addObject:image];
        }
        self.loadingAnimationView = [[UIImageView alloc] init];
        self.loadingAnimationView.animationImages = imageList;
        self.loadingAnimationView.animationDuration = 0.6;
        [self addSubview:self.loadingAnimationView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.textColor = [UIColor colorWithHexString:@"#C1C1C1"];
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutView {
    
    
//    UIViewController *currentController = [self getCurrentVC];
    
//    if (NSStringFromClass(currentController)) {
//        
//        
//    }
    
    self.whiteBgView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height+44);
    
    if (self.showLoadingAnimationView) {
        
//        CGFloat loadingImageViewWidth = 56.0f;
//        CGFloat loadingImageViewHeight = 20.0f;
        
        CGFloat loadingImageViewWidth = 60.0f;
        CGFloat loadingImageViewHeight = 62.5f;
        
        self.loadingAnimationView.hidden = NO;
        self.loadingAnimationView.frame = CGRectMake(0, 0, loadingImageViewWidth, loadingImageViewHeight);
//        self.loadingAnimationView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - 10);
        self.loadingAnimationView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [self.loadingAnimationView startAnimating];
    } else {
        self.loadingAnimationView.hidden = YES;
        [self.loadingAnimationView stopAnimating];
    }
    
    self.textLabel.frame = CGRectMake(0, 0, self.bounds.size.width, 20);
    self.textLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2+49.25);
}


- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


@end

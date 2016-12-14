//
//  YKToastView.m
//  YKNetwork
//
//  Created by kAir on 15/2/23.
//  Copyright (c) 2015年 yinker. All rights reserved.
//

#import "YKToastView.h"
#import "AppDelegate.h"
#import "JFNavigationController.h"
#import "JFColor.h"
#import "UIColor+Hex.h"
#import "JFMacro.h"

static YKToastView *sharedToastView = nil;

@interface YKToastView()

@property (nonatomic, strong) UIView *foregroundView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, assign) BOOL showIndicatorView;
@property (nonatomic, copy) YKToastViewCompletionBlock completionBlock;
@end


@implementation YKToastView

+ (YKToastView *)sharedToastView
{
    if (nil == sharedToastView) {
        sharedToastView = [[self alloc] initWithFrame:CGRectZero];
    }
    
    return sharedToastView;
}

+ (YKToastView *)sharedToastViewWithText:(NSString*)text isTipsBackgrounds:(BOOL)isTipsBackground
{
    YKToastView *toastView =  [YKToastView sharedToastView];
    if (isTipsBackground) {
        toastView.foregroundView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    }else {
        toastView.foregroundView.backgroundColor = [UIColor whiteColor];
    }
    [toastView hide];
    toastView.textLabel.text = text;
    toastView.showIndicatorView = NO;
    return toastView;
}

+ (YKToastView *)sharedToastViewWWithIndicatorAndText:(NSString*)text
{
    YKToastView *toastView =  [YKToastView sharedToastView];
    [toastView hide];
    toastView.textLabel.text = text;
    toastView.showIndicatorView = YES;
    return toastView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.foregroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.foregroundView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin
        | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        self.foregroundView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
        self.foregroundView.layer.masksToBounds = YES;
        self.foregroundView.layer.cornerRadius = 5.0f;
        [self addSubview:self.foregroundView];
        
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicatorView.hidesWhenStopped = YES;
        
        NSMutableArray *imageList = [NSMutableArray array];
        for (int i = 1; i < 12; ++i) {
            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_animation_%d",i]];
            
            [imageList addObject:image];
        }
        self.loadingImageView = [[UIImageView alloc] init];
        self.loadingImageView.animationImages = imageList;
        self.loadingImageView.animationDuration = 0.6;
        [self.foregroundView addSubview:self.loadingImageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.textColor = [UIColor colorWithHexString:@"#a5c7e5"]; // 0xFFcccccc
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:10];
        self.textLabel.numberOfLines = 0;
        [self.foregroundView addSubview:self.textLabel];
    }
    return self;
}


+ (YKToastView *)toastViewWithText:(NSString *)text
{
    YKToastView *toastView = [[self alloc] initWithFrame:CGRectZero];
    toastView.textLabel.text = text;
    return toastView;
}

+ (YKToastView *)toastViewWithIndicatorAndText:(NSString *)text
{
    YKToastView *toastView = [[self alloc] initWithFrame:CGRectZero];
    toastView.textLabel.text = text;
    toastView.showIndicatorView = YES;
    return toastView;
}

- (void)showInView:(UIView *)view
{
    if (view == self)
    {
        return;
    }
    
    [self hide];
    
    CGRect frame = view.bounds;
    frame.origin.y = 0;
    frame.size.height = frame.size.height - frame.origin.y;
    
    self.frame = frame;
    [view addSubview:self];
    
    [self layoutView];
}

- (void)showInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
{
    [self showInView:view];
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay + 1.0];
}

- (void)showInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay completion:(void (^)(BOOL finished))completion{
    [self showInView:view];
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay + 1.0];
    
    self.completionBlock = completion;
}

- (void)hide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self removeFromSuperview];
    
    if (_completionBlock) {
        _completionBlock(YES);
    }
}

- (void)layoutView
{
    CGSize szLabel = CGSizeZero;
    if ([self.textLabel.text length] != 0)
    {
        CGFloat maxLabelWidth = self.bounds.size.width - 2 * 65.0f - 20.0f;
        //        CGFloat maxLabelWidth = self.bounds.size.width - 2 * 65.0f - 65.0f;
        
        if ([self.textLabel.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:self.textLabel.font, NSParagraphStyleAttributeName:paragraphStyle};
            
            szLabel =  [self.textLabel.text boundingRectWithSize:CGSizeMake(maxLabelWidth, 9999.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            szLabel = [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:CGSizeMake(maxLabelWidth, 9999.0f) lineBreakMode:self.textLabel.lineBreakMode];
#pragma clang diagnostic pop
        }
    }
    
    self.textLabel.bounds = (CGRect){CGPointZero, szLabel};
    
    CGFloat width = szLabel.width + 43.0f*JFWidthRateScale;
    CGFloat height = szLabel.height + 43.0f*JFHeightRateScale;
    
    if (self.showIndicatorView)
    {
        
        CGFloat loadingImageViewWidth = 34.5f*JFWidthRateScale;
        CGFloat loadingImageViewHeight = 36.0f*JFHeightRateScale;
        
        width = MAX(width, loadingImageViewWidth + 43.0f*JFWidthRateScale);
        height += loadingImageViewHeight;
        
        self.textLabel.center = CGPointMake(width / 2.0f, height - szLabel.height - 5.0f);
        
        self.loadingImageView.hidden = NO;
        self.loadingImageView.frame = CGRectMake((width-loadingImageViewWidth) / 2.0f, 15.0f, loadingImageViewWidth, loadingImageViewHeight);
        [self.loadingImageView startAnimating];
    }
    else
    {
        self.loadingImageView.hidden = YES;
        [self.loadingImageView stopAnimating];
        self.textLabel.center = CGPointMake(width / 2.0f, height / 2.0f);
    }
    self.foregroundView.frame = CGRectMake((self.bounds.size.width-width) / 2.0f, (self.bounds.size.height-height) / 2.0f, width, height);
}

+ (UIView *)topView
{
    UIViewController *topViewController = nil;
    
    UIViewController *lastController = [[AppDelegate rootNavigationCotroller].viewControllers lastObject];
    if (lastController.presentedViewController) {
        id presentedViewController = lastController.presentedViewController;
        topViewController = presentedViewController;
        if ([presentedViewController isKindOfClass:[JFNavigationController class]]) {
            topViewController = [[(JFNavigationController *)presentedViewController viewControllers] lastObject];
            //暂时判断3层，后期可以循环嵌套
            if (topViewController.presentedViewController) {
                id presentedViewController = topViewController.presentedViewController;
                topViewController = presentedViewController;
                if ([presentedViewController isKindOfClass:[JFNavigationController class]]) {
                    topViewController = [[(JFNavigationController *)presentedViewController viewControllers] lastObject];
                }
            }
            
        }
    }
    else {
        topViewController = lastController;
    }
    
    return topViewController.view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.passthroughTouches)
    {
        return [super pointInside:point withEvent:event];
    }
    
    for (UIView *subview in self.subviews)
    {
        if (subview.isHidden)
        {
            continue;
        }
        
        CGPoint subviewPoint = [self convertPoint:point toView:subview];
        if ([subview pointInside:subviewPoint withEvent:event])
        {
            return YES;
        }
    }
    return NO;
}

@end

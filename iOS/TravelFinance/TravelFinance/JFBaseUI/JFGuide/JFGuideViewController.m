//
//  JFGuideViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/22.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFGuideViewController.h"

#import "UIImage+Custom.h"
#import "JFDevice.h"

@interface JFGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray  *imageArray;
@property (nonatomic, strong) UIButton *startBtn;

@end

@implementation JFGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self mSubviewInit];
}

- (void)mSubviewInit {
    
    CGFloat widthX  = [[UIScreen mainScreen]bounds].size.width;
    CGFloat heightY = [[UIScreen mainScreen] bounds].size.height;
    _imageArray = @[@"guide_0",@"guide_1",@"guide_2",@"guide_3"];
    _guideScrollView.pagingEnabled = YES;
    _guideScrollView.contentSize = CGSizeMake(widthX * _imageArray.count, heightY);
    _guideScrollView.showsHorizontalScrollIndicator = NO;
    _guideScrollView.bounces = NO;
    _guideScrollView.delegate = self;
    _guideScrollView.delaysContentTouches = NO;
    _guideFirstImageView.image = [UIImage imageWithFileName:_imageArray[0] ofType:@"jpg"];
    _guideSecondImageView.image = [UIImage imageWithFileName:_imageArray[1] ofType:@"jpg"];
    _guideThirdImageView.image = [UIImage imageWithFileName:_imageArray[2] ofType:@"jpg"];
    _guideFourthImageView.image = [UIImage imageWithFileName:_imageArray[3] ofType:@"jpg"];
    _guideFourthImageView.userInteractionEnabled = YES;
    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn.frame = CGRectMake(0, [JFDevice screenHeight]/2, [JFDevice screenWidth],[JFDevice screenHeight]/2);
    [_startBtn addTarget:self action:@selector(startBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    _guideFourthImageView.backgroundColor = [UIColor blueColor];
    [_guideFourthImageView addSubview:_startBtn];
}

- (void)startBtn:(UIButton *)sender{
    if (self.guideBlock) {
        [self.view removeFromSuperview];
        self.view = nil;
        self.guideBlock();
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
}


@end

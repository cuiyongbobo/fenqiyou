//
//  MyScrollView.h
//  ScrollViewTest1
//
//  Created by 吕中威 on 16/8/9.
//  Copyright © 2016年 吕中威. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JFBannerScrollViewDelegate<NSObject>

- (void)didSelectBannerView:(NSInteger)index;

@end

@interface MyScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) id<JFBannerScrollViewDelegate> freePlayDelegate;

- (id)initWithFrame:(CGRect)frame imageArr:(NSArray *)imageArr;

@end

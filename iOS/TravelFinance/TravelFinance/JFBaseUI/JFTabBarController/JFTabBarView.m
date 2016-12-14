//
//  JFTabBarView.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFTabBarView.h"

#import "JFTabBarItemView.h"
#import "JFDevice.h"
#import "JFTabBarController.h"
#import "JFColor.h"
#import "JFString.h"


#define kItemsCount 2

@implementation JFTabBarView

- (id)initWithFrame:(CGRect)frame andNum:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _viewArr = [[NSMutableArray alloc] init];
        _number = number;
        [self createUI];
    }
    return self;
}

//创建UIVIew
- (void)createUI{
    
    self.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    
    NSArray *titleArr = @[JFKStagingTour,JFKAccount];
    NSArray *normalImageArray = @[@"main_bottombar_home_normal",@"main_bottombar_account_normal"];
    NSArray *selectImageArray = @[@"main_bottombar_home_selected",@"main_bottombar_account_selected"];
    
    for (int i = 0; i < normalImageArray.count; i++) {
        JFTabBarItemView * itemView;
        if (i == 0) {
            itemView = [[JFTabBarItemView alloc] initWithFrame:CGRectMake([JFDevice screenWidth]/kItemsCount*i, 0, [JFDevice screenWidth]/kItemsCount, self.frame.size.height) andNum:_number];
        }else{
            itemView = [[JFTabBarItemView alloc] initWithFrame:CGRectMake([JFDevice screenWidth]/kItemsCount*i, 0, [JFDevice screenWidth]/kItemsCount, self.frame.size.height) andNum:0];
        }
        
        [self addSubview:itemView];
        if (normalImageArray.count >i && selectImageArray.count > i) {
            itemView.image = [UIImage imageNamed:normalImageArray[i]];
            itemView.highLightImage = [UIImage imageNamed:selectImageArray[i]];
            itemView.titleLab.text = titleArr[i];
        }
        itemView.userInteractionEnabled = YES;
        if (i == 0) {
            [itemView selected];
        }
        else {
            [itemView noSelect];
        }
        [_viewArr addObject:itemView];
    }
}

//修改未读信息
- (void)UpdateNumber:(int)number{
    JFTabBarItemView * item = _viewArr[0];
    [item UpdateNumber:number];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

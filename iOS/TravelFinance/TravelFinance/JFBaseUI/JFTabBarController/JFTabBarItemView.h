//
//  JFTabBarItemView.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFTabBarItemView : UIView

@property (nonatomic,retain) UIImage *image; //有多少个未读的消息
@property (nonatomic,retain) UIImage *highLightImage; //图片
@property (nonatomic,assign) BOOL isSelected; //是否被选择
@property (nonatomic,assign) int number; //有多少个未读的消息
@property (nonatomic,retain) UIImageView * imageView; //图片
@property (nonatomic,retain) UILabel * titleLab; //标题
@property (nonatomic,retain) UILabel * numberLab; //有多少个未读的消息
- (id)initWithFrame:(CGRect)frame andNum:(int)number;
- (void)selected;  //选中效果
- (void)noSelect;  //普通效果
- (void)UpdateNumber:(int)number;  //修改未读信息

@end

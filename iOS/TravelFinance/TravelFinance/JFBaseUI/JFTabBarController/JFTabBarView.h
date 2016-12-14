//
//  JFTabBarView.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFTabBarView : UIView

@property (nonatomic,assign) int number;               //有多少个未读的消息
@property (nonatomic,retain) NSMutableArray * viewArr; //TabberView  里的ItemView 的数组


- (id)initWithFrame:(CGRect)frame andNum:(int)number;
- (void)UpdateNumber:(int)number;                      //修改未读信息

@end

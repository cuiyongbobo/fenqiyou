//
//  JFTravelStageOrdersViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFTravelStageOrdersViewController.h"

#import "JFTravelOrdersTableViewCell.h"
#import "Masonry.h"
#import "JFDevice.h"
#import "UIColor+Hex.h"

@interface JFTravelStageOrdersViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@end

@implementation JFTravelStageOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"分期订单" showRightBtn:NO showLeftBtn:YES currentController:self];
    
    
    [self.waitTravelImageView setHidden:NO];
    [self.TravelImageView setHidden:YES];
    [self.cancelTravelImageView setHidden:YES];
    
    
    
    self.travelScrollView.contentSize = CGSizeMake([JFDevice screenWidth]*3, self.travelScrollView.contentSize.height);
    self.travelScrollView.pagingEnabled = YES;
    self.travelScrollView.userInteractionEnabled = YES;
    self.travelScrollView.bounces = NO;
    self.travelScrollView.showsHorizontalScrollIndicator = NO;
    self.travelScrollView.showsVerticalScrollIndicator = NO;
    self.travelScrollView.delegate =self;
    
    
    self.travelOrdersTableView = [[UITableView alloc] init];
    self.travelOrdersTableView.userInteractionEnabled = YES;
    self.travelOrdersTableView.frame =CGRectMake(0, 0, [JFDevice screenWidth], self.travelScrollView.frame.size.height);
    
    [self.travelScrollView addSubview:self.travelOrdersTableView];
    self.travelOrdersTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.travelOrdersTableView.delegate = self;
    self.travelOrdersTableView.dataSource = self;
    self.travelOrdersTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];;
    
    self.travelTableView = [[UITableView alloc] init];
    self.travelTableView.frame =CGRectMake([JFDevice screenWidth], 0, [JFDevice screenWidth], self.travelScrollView.frame.size.height);
    self.travelTableView.userInteractionEnabled = YES;
    [self.travelScrollView addSubview:self.travelTableView];
    self.travelTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.travelTableView.delegate = self;
    self.travelTableView.dataSource = self;
    self.travelTableView.backgroundColor = [UIColor yellowColor];
    
    self.cancelTravelTableView = [[UITableView alloc] init];
    self.cancelTravelTableView.frame =CGRectMake([JFDevice screenWidth]*2, 0, [JFDevice screenWidth], self.travelScrollView.frame.size.height);
    self.cancelTravelTableView.userInteractionEnabled = YES;
    [self.travelScrollView addSubview:self.cancelTravelTableView];
    self.cancelTravelTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.cancelTravelTableView.delegate = self;
    self.cancelTravelTableView.dataSource = self;
    self.cancelTravelTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    
}

#pragma mark navigation back
- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
}

#pragma mark scroller delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //    NSLog(@"拖动");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSLog(@"拖拽完成");
    NSInteger curIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    NSLog(@"curIndex = %ld",(long)curIndex);
    
    switch (curIndex) {
        case 0:
        {
            [self.waitTravelImageView setHidden:NO];
            [self.TravelImageView setHidden:YES];
            [self.cancelTravelImageView setHidden:YES];
            // 进行 网络请求
            
            
        }
            break;
        case 1:
        {
            [self.waitTravelImageView setHidden:YES];
            [self.TravelImageView setHidden:NO];
            [self.cancelTravelImageView setHidden:YES];
        }
            break;
        case 2:
        {
            [self.waitTravelImageView setHidden:YES];
            [self.TravelImageView setHidden:YES];
            [self.cancelTravelImageView setHidden:NO];
        }
            break;
            
            
        default:
            break;
    }
    
}

#pragma mark tableViewDelegate Even

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identity=@"JFTravelOrdersTableViewCellID";
    JFTravelOrdersTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"JFTravelOrdersTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 119.5;
}

// 设置组的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    //    return 0.1;
    if (section == 0) {
        return 0.1;
    }else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark handle Even

- (IBAction)handleWaitTravel:(id)sender {
    
    // 待出发
    [self.waitTravelImageView setHidden:NO];
    [self.TravelImageView setHidden:YES];
    [self.cancelTravelImageView setHidden:YES];
    self.travelScrollView.contentOffset = CGPointMake(0, 0);
    [self.travelOrdersTableView reloadData];
    
    
}

- (IBAction)handleTravel:(id)sender {
    
    // 已经出发
    [self.waitTravelImageView setHidden:YES];
    [self.TravelImageView setHidden:NO];
    [self.cancelTravelImageView setHidden:YES];
    self.travelScrollView.contentOffset = CGPointMake([JFDevice screenWidth], 0);
    [self.travelTableView reloadData];
}

- (IBAction)handleCancelTravel:(id)sender {
    
    // 取消
    [self.waitTravelImageView setHidden:YES];
    [self.TravelImageView setHidden:YES];
    [self.cancelTravelImageView setHidden:NO];
    self.travelScrollView.contentOffset = CGPointMake([JFDevice screenWidth]*2, 0);
    [self.cancelTravelTableView reloadData];
}
@end

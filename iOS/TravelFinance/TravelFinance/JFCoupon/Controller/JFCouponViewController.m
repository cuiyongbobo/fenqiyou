//
//  JFCouponViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/9.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFCouponViewController.h"

#import "JFCouponTableViewCell.h"

@interface JFCouponViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation JFCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.couponTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.couponTableView.delegate = self;
    self.couponTableView.dataSource = self;
    [self configNavigation:@"优惠券" showRightBtn:NO showLeftBtn:YES currentController:self];
    
    self.dataList = [[NSMutableArray alloc] init];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark navigation back
- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
}

#pragma mark tableViewDelegate Even

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identity=@"JFCouponTableViewCellID";
    JFCouponTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"JFCouponTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}



@end

//
//  JFTravelOrdersViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFTravelOrdersViewController.h"

#import "JFTravelOrdersTableViewCell.h"
#import "Masonry.h"
#import "JFDevice.h"
#import "JFTravelOrdersBuilder.h"
#import "JFTravelOrdersParser.h"
#import "JFNetworkAFN.h"
#import "JFTipsWindow.h"
#import "JFString.h"
#import "JFTravelOrdersItem.h"
#import "JFWebViewController.h"
#import "UIColor+Hex.h"
#import "JFWKWebViewController.h"


@interface JFTravelOrdersViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *travelOrderArray;
@property (nonatomic, strong) NSMutableArray *alreadyTravelOrderArray;
@property (nonatomic, strong) NSMutableArray *cancelTravelOrderArray;

@end

@implementation JFTravelOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"出行订单" showRightBtn:NO showLeftBtn:YES currentController:self];
    
    [self.waitTravelImageView setHidden:NO];
    [self.TravelImageView setHidden:YES];
    [self.cancelTravelImageView setHidden:YES];
    
    self.travelOrderArray = [[NSMutableArray alloc] init];
    self.alreadyTravelOrderArray = [[NSMutableArray alloc] init];
    self.cancelTravelOrderArray = [[NSMutableArray alloc] init];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 请求出行订单
    
    // 请求接口
    // [[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]
    JFTravelOrdersBuilder *travelOrderBuilder = [JFTravelOrdersBuilder sharedTravelOrder];
    [travelOrderBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] orderStateType:@"0"];
    
    [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:travelOrderBuilder.requestURL params:travelOrderBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeTravelOrder;
    
}


#pragma mark responce Evne

- (void)jfURLConnection:(JFNetworkAFN *)jfURLConnection withError:(id)error {
    
    if (error) {
        NSLog(@"error = %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:error backgroundcolor:white];
        });
        
        return;
    }
    switch (jfURLConnection.connectionType) {
        case JFConnectionTypeTravelOrder:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleTravelOrderResponse:responsedict];
            
        }
            break;
        case JFConnectionTypealReadyTravelOrder:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleAlreadyTravelOrderResponse:responsedict];
        }
            break;
        case JFConnectionTypeCancelTravelOrder:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleCancelTravelOrderResponse:responsedict];
            
        }
            break;
            
        default:
            break;
    }
}


- (void)handleTravelOrderResponse:(NSDictionary *)dictionary {
    
    NSLog(@"message=%@",dictionary);
    JFTravelOrdersParser *travelOrderParser = [JFTravelOrdersParser sharedTravelOrderParser];
    travelOrderParser.sourceData = dictionary;
    if (travelOrderParser.code == [JFKStatusCode integerValue]) {
        
        self.travelOrderArray = travelOrderParser.travelOrderArray;
        [self.travelOrdersTableView reloadData];
        if (self.travelOrderArray.count >0) {
            
            [self.travelOrderNoDataView setHidden:YES];
            
        }
        
    }else {
        NSLog(@"errorMessage =%@",travelOrderParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:travelOrderParser.message backgroundcolor:white];
    }
}


- (void)handleAlreadyTravelOrderResponse:(NSDictionary *)dictionary {
    
    NSLog(@"message=%@",dictionary);
    JFTravelOrdersParser *travelOrderParser = [JFTravelOrdersParser sharedTravelOrderParser];
    travelOrderParser.sourceData = dictionary;
    if (travelOrderParser.code == [JFKStatusCode integerValue]) {
        
        self.alreadyTravelOrderArray = travelOrderParser.travelOrderArray;
        [self.travelTableView reloadData];
        
        if (self.alreadyTravelOrderArray.count >0) {
            [self.travelNoDataView setHidden:YES];
        }
        
    }else {
        NSLog(@"errorMessage =%@",travelOrderParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:travelOrderParser.message backgroundcolor:white];
    }
}

- (void)handleCancelTravelOrderResponse:(NSDictionary *)dictionary {
    
    NSLog(@"message=%@",dictionary);
    JFTravelOrdersParser *travelOrderParser = [JFTravelOrdersParser sharedTravelOrderParser];
    travelOrderParser.sourceData = dictionary;
    if (travelOrderParser.code == [JFKStatusCode integerValue]) {
        
        self.cancelTravelOrderArray = travelOrderParser.travelOrderArray;
        [self.cancelTravelTableView reloadData];
        if (self.cancelTravelOrderArray.count >0) {
            [self.cancelTravelNoDataView setHidden:YES];
        }
        
    }else {
        NSLog(@"errorMessage =%@",travelOrderParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:travelOrderParser.message backgroundcolor:white];
    }
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
    
    if (scrollView == self.travelOrdersTableView) {
        NSLog(@"拖拽完成");
        [self.waitTravelImageView setHidden:NO];
        [self.TravelImageView setHidden:YES];
        [self.cancelTravelImageView setHidden:YES];
        
        
    }else if (scrollView == self.travelTableView) {
        [self.waitTravelImageView setHidden:YES];
        [self.TravelImageView setHidden:NO];
        [self.cancelTravelImageView setHidden:YES];
        
        
    }else if (scrollView == self.cancelTravelTableView) {
        [self.waitTravelImageView setHidden:YES];
        [self.TravelImageView setHidden:YES];
        [self.cancelTravelImageView setHidden:NO];
    }else {
        
        NSInteger curIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        NSLog(@"curIndex = %ld",(long)curIndex);
        switch (curIndex) {
            case 0:
            {
                // 待出发
                [self.stayOutButton setTitleColor:[UIColor colorWithHexString:@"3E93F0"] forState:UIControlStateNormal];
                [self.alreadySetOutButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
                [self.alreadycanceledButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
                
                
                [self.waitTravelImageView setHidden:NO];
                [self.TravelImageView setHidden:YES];
                [self.cancelTravelImageView setHidden:YES];
                
            }
                break;
            case 1:
            {
                
                // 已经出发
                
                [self.stayOutButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
                [self.alreadySetOutButton setTitleColor:[UIColor colorWithHexString:@"3E93F0"] forState:UIControlStateNormal];
                [self.alreadycanceledButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
                
                [self.waitTravelImageView setHidden:YES];
                [self.TravelImageView setHidden:NO];
                [self.cancelTravelImageView setHidden:YES];
                
                if (!(self.alreadyTravelOrderArray.count > 0)) {
                    
                    // 请求接口
                    // [[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]
                    JFTravelOrdersBuilder *travelOrderBuilder = [JFTravelOrdersBuilder sharedTravelOrder];
                    [travelOrderBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] orderStateType:@"1"];
                    
                    [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:travelOrderBuilder.requestURL params:travelOrderBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
                    [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypealReadyTravelOrder;
                }
            }
                break;
            case 2:
            {
                // 取消
                [self.stayOutButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
                [self.alreadySetOutButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
                [self.alreadycanceledButton setTitleColor:[UIColor colorWithHexString:@"3E93F0"] forState:UIControlStateNormal];
                
                [self.waitTravelImageView setHidden:YES];
                [self.TravelImageView setHidden:YES];
                [self.cancelTravelImageView setHidden:NO];
                
                if (!(self.cancelTravelOrderArray.count > 0)) {
                    
                    // 请求接口
                    // [[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]
                    JFTravelOrdersBuilder *travelOrderBuilder = [JFTravelOrdersBuilder sharedTravelOrder];
                    [travelOrderBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] orderStateType:@"2"];
                    
                    [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:travelOrderBuilder.requestURL params:travelOrderBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
                    [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeCancelTravelOrder;
                }
            }
                break;
                
                
            default:
                break;
        }
        
    }
    
}

#pragma mark tableViewDelegate Even

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.travelOrdersTableView) {
        
        return self.travelOrderArray.count;
        
    }else if (tableView == self.travelTableView) {
        return self.alreadyTravelOrderArray.count;
        
    }else if (tableView == self.cancelTravelTableView) {
        return self.cancelTravelOrderArray.count;
    }else {
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identity=@"JFTravelOrdersTableViewCellID";
    JFTravelOrdersTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"JFTravelOrdersTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView == self.travelOrdersTableView) {
        
        if (self.travelOrderArray.count > indexPath.row) {
            [cell bindeDataWithViewModel:self.travelOrderArray[indexPath.row]];
        }
    }else if (tableView == self.travelTableView) {
        if (self.alreadyTravelOrderArray.count > indexPath.row) {
            [cell bindeDataWithViewModel:self.alreadyTravelOrderArray[indexPath.row]];
        }
    }else if (tableView == self.cancelTravelTableView) {
        if (self.cancelTravelOrderArray.count > indexPath.row) {
            [cell bindeDataWithViewModel:self.cancelTravelOrderArray[indexPath.row]];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.travelOrdersTableView) {
        
        if (self.travelOrderArray.count > indexPath.row) {
            JFTravelOrdersItem * travelOrderitme = self.travelOrderArray[indexPath.row];
            
            if (SUPPORT_WKWEBVIEW) {
                
                JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                payWebController.requestUrl = travelOrderitme.orderUrl;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
            }else {
                
                JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                payWebController.requestUrl = travelOrderitme.orderUrl;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
            }
        }
    }
    
    if (tableView == self.travelTableView) {
        
        if (self.alreadyTravelOrderArray.count > indexPath.row) {
            JFTravelOrdersItem * travelOrderitme = self.alreadyTravelOrderArray[indexPath.row];
            if (SUPPORT_WKWEBVIEW) {
                JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                payWebController.requestUrl = travelOrderitme.orderUrl;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
                
            }else {
                
                JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                payWebController.requestUrl = travelOrderitme.orderUrl;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
            }
        }
    }
    
    if (tableView == self.cancelTravelTableView) {
        
        if (self.cancelTravelOrderArray.count > indexPath.row) {
            JFTravelOrdersItem * travelOrderitme = self.cancelTravelOrderArray[indexPath.row];
            
            if (SUPPORT_WKWEBVIEW) {
                JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                payWebController.requestUrl = travelOrderitme.orderUrl;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
                
            }else {
                JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                payWebController.requestUrl = travelOrderitme.orderUrl;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
                
            }
        }
    }
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    // if (tableView == self.travelOrdersTableView) {
    UIView *myView = [[UIView alloc]init];
    myView.frame = CGRectMake(0, 0, [JFDevice screenWidth], 35);
    myView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.text = @"市场有风险,投资需谨慎";
    titleLabel.text = @"";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
    titleLabel.frame = CGRectMake(myView.frame.size.width/2-100, 5, 200, 25);
    [myView addSubview:titleLabel];
    return myView;
    //  }
    //   return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 119.5;
}

// 设置组的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

#pragma mark handle Even

- (IBAction)handleWaitTravel:(id)sender {
    
    // 待出发
    [self.stayOutButton setTitleColor:[UIColor colorWithHexString:@"3E93F0"] forState:UIControlStateNormal];
    [self.alreadySetOutButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
    [self.alreadycanceledButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
    
    [self.waitTravelImageView setHidden:NO];
    [self.TravelImageView setHidden:YES];
    [self.cancelTravelImageView setHidden:YES];
    self.travelScrollView.contentOffset = CGPointMake(0, 0);
    [self.travelOrdersTableView reloadData];
    
}

- (IBAction)handleTravel:(id)sender {
    
    // 已经出发
    
    [self.stayOutButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
    [self.alreadySetOutButton setTitleColor:[UIColor colorWithHexString:@"3E93F0"] forState:UIControlStateNormal];
    [self.alreadycanceledButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
    
    
    [self.waitTravelImageView setHidden:YES];
    [self.TravelImageView setHidden:NO];
    [self.cancelTravelImageView setHidden:YES];
    self.travelScrollView.contentOffset = CGPointMake([JFDevice screenWidth], 0);
    [self.travelTableView reloadData];
    
    if (!(self.alreadyTravelOrderArray.count > 0)) {
        // 请求接口
        // [[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]
        JFTravelOrdersBuilder *travelOrderBuilder = [JFTravelOrdersBuilder sharedTravelOrder];
        [travelOrderBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] orderStateType:@"1"];
        
        [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:travelOrderBuilder.requestURL params:travelOrderBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
        [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypealReadyTravelOrder;
    }
    
}

- (IBAction)handleCancelTravel:(id)sender {
    
    // 取消
    
    [self.stayOutButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
    [self.alreadySetOutButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
    [self.alreadycanceledButton setTitleColor:[UIColor colorWithHexString:@"3E93F0"] forState:UIControlStateNormal];
    
    [self.waitTravelImageView setHidden:YES];
    [self.TravelImageView setHidden:YES];
    [self.cancelTravelImageView setHidden:NO];
    self.travelScrollView.contentOffset = CGPointMake([JFDevice screenWidth]*2, 0);
    [self.cancelTravelTableView reloadData];
    
    if (!(self.cancelTravelOrderArray.count > 0)) {
        // 请求接口
        
        // [[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]
        JFTravelOrdersBuilder *travelOrderBuilder = [JFTravelOrdersBuilder sharedTravelOrder];
        [travelOrderBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] orderStateType:@"2"];
        
        [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:travelOrderBuilder.requestURL params:travelOrderBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
        [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeCancelTravelOrder;
    }
    
}


@end

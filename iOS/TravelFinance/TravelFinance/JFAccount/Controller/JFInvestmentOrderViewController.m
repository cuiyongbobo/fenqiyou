//
//  JFInvestmentOrderViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFInvestmentOrderViewController.h"

#import "JFDevice.h"
#import "JFTravelOrdersTableViewCell.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "JFInvestmentOrderBuilder.h"
#import "JFInvestmentOrderParser.h"
#import "JFNetworkAFN.h"
#import "JFTipsWindow.h"
#import "JFString.h"
#import "JFWebViewController.h"
#import "UIColor+Hex.h"
#import "JFInvestmentOrderItem.h"
#import "JFWKWebViewController.h"


@interface JFInvestmentOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *investmentOrderArray;
@property (nonatomic, strong) NSMutableArray *cancelTravelOrderArray;


@end

@implementation JFInvestmentOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"投资订单" showRightBtn:NO showLeftBtn:YES currentController:self];
    
    [self.waitTravelImageView setHidden:NO];
    [self.TravelImageView setHidden:YES];
    
    self.investmentOrderArray = [[NSMutableArray alloc] init];
    self.cancelTravelOrderArray = [[NSMutableArray alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    // 请求接口
    // [[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]
    JFInvestmentOrderBuilder *investmentOrderBuilder = [JFInvestmentOrderBuilder sharedInvestmentOrder];
    [investmentOrderBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] orderStateType:@"0"];
    
    [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:investmentOrderBuilder.requestURL params:investmentOrderBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeInvestmentOrder;
    
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
        case JFConnectionTypeInvestmentOrder:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleTravelOrderResponse:responsedict];
            
        }
            break;
        case JFConnectionTypeInvestmentQuitOrder:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleQuitTravelOrderResponse:responsedict];
            
        }
            break;
        default:
            break;
    }
}

- (void)handleTravelOrderResponse:(NSDictionary *)dictionary {
    
    NSLog(@"message=%@",dictionary);
    JFInvestmentOrderParser *investmentOrderParser = [JFInvestmentOrderParser sharedInvestmentOrderParser];
    investmentOrderParser.sourceData = dictionary;
    if (investmentOrderParser.code == [JFKStatusCode integerValue]) {
        
        self.investmentOrderArray = investmentOrderParser.investmentOrderArray;
        [self.travelOrdersTableView reloadData];
        if (self.investmentOrderArray.count >0) {
            
            [self.travelOrderNoDataView setHidden:YES];
        }
        
    }else {
        NSLog(@"errorMessage =%@",investmentOrderParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:investmentOrderParser.message backgroundcolor:white];
    }
}

- (void)handleQuitTravelOrderResponse:(NSDictionary *)dictionary {
    
    NSLog(@"message=%@",dictionary);
    JFInvestmentOrderParser *investmentOrderParser = [JFInvestmentOrderParser sharedInvestmentOrderParser];
    investmentOrderParser.sourceData = dictionary;
    if (investmentOrderParser.code == [JFKStatusCode integerValue]) {
        
        self.cancelTravelOrderArray = investmentOrderParser.investmentOrderArray;
        [self.travelTableView reloadData];
        if (self.cancelTravelOrderArray.count >0) {
            [self.travelNoDataView setHidden:YES];
        }
        
    }else {
        NSLog(@"errorMessage =%@",investmentOrderParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:investmentOrderParser.message backgroundcolor:white];
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
        //        [self.cancelTravelImageView setHidden:YES];
        
        
    }else if (scrollView == self.travelTableView) {
        [self.waitTravelImageView setHidden:YES];
        [self.TravelImageView setHidden:NO];
        //        [self.cancelTravelImageView setHidden:YES];
        
    }else {
        
        NSInteger curIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        NSLog(@"curIndex = %ld",(long)curIndex);
        switch (curIndex) {
            case 0:
            {
                [self.InpossessionButton setTitleColor:[UIColor colorWithHexString:@"3E93F0"] forState:UIControlStateNormal];
                [self.alreadyquitButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
                
                [self.waitTravelImageView setHidden:NO];
                [self.TravelImageView setHidden:YES];
                
                if (!(self.investmentOrderArray.count > 0)) {
                    
                    // 请求接口
                    // [[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]
                    JFInvestmentOrderBuilder *investmentOrderBuilder = [JFInvestmentOrderBuilder sharedInvestmentOrder];
                    [investmentOrderBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] orderStateType:@"0"];
                    
                    [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:investmentOrderBuilder.requestURL params:investmentOrderBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
                    [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeInvestmentOrder;
                }
                
            }
                break;
            case 1:
            {
                
                [self.InpossessionButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
                [self.alreadyquitButton setTitleColor:[UIColor colorWithHexString:@"3E93F0"] forState:UIControlStateNormal];
                
                [self.waitTravelImageView setHidden:YES];
                [self.TravelImageView setHidden:NO];
                //                [self.cancelTravelImageView setHidden:YES];
                
                if (!(self.cancelTravelOrderArray.count > 0)) {
                    
                    // 请求接口
                    // [[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]
                    JFInvestmentOrderBuilder *investmentOrderBuilder = [JFInvestmentOrderBuilder sharedInvestmentOrder];
                    [investmentOrderBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] orderStateType:@"1"];
                    
                    [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:investmentOrderBuilder.requestURL params:investmentOrderBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
                    [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeInvestmentQuitOrder;
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
        return  self.investmentOrderArray.count;
    }else if (tableView == self.travelTableView) {
        NSLog(@"self.cancelTravelOrderArray %lu",(unsigned long)self.cancelTravelOrderArray.count);
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
        if (self.investmentOrderArray.count > indexPath.row) {
            [cell bindeDataWithInvestmentWithViewModel:self.investmentOrderArray[indexPath.row]];
        }
        
    }else if (tableView == self.travelTableView) {
        if (self.cancelTravelOrderArray.count > indexPath.row) {
            [cell bindeDataWithInvestmentWithViewModel:self.cancelTravelOrderArray[indexPath.row]];
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.travelOrdersTableView) {
        
        if (self.investmentOrderArray.count > indexPath.row) {
            JFInvestmentOrderItem * investmentOrderitem = self.investmentOrderArray[indexPath.row];
            if (SUPPORT_WKWEBVIEW) {
                
                JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                payWebController.requestUrl = investmentOrderitem.orderUrl;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
                
            }else {
                JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                payWebController.requestUrl = investmentOrderitem.orderUrl;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
            }
            
        }
    }
    
    if (tableView == self.travelTableView) {
        
        if (self.cancelTravelOrderArray.count > indexPath.row) {
            JFInvestmentOrderItem * investmentOrderitem = self.cancelTravelOrderArray[indexPath.row];
            
            if (SUPPORT_WKWEBVIEW) {
                
                JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                payWebController.requestUrl = investmentOrderitem.orderUrl;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
            }else {
                JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                payWebController.requestUrl = investmentOrderitem.orderUrl;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 119.5;
}

// 设置组的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    //    return 0.1;
    //    if (section == 0) {
    //        return 0.1;
    //    }else {
    //        return 10;
    //    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    // if (tableView == self.travelOrdersTableView) {
    UIView *myView = [[UIView alloc]init];
    myView.frame = CGRectMake(0, 0, [JFDevice screenWidth], 35);
    myView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"市场有风险,投资需谨慎";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
    titleLabel.frame = CGRectMake(myView.frame.size.width/2-100, 5, 200, 25);
    [myView addSubview:titleLabel];
    return myView;
    //  }
    //   return nil;
}

#pragma mark handle Even

- (IBAction)handleinvestmentHold:(id)sender {
    
    [self.InpossessionButton setTitleColor:[UIColor colorWithHexString:@"3E93F0"] forState:UIControlStateNormal];
    [self.alreadyquitButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
    
    [self.waitTravelImageView setHidden:NO];
    [self.TravelImageView setHidden:YES];
    //    [self.cancelTravelImageView setHidden:YES];
    self.travelScrollView.contentOffset = CGPointMake(0, 0);
    [self.travelOrdersTableView reloadData];
    
}

- (IBAction)handleinvestmentQuit:(id)sender {
    
    // 已经取消
    [self.InpossessionButton setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
    [self.alreadyquitButton setTitleColor:[UIColor colorWithHexString:@"3E93F0"] forState:UIControlStateNormal];
    
    [self.waitTravelImageView setHidden:YES];
    [self.TravelImageView setHidden:NO];
    //    [self.cancelTravelImageView setHidden:YES];
    self.travelScrollView.contentOffset = CGPointMake([JFDevice screenWidth], 0);
    [self.travelTableView reloadData];
    
    if (!(self.cancelTravelOrderArray.count > 0)) {
        // 请求接口
        // [[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]
        JFInvestmentOrderBuilder *investmentOrderBuilder = [JFInvestmentOrderBuilder sharedInvestmentOrder];
        [investmentOrderBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] orderStateType:@"1"];
        
        [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:investmentOrderBuilder.requestURL params:investmentOrderBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
        [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeInvestmentQuitOrder;
    }
    
}
@end

//
//  JFNotLoginMyAccountViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/14.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFNotLoginMyAccountViewController.h"

#import "JFNotLoginMyAccountTableViewCell.h"
#import "JFNotLoginMyAccountInformationTableViewCell.h"
#import "JFInputPhoneNumberViewController.h"
#import "JFNavigationController.h"
#import "AppDelegate.h"
#import "JFBaseTabBarViewController.h"
#import "UMMobClick/MobClick.h"
#import "JFMacro.h"
#import "JFWKWebViewController.h"
#import "JFBaseLibCommon.h"


@interface JFNotLoginMyAccountViewController ()<UITableViewDataSource,UITableViewDelegate,JFBaseTableViewCellDelegate>

@end

@implementation JFNotLoginMyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"" showRightBtn:YES showLeftBtn:NO currentController:self];
    self.notLoginMyAccountTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.notLoginMyAccountTableView.delegate = self;
    self.notLoginMyAccountTableView.dataSource = self;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;    //让rootView禁止滑动
    }
}

#pragma mark navigation back
- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.tbc.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark cell Even

- (void)clickCell:(id)cell tag:(JFTableCellClickType)tag userinfo:(id)userinfo {
    
    switch (tag) {
        case JFTableCellClickTypeLogin: {
            JFInputPhoneNumberViewController *inputNumberController = [[JFInputPhoneNumberViewController alloc] initWithNibName:@"JFInputPhoneNumberViewController" bundle:nil];
            [self.navigationController pushViewController:inputNumberController animated:YES];
        }
            break;
        default:
            break;
    }
    
}


#pragma mark tableViewDelegate Even

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else {
        
        return 2;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identity=@"JFNotLoginMyAccountTableViewCellID";
        JFNotLoginMyAccountTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"JFNotLoginMyAccountTableViewCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else {
        static NSString *identity=@"JFNotLoginMyAccountInformationTableViewCellID";
        JFNotLoginMyAccountInformationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"JFNotLoginMyAccountInformationTableViewCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.activitiesImageView.image = [UIImage imageNamed:@"personalcenter_activitiesLogo"];
        }else if (indexPath.row == 1) {
            cell.activitiesImageView.image = [UIImage imageNamed:@"personalcenter_activitiesLogoSecond"];
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexPath.row =%ld",(long)indexPath.row);
    switch (indexPath.row) {
        case 0:
        {
            [MobClick event:@"mycenter_banner1"];//个人中心未登录页面banner1点击数
            
            JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
            NSString *notLoginBannerRequestURL = [NSString stringWithFormat:@"/app/activityBanner?code=%ld",(long)(indexPath.row+1)];
            
            payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:notLoginBannerRequestURL];
            payWebController.htmlSubmit =NO;
            payWebController.isShowNavigation = YES;
            payWebController.navigationItem.hidesBackButton = YES;
            [self.navigationController pushViewController:payWebController animated:YES];
        }
            break;
        case 1:
        {
            [MobClick event:@"mycenter_banner2"];//个人中心未登录页面banner2点击数
            
            JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
            NSString *notLoginBannerRequestURL = [NSString stringWithFormat:@"/app/activityBanner?code=%ld",(long)(indexPath.row+1)];
            
            payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:notLoginBannerRequestURL];
            payWebController.htmlSubmit =NO;
            payWebController.isShowNavigation = YES;
            payWebController.navigationItem.hidesBackButton = YES;
            [self.navigationController pushViewController:payWebController animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 205*JFHeightRateScale;
    //    if (indexPath.section == 0) {
    //        return (194*JFHeightRateScale);
    //    }else {
    //        return (194*JFHeightRateScale);
    //    }
}

// 设置组的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.1;
    }else {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        return 0.1;
    }else {
        return 0.1;
    }
}


@end

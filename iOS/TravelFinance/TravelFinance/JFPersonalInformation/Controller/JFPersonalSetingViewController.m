//
//  JFPersonalSetingViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/15.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFPersonalSetingViewController.h"

#import "JFPersonalInformationListTableViewCell.h"
#import "JFPersonalRetirementTableViewCell.h"
#import "JFResetLoginPasswordViewController.h"
#import "JFGesturepasswordViewController.h"
#import "JFPersonaGesturepasswordTableViewCell.h"
#import "JFNavigationController.h"
#import "JFString.h"
#import "JFWebViewController.h"
#import "JFBaseLibCommon.h"
#import "AppDelegate.h"
#import "JFWKWebViewController.h"


@interface JFPersonalSetingViewController ()<UITableViewDataSource,UITableViewDelegate,JFBaseTableViewCellDelegate>

@property (nonatomic, strong) NSArray *informationListArray;

@end

@implementation JFPersonalSetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"设置" showRightBtn:NO showLeftBtn:YES currentController:self];
    
    self.personalSetingTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.personalSetingTableView.delegate = self;
    self.personalSetingTableView.dataSource = self;
    self.informationListArray = @[@"登录密码",@"手势密码",@"帮助中心",@"关于我们"];
}


#pragma mark navigation back
- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
}

#pragma mark cell Even

- (void)clickCell:(id)cell tag:(JFTableCellClickType)tag userinfo:(id)userinfo {
    
    switch (tag) {
            
        case JFTableCellClickTypeLoginOut: {
            NSLog(@"安全退出");
            
            // 删除 JFKUserId、gestureFinalSaveKey、JFKSetGesturePassword
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:JFKUserId];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gestureFinalSaveKey"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:JFKSetGesturePassword];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:JFKCreditAuthorization];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:JFKSesameAuthorization];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
            self.navigationController.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES]; // 回到根试图
            
            //            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            //            app.tbc.selectedIndex = 0;
            //            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
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
    
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 4) {
        
        static NSString *identity=@"JFPersonalRetirementTableViewCellID";
        JFPersonalRetirementTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"JFPersonalRetirementTableViewCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
        
    }else {
        
        
        if (indexPath.row != 1) {
            
            static NSString *identity=@"JFPersonalInformationListTableViewCellID";
            JFPersonalInformationListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"JFPersonalInformationListTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.informationListArray.count > indexPath.row) {
                cell.nameLabel.text = self.informationListArray[indexPath.row];
            }
            if (indexPath.row != 1) {
                [cell.realNameLabel setHidden:YES];
            }
            //            if (indexPath.row == 1) {
            //                cell.realNameLabel.text = @"已开启";
            //            }
            return cell;
            
        }else {
            static NSString *identity=@"JFPersonaGesturepasswordTableViewCellID";
            JFPersonaGesturepasswordTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"JFPersonaGesturepasswordTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"gestureFinalSaveKey"]) {
            //                cell.gestursSwitch.enabled = NO;
            //            }
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            // 登录密码
            JFResetLoginPasswordViewController *resetpasswordController = [[JFResetLoginPasswordViewController alloc] initWithNibName:@"JFResetLoginPasswordViewController" bundle:nil];
            [self.navigationController pushViewController:resetpasswordController animated:YES];
        }
            break;
        case 1:
        {
            
            // 手势密码
            //            JFGesturepasswordViewController * gesturepasswordController = [[JFGesturepasswordViewController alloc] initWithNibName:@"JFGesturepasswordViewController" bundle:nil];
            //            [self.navigationController pushViewController:gesturepasswordController animated:YES];
        }
            break;
            
        case 2:
        {
            // 帮助中心
            NSLog(@"帮助中心");
            NSString *helpUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:JFKHelpCenterRequestURL];
            if (SUPPORT_WKWEBVIEW) {
                
                JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                payWebController.requestUrl = helpUrl;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
                
            }else {
                JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                payWebController.requestUrl = helpUrl;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
            }
            
        }
            break;
        case 3:
        {
            // 关于我们
            NSLog(@"关于我们");
            NSString *aboutUsUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:JFKAboutUsRequestURL];
            
            if (SUPPORT_WKWEBVIEW) {
                JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                payWebController.requestUrl = aboutUsUrl;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
                
            }else {
                JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                payWebController.requestUrl = aboutUsUrl;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
            }
            
            
        }
            break;
            
        default:
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) {
        return 115;
    }else {
        return 45;
    }
}

@end

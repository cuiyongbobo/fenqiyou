//
//  JFMyAccountViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/24.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFMyAccountViewController.h"

#import "JFLoginViewController.h"
#import "JFInputPhoneNumberViewController.h"
#import "JFSubmitOrderViewController.h"
#import "JFBindingCardViewController.h"
#import "JFAccountPersonInformationTableViewCell.h"
#import "JFAccountAvailableCreditTableViewCell.h"
#import "JFAccountAvailableCreditInformationTableViewCell.h"
#import "JFNotLoginMyAccountViewController.h"
#import "JFNavigationController.h"
#import "AppDelegate.h"
#import "JFTravelOrdersViewController.h"
#import "JFInvestmentOrderViewController.h"
#import "JFPersonalInformationViewController.h"
#import "JFTravelStageOrdersViewController.h"
#import "JFString.h"
#import "JFOpeningStageRealNameViewController.h"
#import "JFMyAccountBuilder.h"
#import "JFMyAccountParser.h"
#import "JFNetworkAFN.h"
#import "JFTipsWindow.h"
#import "JFWebViewController.h"
#import "JFOpeningStageCertificationInstitutionViewController.h"
#import "JFOpeningStageBindingBankCardViewController.h"
#import "JFPublicLineListViewController.h"
#import "JFPersonalSetingViewController.h"
#import "JFBaseLibCommon.h"
#import "YKUpdateVersionViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "JFWKWebViewController.h"
#import "YKToastView.h"



@interface JFMyAccountViewController ()<UITableViewDataSource,UITableViewDelegate,JFBaseTableViewCellDelegate,JFURLConnectionDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray *availableCreditArray;
@property (nonatomic, strong) NSArray *availableCreditSecondArray;
@property (nonatomic, strong) NSArray *availableCreditLogoArray;
@property (nonatomic, strong) NSArray *availableCreditSecondLogoArray;
@property (nonatomic, strong) NSArray *totalAssetsArray;
@property (nonatomic, strong) NSArray *totalAssetsSecondArray;
@property (nonatomic, strong) NSArray *totalAssetsLogoArray;
@property (nonatomic, strong) NSArray *totalAssetsSecondLogoArray;
@property (nonatomic, strong) JFPersonalCenterItem *personalCenterItem;
@property (nonatomic, strong) NSMutableArray *availableCreditAmountArray;
@property (nonatomic, strong) NSMutableArray *repaymentArray;
@property (nonatomic, strong) NSMutableArray *totalAmountArray;
@property (nonatomic, strong) NSMutableArray *expireAmountArray;
@property (nonatomic, assign) BOOL isclick;
@property (nonatomic, strong) AFNetworkReachabilityManager *manager;


@end

@implementation JFMyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNavigation:@"" showRightBtn:YES showLeftBtn:NO currentController:self];
    
    self.accountTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.accountTableView.delegate = self;
    self.accountTableView.dataSource = self;
    
    _availableCreditArray = @[@"",@"逾期待还",@"未出账单",@"分期订单"];
    _availableCreditSecondArray = @[@"",@"当月应还",@"全部账单",@"立即还款"];
    _availableCreditLogoArray = @[@"",@"personalcenter_overduerepayment",@"personalcenter_notaccount",@"personalcenter_stageorder"];
    _availableCreditSecondLogoArray = @[@"",@"personalcenter_monthlyrepayment",@"personalcenter_allbills",@"personalcenter_immediaterepayment"];
    
    _totalAssetsArray = @[@"总资产(元)",@"累计至今日",@"投资订单"];
    _totalAssetsSecondArray = @[@"总资产(元)",@"预计至到期",@""];
    _totalAssetsLogoArray = @[@"",@"personalcenter_accumulatedincome",@"personalcenter_investmentorder"];
    _totalAssetsSecondLogoArray = @[@"",@"personalcenter_expectedmaturity",@""];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;    //让rootView禁止滑动
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    _isclick = YES;
    
    self.listView.alpha = 0;
    NSLog(@"userID = %@",[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]);
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]) {
        
        JFNotLoginMyAccountViewController *notLgoinViewController = [[JFNotLoginMyAccountViewController alloc] initWithNibName:@"JFNotLoginMyAccountViewController" bundle:nil];
        notLgoinViewController.navigationItem.hidesBackButton = YES;
        [self.navigationController pushViewController:notLgoinViewController animated:YES];
        
    }else {
        
        if ([JFBaseLibCommon checkNetStatusNotReachable]) {
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:KYKNetErrorMessage backgroundcolor:white];
            return;
        }
        
        YKToastView *toastView = [YKToastView sharedToastViewWWithIndicatorAndText:JFKLoadingMessage];
        [toastView showInView:self.view];
        
        // 请求 个人中心接口
        JFMyAccountBuilder *accountBuilder = [JFMyAccountBuilder sharedAccount];
        [accountBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
        
        [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:accountBuilder.requestURL params:accountBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
        [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypePersonalCenter;
    }
    
    ///  分享代码
    //        self.shareVC = [[YKShareViewController alloc] init];
    //        self.shareVC.params = @{};
    //        [[UIApplication sharedApplication].keyWindow addSubview:self.shareVC.view];
    //        [self.shareVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.top.equalTo(self.shareVC.view.superview).with.offset(0);
    //            make.left.equalTo(self.shareVC.view.superview).with.offset(0);
    //            make.bottom.equalTo(self.shareVC.view.superview).with.offset(0);
    //            make.right.equalTo(self.shareVC.view.superview).with.offset(0);
    //        }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController viewWillAppear:animated];
    //    if (!navigationController) {
    //        [viewController viewWillAppear:animated];
    //    }
}

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    [viewController viewDidAppear:animated];
//}

#pragma mark navigation back
- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
}


- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
    if (_isclick) {
        _isclick = NO;
        self.listView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.listView.alpha = 0;
        [self.view addSubview:self.listView];
        
        [UIView animateWithDuration:0.1f animations:^{
            self.listView.transform = CGAffineTransformMakeScale(1, 1);
            self.listView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        
    }else {
        _isclick = YES;
        self.listView.transform = CGAffineTransformMakeScale(1, 1);
        self.listView.alpha = 1;
        [UIView animateWithDuration:0.1f animations:^{
            self.listView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.listView.alpha = 0;
        } completion:^(BOOL finished) {
            // [self removeFromSuperview];
        }];
    }
}


#pragma mark responce Evne

- (void)jfURLConnection:(JFNetworkAFN *)jfURLConnection withError:(id)error {
    
    if (error) {
        
        [[YKToastView sharedToastView] hide];
        NSLog(@"error = %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:error backgroundcolor:white];
        });
        
        return;
    }
    switch (jfURLConnection.connectionType) {
        case JFConnectionTypePersonalCenter:
        {
            [[YKToastView sharedToastView] hide];
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handlePersonalCenterResponse:responsedict];
            
        }
            break;
            
        default:
            break;
    }
}


- (void)handlePersonalCenterResponse:(NSDictionary *)dictionary {
    
    NSLog(@"message=%@",dictionary);
    JFMyAccountParser *accountParser = [JFMyAccountParser sharedAccountParser];
    accountParser.sourceData = dictionary;
    if (accountParser.code == [JFKStatusCode integerValue]) {
        self.personalCenterItem = accountParser.personalCenterItem;
        if (self.personalCenterItem.sex) {
            [[NSUserDefaults standardUserDefaults] setObject:self.personalCenterItem.sex forKey:JFKSexSave];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        _availableCreditAmountArray = [[NSMutableArray alloc] init];
        _repaymentArray = [[NSMutableArray alloc]init];
        _totalAmountArray = [[NSMutableArray alloc] init];
        _expireAmountArray = [[NSMutableArray alloc] init];
        
        NSLog(@"repayment %@",self.personalCenterItem.repayment);
        // section2
        [_availableCreditAmountArray addObject:@""];
        // 逾期还款
        [_availableCreditAmountArray addObject:self.personalCenterItem.overdueTotalAmount];
        // 未出账单
        [_availableCreditAmountArray addObject:@""];
        // 分期账单
        [_availableCreditAmountArray addObject:@""];
        
        
        [_repaymentArray addObject:@""];
        [_repaymentArray addObject:self.personalCenterItem.repayment];
        [_repaymentArray addObject:@""];
        [_repaymentArray addObject:@""];
        
        
        // section3
        [_totalAmountArray addObject:@""];
        // 累计至今日
        [_totalAmountArray addObject:self.personalCenterItem.addUpToToday];
        // 投资订单
        [_totalAmountArray addObject:@""];
        
        [_expireAmountArray addObject:@""];
        [_expireAmountArray addObject:self.personalCenterItem.predictExpire];
        [_expireAmountArray addObject:@""];
        
        [self.accountTableView reloadData];
        
    }else {
        NSLog(@"errorMessage =%@",accountParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:accountParser.message backgroundcolor:white];
    }
}

#pragma mark cell Even

- (void)clickCell:(id)cell tag:(JFTableCellClickType)tag userinfo:(id)userinfo {
    
    switch (tag) {
        case JFTableCellClickTypeMyHeader: {
            // 点击头像
            JFPersonalInformationViewController *personInformaton = [[JFPersonalInformationViewController alloc] initWithNibName:@"JFPersonalInformationViewController" bundle:nil];
            [self.navigationController pushViewController:personInformaton animated:YES];
            
        }
            break;
        case JFTableCellClickTypeTravelOrder:
        {
            JFTravelOrdersViewController *travelOrderController = [[JFTravelOrdersViewController alloc] initWithNibName:@"JFTravelOrdersViewController" bundle:nil];
            [self.navigationController pushViewController:travelOrderController animated:YES];
            
        }
            break;
            
        case JFTableCellClickTypeCardVolume:
        {
            // 我的卡劵
            
            if (SUPPORT_WKWEBVIEW) {
                
                JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                NSString *StageOrderRequestURL = [NSString stringWithFormat:@"/app/coupon?userId=%@",[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
                payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:StageOrderRequestURL];
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
                
            }else {
                JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                NSString *StageOrderRequestURL = [NSString stringWithFormat:@"/app/coupon?userId=%@",[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
                payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:StageOrderRequestURL];
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
            }
            
        }
            break;
            
            
        case JFTableCellClickTypeleftLogo:
        {
            NSIndexPath *indexPath = (NSIndexPath *)userinfo;
            
            switch (indexPath.section) {
                case 0:
                {
                    NSLog(@"投资订单");
                }
                    break;
                case 1:
                {
                    if (indexPath.row == 3) {
                        NSLog(@"分期订单");
                        
                        if (SUPPORT_WKWEBVIEW) {
                            JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                            NSString *StageOrderRequestURL = [NSString stringWithFormat:@"/app/appBill?userId=%@&fqCode=5",[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
                            payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:StageOrderRequestURL];
                            
                            payWebController.htmlSubmit =NO;
                            payWebController.isShowNavigation = YES;
                            payWebController.navigationItem.hidesBackButton = YES;
                            [self.navigationController pushViewController:payWebController animated:YES];
                            
                        }else {
                            JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                            NSString *StageOrderRequestURL = [NSString stringWithFormat:@"/app/appBill?userId=%@&fqCode=5",[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
                            payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:StageOrderRequestURL];
                            
                            payWebController.htmlSubmit =NO;
                            payWebController.isShowNavigation = YES;
                            payWebController.navigationItem.hidesBackButton = YES;
                            [self.navigationController pushViewController:payWebController animated:YES];
                        }
                        
                        
                        
                        
                    }else if (indexPath.row == 1) {
                        NSLog(@"逾期还款");
                        // 走h5
                        if (SUPPORT_WKWEBVIEW) {
                            JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                            NSString *OverdueRepaymentRequestURL = [NSString stringWithFormat:@"/app/appBill?userId=%@&fqCode=1",[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
                            payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:OverdueRepaymentRequestURL];
                            payWebController.htmlSubmit =NO;
                            payWebController.isShowNavigation = YES;
                            payWebController.navigationItem.hidesBackButton = YES;
                            [self.navigationController pushViewController:payWebController animated:YES];
                            
                        }else {
                            JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                            NSString *OverdueRepaymentRequestURL = [NSString stringWithFormat:@"/app/appBill?userId=%@&fqCode=1",[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
                            payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:OverdueRepaymentRequestURL];
                            payWebController.htmlSubmit =NO;
                            payWebController.isShowNavigation = YES;
                            payWebController.navigationItem.hidesBackButton = YES;
                            [self.navigationController pushViewController:payWebController animated:YES];
                            
                        }
                        
                        
                        
                    }else if (indexPath.row == 2){
                        NSLog(@"未出账单");
                        if (SUPPORT_WKWEBVIEW) {
                            
                            JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                            NSString *NoBillsRequestURL = [NSString stringWithFormat:@"/app/appBill?userId=%@&fqCode=3",[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
                            
                            payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:NoBillsRequestURL];
                            payWebController.htmlSubmit =NO;
                            payWebController.isShowNavigation = YES;
                            payWebController.navigationItem.hidesBackButton = YES;
                            [self.navigationController pushViewController:payWebController animated:YES];
                            
                        }else {
                            JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                            NSString *NoBillsRequestURL = [NSString stringWithFormat:@"/app/appBill?userId=%@&fqCode=3",[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
                            
                            payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:NoBillsRequestURL];
                            payWebController.htmlSubmit =NO;
                            payWebController.isShowNavigation = YES;
                            payWebController.navigationItem.hidesBackButton = YES;
                            [self.navigationController pushViewController:payWebController animated:YES];
                            
                        }
                        
                    }
                    
                }
                    break;
                case 2:
                {
                    if (indexPath.row == 2) {
                        NSLog(@"投资订单");
                        JFInvestmentOrderViewController *investmentController = [[JFInvestmentOrderViewController alloc] initWithNibName:@"JFInvestmentOrderViewController" bundle:nil];
                        [self.navigationController pushViewController:investmentController animated:YES];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case JFTableCellClickTyperightLogo:
        {
            NSIndexPath *indexPath = (NSIndexPath *)userinfo;
            switch (indexPath.section) {
                case 0:
                {
                    NSLog(@"投资订单");
                }
                    break;
                case 1:
                {
                    if (indexPath.row == 1) {
                        NSLog(@"当月还款");
                        
                        if (SUPPORT_WKWEBVIEW) {
                            
                            JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                            NSString *MonthlyRepaymentRequestURL = [NSString stringWithFormat:@"/app/appBill?userId=%@&fqCode=2",[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
                            payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:MonthlyRepaymentRequestURL];
                            payWebController.htmlSubmit =NO;
                            payWebController.isShowNavigation = YES;
                            payWebController.navigationItem.hidesBackButton = YES;
                            [self.navigationController pushViewController:payWebController animated:YES];
                        }else {
                            JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                            NSString *MonthlyRepaymentRequestURL = [NSString stringWithFormat:@"/app/appBill?userId=%@&fqCode=2",[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
                            payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:MonthlyRepaymentRequestURL];
                            payWebController.htmlSubmit =NO;
                            payWebController.isShowNavigation = YES;
                            payWebController.navigationItem.hidesBackButton = YES;
                            [self.navigationController pushViewController:payWebController animated:YES];
                        }
                        
                        
                    }else if (indexPath.row == 2) {
                        NSLog(@"全部账单");
                        // 走h5
                        if (SUPPORT_WKWEBVIEW) {
                            
                            JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                            NSString *AllBillsRequestURL = [NSString stringWithFormat:@"/app/appBill?userId=%@&fqCode=4",[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
                            
                            payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:AllBillsRequestURL];
                            payWebController.htmlSubmit =NO;
                            payWebController.isShowNavigation = YES;
                            payWebController.navigationItem.hidesBackButton = YES;
                            [self.navigationController pushViewController:payWebController animated:YES];
                        }else {
                            JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                            NSString *AllBillsRequestURL = [NSString stringWithFormat:@"/app/appBill?userId=%@&fqCode=4",[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
                            
                            payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:AllBillsRequestURL];
                            payWebController.htmlSubmit =NO;
                            payWebController.isShowNavigation = YES;
                            payWebController.navigationItem.hidesBackButton = YES;
                            [self.navigationController pushViewController:payWebController animated:YES];
                            
                        }
                        
                        
                    }else if (indexPath.row == 3){
                        NSLog(@"立即还款");
                        if (SUPPORT_WKWEBVIEW) {
                            
                            JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                            NSString *ImmediateRepaymentRequestURL = [NSString stringWithFormat:@"/app/appBill?userId=%@&fqCode=6",[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
                            payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:ImmediateRepaymentRequestURL];
                            payWebController.htmlSubmit =NO;
                            payWebController.isShowNavigation = YES;
                            payWebController.navigationItem.hidesBackButton = YES;
                            [self.navigationController pushViewController:payWebController animated:YES];
                        }else {
                            JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                            NSString *ImmediateRepaymentRequestURL = [NSString stringWithFormat:@"/app/appBill?userId=%@&fqCode=6",[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
                            payWebController.requestUrl = [[JFBaseLibCommon baseH5URL] stringByAppendingString:ImmediateRepaymentRequestURL];
                            payWebController.htmlSubmit =NO;
                            payWebController.isShowNavigation = YES;
                            payWebController.navigationItem.hidesBackButton = YES;
                            [self.navigationController pushViewController:payWebController animated:YES];
                            
                        }
                        
                    }
                }
                    break;
                case 2:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case JFTableCellClickTypeOpenFinancial:
        {
            
            NSIndexPath *indexPath = (NSIndexPath *)userinfo;
            switch (indexPath.section) {
                case 1:
                {
                    // 分期
                    NSLog(@"分期");
                    if ([self.personalCenterItem.stageStep integerValue] == 0) {
                        NSLog(@"实名认证");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            JFOpeningStageRealNameViewController *realNameController = [[JFOpeningStageRealNameViewController alloc] initWithNibName:@"JFOpeningStageRealNameViewController" bundle:nil];
                            [self.navigationController pushViewController:realNameController animated:YES];
                        });
                        
                        
                    }else if([self.personalCenterItem.stageStep integerValue] == 1) {
                        NSLog(@"去认证机构");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            JFOpeningStageCertificationInstitutionViewController *bindingBankController = [[JFOpeningStageCertificationInstitutionViewController alloc] initWithNibName:@"JFOpeningStageCertificationInstitutionViewController" bundle:nil];
                            [self.navigationController pushViewController:bindingBankController animated:YES];
                            
                        });
                        
                    }else if ([self.personalCenterItem.stageStep integerValue] == 2) {
                        NSLog(@"去绑卡");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            JFOpeningStageBindingBankCardViewController *bindingBankCardController = [[JFOpeningStageBindingBankCardViewController alloc] initWithNibName:@"JFOpeningStageBindingBankCardViewController" bundle:nil];
                            [self.navigationController pushViewController:bindingBankCardController animated:YES];
                        });
                        
                    }else if ([self.personalCenterItem.stageStep integerValue] == 10) {
                        
                        // 去分期列表
                        JFPublicLineListViewController *lineListController = [[JFPublicLineListViewController alloc] initWithNibName:@"JFPublicLineListViewController" bundle:nil];
                        lineListController.lineTag = @"FQ";
                        [self.navigationController pushViewController:lineListController animated:YES];
                    }
                    
                }
                    break;
                    
                case 2:
                {
                    // 理财
                    NSLog(@"理财");
                    JFPublicLineListViewController *lineListController = [[JFPublicLineListViewController alloc] initWithNibName:@"JFPublicLineListViewController" bundle:nil];
                    lineListController.lineTag = @"BW";
                    [self.navigationController pushViewController:lineListController animated:YES];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark handle Even

- (IBAction)handleSetup:(id)sender {
    
    NSLog(@"设置");
    // 设置
    JFPersonalSetingViewController *personSetController = [[JFPersonalSetingViewController alloc] initWithNibName:@"JFPersonalSetingViewController" bundle:nil];
    [self.navigationController pushViewController:personSetController animated:YES];
}

- (IBAction)handleHelpCenter:(id)sender {
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _isclick = YES;
    self.listView.alpha = 0;
}

#pragma mark tableViewDelegate Even

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 4;
        }
            break;
        case 2:
        {
            return 3;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *identity=@"JFAccountPersonInformationTableViewCellID";
            JFAccountPersonInformationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"JFAccountPersonInformationTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            switch ([self.personalCenterItem.sex integerValue]) {
                case 0:
                {
                    [cell.headerButton setBackgroundImage:[UIImage imageNamed:@"personalcenter_head_unknown"] forState:UIControlStateNormal];
                }
                    break;
                case 1:
                {
                    [cell.headerButton setBackgroundImage:[UIImage imageNamed:@"personalcenter_head"] forState:UIControlStateNormal];
                }
                    break;
                case 2:
                {
                    [cell.headerButton setBackgroundImage:[UIImage imageNamed:@"personalcenter_head_female"] forState:UIControlStateNormal];
                }
                    break;
                    
                default:
                    break;
            }
            
            [cell bindeDataWithViewModel:self.personalCenterItem viewModelList:nil];
            cell.delegate = self;
            return cell;
            
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                
                static NSString *identity=@"JFAccountAvailableCreditTableViewCellID";
                JFAccountAvailableCreditTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
                if (cell==nil) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"JFAccountAvailableCreditTableViewCell" owner:self options:nil]lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (_availableCreditArray.count > indexPath.row) {
                    
                    cell.availableCreditTitleLabel.text = _availableCreditArray[indexPath.row];
                }
                if ([self.personalCenterItem.stageStep integerValue] == 10) {
                    cell.productTypeLabel.text = @"去分期";
                }else {
                    cell.productTypeLabel.text = @"去开通";
                }
                
                cell.availableCreditTitleLabel.text = @"可用额度(元)";
                cell.availableCreditLabel.text = [NSString stringWithFormat:@"%@",self.personalCenterItem.availableCreditAmount];
                cell.totalAmountLabel.text = [NSString stringWithFormat:@"总额度%@",self.personalCenterItem.toolCreditAmount];
                
                cell.delegate = self;
                [cell bindeDataWithViewModel:indexPath List:nil];
                return cell;
                
                
            }else {
                
                static NSString *identity=@"JFAccountAvailableCreditInformationTableViewCellID";
                JFAccountAvailableCreditInformationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
                if (cell==nil) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"JFAccountAvailableCreditInformationTableViewCell" owner:self options:nil]lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (_availableCreditArray.count > indexPath.row) {
                    
                    cell.overdueRepaymentTitleLabel.text = _availableCreditArray[indexPath.row];
                    cell.monthlyRepaymentTitleLabel.text = _availableCreditSecondArray[indexPath.row];
                    cell.overdueRepaymentImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_availableCreditLogoArray[indexPath.row]]];
                    cell.monthlyRepaymentImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_availableCreditSecondLogoArray[indexPath.row]]];
                    
                    if (_availableCreditAmountArray.count > indexPath.row) {
                        cell.overdueRepaymentLabel.text = _availableCreditAmountArray[indexPath.row];
                        cell.monthlyRepaymentLabel.text = _repaymentArray[indexPath.row];
                    }
                }
                cell.delegate = self;
                [cell bindeDataWithViewModel:indexPath List:nil];
                return cell;
            }
            
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                
                static NSString *identity=@"JFAccountAvailableCreditTableViewCellID";
                JFAccountAvailableCreditTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
                if (cell==nil) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"JFAccountAvailableCreditTableViewCell" owner:self options:nil]lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (_totalAssetsArray.count >indexPath.row) {
                    cell.availableCreditTitleLabel.text = _totalAssetsArray[indexPath.row];
                }
                cell.productTypeLabel.text = @"去白玩";
                cell.availableCreditLabel.text = self.personalCenterItem.totalAssets;
                cell.totalAmountLabel.text = [NSString stringWithFormat:@"今日收益%@",self.personalCenterItem.todayEarnings];
                
                cell.delegate = self;
                [cell bindeDataWithViewModel:indexPath List:nil];
                return cell;
                
            }else {
                
                static NSString *identity=@"JFAccountAvailableCreditInformationTableViewCellID";
                JFAccountAvailableCreditInformationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
                if (cell==nil) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"JFAccountAvailableCreditInformationTableViewCell" owner:self options:nil]lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (_totalAssetsArray.count >0) {
                    
                    cell.overdueRepaymentTitleLabel.text = _totalAssetsArray[indexPath.row];
                    cell.overdueRepaymentImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_totalAssetsLogoArray[indexPath.row]]];
                    
                    cell.monthlyRepaymentTitleLabel.text = _totalAssetsSecondArray[indexPath.row];
                    cell.monthlyRepaymentImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_totalAssetsSecondLogoArray[indexPath.row]]];
                    
                    if (_totalAmountArray.count > indexPath.row) {
                        cell.overdueRepaymentLabel.text = _totalAmountArray[indexPath.row];
                        cell.monthlyRepaymentLabel.text = _expireAmountArray[indexPath.row];
                    }
                }
                if (indexPath.row == 2) {
                    [cell.monthlyRepaymentTitleLabel setHidden:YES];
                    [cell.monthlyRepaymentLabel setHidden:YES];
                    [cell.monthlyRepaymentImageView setHidden:YES];
                }
                
                cell.delegate = self;
                [cell bindeDataWithViewModel:indexPath List:nil];
                
                return cell;
            }
            
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    switch (indexPath.section) {
    //        case 1:
    //        {
    //            if (indexPath.row == 0) {
    //                NSLog(@"开通");
    //            }
    //        }
    //            break;
    //            case 2:
    //        {
    //            if (indexPath.row == 0) {
    //                NSLog(@"开通");
    //            }
    //        }
    //
    //        default:
    //            break;
    //    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            
            return 182.5;
            
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                
                return 83;
            }else {
                return 54;
            }
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                
                return 83;
            }else {
                return 54;
            }
        }
            break;
            
            
        default:
            break;
    }
    return 0;
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



@end

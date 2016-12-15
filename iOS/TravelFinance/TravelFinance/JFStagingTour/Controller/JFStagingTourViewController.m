//
//  JFStagingTourViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/24.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFStagingTourViewController.h"

#import "UIColor+Hex.h"
#import "JFDevice.h"
#import "stagingTourBannerTableViewCell.h"
#import "JFstagingTourBystagesTableViewCell.h"
#import "JFstagingTourSpecialTableViewCell.h"
#import "JFstagingTourplayFreeTableViewCell.h"
#import "JFstagingTourplayRecommendedTableViewCell.h"
#import "JFstagingTourRecommendedListTableViewCell.h"
#import "JFStagingTourBuilder.h"
#import "JFNetworkAFN.h"
#import "JFString.h"
#import "JFTipsWindow.h"
#import "JFStagingTourListBuilder.h"
#import "JFStagingTourfqGoodsItem.h"
#import "JFStagingTourParser.h"
#import "JFStagingTourListParser.h"
#import "JFStagingTourBannerItem.h"
#import "MJRefresh.h"
#import "JFPublicLineListViewController.h"
#import "JFWebViewController.h"
#import "JFStagingTourfqGoodsItem.h"
#import "JFSubmitOrderViewController.h"
#import "GestureViewController.h"
#import "YKUpdateVersionViewController.h"
#import "AppDelegate.h"
#import "JFUpdateVersionBuilder.h"
#import "JFUpdateVersionParser.h"
#import "UMMobClick/MobClick.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "JFWKWebViewController.h"
#import "JFMacro.h"
#import "YKReachability.h"
#import "YKReachabilityMgr.h"
#import "JFBaseLibCommon.h"
#import "YKToastView.h"



@interface JFStagingTourViewController ()<UITableViewDataSource,UITableViewDelegate,JFURLConnectionDelegate,JFBaseTableViewCellDelegate>

@property (nonatomic,strong) JFStagingTourfqGoodsItem *fqGoodsItem;
@property (nonatomic,strong) NSMutableArray *bannerItemArrayList;
@property (nonatomic,strong) NSMutableArray *subjectItemArrayList;
@property (nonatomic,strong) NSMutableArray *bwItemArrayList;
@property (nonatomic,strong) NSMutableArray *stagingTourSelectItemArrayList;
@property (nonatomic,assign) NSInteger pageNumberTag;
@property (nonatomic,strong) NSString *pageSize;
@property (nonatomic,strong) NSString *numberTotal;
@property (nonatomic, strong) JFUpdateVersionItem *updateVersionItem;
@property (nonatomic, strong) AFNetworkReachabilityManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *stagingTourMainTableView;

@end

@implementation JFStagingTourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stagingTourMainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.stagingTourMainTableView setBackgroundColor:[UIColor colorWithHexString:@"#f8f8f8"]];
    self.stagingTourMainTableView.delegate = self;
    self.stagingTourMainTableView.dataSource = self;
    
    CGRect frame = CGRectMake(0, 0, 0, 0.1);
    self.stagingTourMainTableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
    
    self.bannerItemArrayList = [[NSMutableArray alloc] init];
    self.subjectItemArrayList = [[NSMutableArray alloc] init];
    self.bwItemArrayList = [[NSMutableArray alloc] init];
    self.stagingTourSelectItemArrayList = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    self.stagingTourMainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            [self loadMoreData];
        }
    }];
    
    //在刷新数据覆盖不显示数据的 cell 的分割线,如果不设置,则会显示 cell 的分割线
    //            UIView *footView = [UIView new];
    //            self.stagingTourMainTableView.tableFooterView = footView;
    
    self.pageNumberTag = 1;
    
    // 首页
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:JFKSetGesturePassword] isEqualToString:@"开启"]) {
        GestureViewController *gestureLockViewController = [[GestureViewController alloc] init];
        gestureLockViewController.type = GestureViewControllerTypeLogin;
        [self presentViewController:gestureLockViewController animated:NO completion:nil];
    }else {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:JFKUserId]) {
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"gestureFinalSaveKey"]) {
                GestureViewController *gestureLockViewController = [[GestureViewController alloc] init];
                gestureLockViewController.type = GestureViewControllerTypeSetting;
                [self presentViewController:gestureLockViewController animated:NO completion:nil];
            }
        }
    }
    
}

- (void)updateVersonfunc {
    // 请求 更新接口
    JFUpdateVersionBuilder *updateVersionBuilder = [JFUpdateVersionBuilder sharedUpdateVersion];
    [updateVersionBuilder buildPostData];
    
    [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:updateVersionBuilder.requestURL params:updateVersionBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeUpdateVersion;
}

- (void)loadMoreData {
    
    self.stagingTourMainTableView.mj_footer.hidden = YES;
    
    if ([JFBaseLibCommon checkNetStatusNotReachable]) {
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:KYKNetErrorMessage backgroundcolor:white];
        return;
    }
    //1, 获取数据源
    if ([self.pageSize integerValue] > self.pageNumberTag) {
        self.pageNumberTag = self.pageNumberTag+1;
        // 精选
        JFStagingTourListBuilder *stagingTourListBuilder = [JFStagingTourListBuilder sharedStagingTourList];
        
        [stagingTourListBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] pageNumber:[NSString stringWithFormat:@"%ld",(long)self.pageNumberTag] total:self.numberTotal];
        
        JFNetworkAFN *afnets = [[JFNetworkAFN alloc] init];
        [afnets requestHttpDataWithPath:stagingTourListBuilder.requestURL params:stagingTourListBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
        afnets.connectionType = JFConnectionTypestagingTourList;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.bannerItemArrayList = [[NSMutableArray alloc] init];
    self.subjectItemArrayList = [[NSMutableArray alloc] init];
    self.bwItemArrayList = [[NSMutableArray alloc] init];
    self.stagingTourSelectItemArrayList = [[NSMutableArray alloc] init];
    self.stagingTourSelectItemArrayList = [[NSMutableArray alloc] init];
    self.pageNumberTag = 1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if ([JFBaseLibCommon checkNetStatusNotReachable]) {
        
        
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:KYKNetErrorMessage backgroundcolor:white];
        return;
    }
    //    [self updateVersonfunc];
    
    YKToastView *toastView = [YKToastView sharedToastViewWWithIndicatorAndText:JFKLoadingMessage];
    [toastView showInView:self.view];
    
    
    // 首页数据
    JFStagingTourBuilder *stagingTourBuilder = [JFStagingTourBuilder sharedStagingTour];
    [stagingTourBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
    
    JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
    [afnet requestHttpDataWithPath:stagingTourBuilder.requestURL params:stagingTourBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    afnet.connectionType = JFConnectionTypestagingTour;
    
    
    // 精选
    JFStagingTourListBuilder *stagingTourListBuilder = [JFStagingTourListBuilder sharedStagingTourList];
    
    [stagingTourListBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] pageNumber:[NSString stringWithFormat:@"%ld",(long)self.pageNumberTag] total:@"0"];
    
    JFNetworkAFN *afnets = [[JFNetworkAFN alloc] init];
    [afnets requestHttpDataWithPath:stagingTourListBuilder.requestURL params:stagingTourListBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    afnets.connectionType = JFConnectionTypestagingTourList;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;    //让rootView禁止滑动
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark responce Evne

- (void)jfURLConnection:(JFNetworkAFN *)jfURLConnection withError:(id)error {
    
    if (self.stagingTourMainTableView.mj_footer.isRefreshing) {
        [self.stagingTourMainTableView.mj_footer endRefreshing];
    }
    if (error) {
        [[YKToastView sharedToastView] hide];
        NSLog(@"error = %@",error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:error backgroundcolor:white];
        });
        return;
    }
    //3,关闭刷新
    //    [self.stagingTourMainTableView.mj_footer endRefreshing];
    switch (jfURLConnection.connectionType) {
            
        case JFConnectionTypestagingTour:
        {
            
            [[YKToastView sharedToastView] hide];
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handlestagingTourResponse:responsedict];
        }
            break;
        case JFConnectionTypestagingTourList:
        {
            
            
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            
            [self handlestagingTourListResponse:responsedict];
        }
            break;
        case JFConnectionTypeUpdateVersion:
        {
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
    JFUpdateVersionParser *updateVersionParser = [JFUpdateVersionParser sharedupdateVersionParser];
    updateVersionParser.sourceData = dictionary;
    if (updateVersionParser.code == [JFKStatusCode integerValue]) {
        
        self.updateVersionItem = updateVersionParser.updateVersionItem;
        
        switch ([self.updateVersionItem.isUpdate integerValue]) {
            case LatestVersion:
            {
                // 最新
            }
                break;
            case UpdatedVersion:
            case forceUpdatedVersion:
            {
                // 强制更新
                
                self.versionController = [[YKUpdateVersionViewController alloc] init];
                self.versionController.updateVersionItem = self.updateVersionItem;
                [[UIApplication sharedApplication].keyWindow addSubview:self.versionController.view];
                [self.versionController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.versionController.view.superview).with.offset(0);
                    make.left.equalTo(self.versionController.view.superview).with.offset(0);
                    make.bottom.equalTo(self.versionController.view.superview).with.offset(0);
                    make.right.equalTo(self.versionController.view.superview).with.offset(0);
                }];
                //                UIWindow *window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
                //                AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
                //                YKUpdateVersionViewController *versionController = [[YKUpdateVersionViewController alloc] initWithNibName:@"YKUpdateVersionViewController" bundle:nil];
                //                versionController.updateVersionItem = self.updateVersionItem;
                //                versionController.view.frame = app.ykBaseViewController.view.frame;
                //                window.rootViewController = versionController;
            }
                break;
            default:
                break;
        }
        
        
        
    }else {
        
        NSLog(@"errorMessage =%@",updateVersionParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:updateVersionParser.message backgroundcolor:white];
    }
}


- (void)handlestagingTourResponse:(NSDictionary *)dictionary {

    NSLog(@"dic =%@",dictionary);
    JFStagingTourParser *stagingTourParser = [JFStagingTourParser sharedStagingTourParser];
    stagingTourParser.sourceData = dictionary;
    if (stagingTourParser.code == [JFKStatusCode integerValue]) {
        self.bannerItemArrayList = stagingTourParser.bannerItemArrayList;
        self.subjectItemArrayList = stagingTourParser.subjectItemArrayList;
        self.bwItemArrayList = stagingTourParser.bwItemArrayList;
        self.fqGoodsItem = stagingTourParser.fqGoodsItem;
        [self.stagingTourMainTableView reloadData];
        
    }else {
        NSLog(@"errorMessage =%@",stagingTourParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:stagingTourParser.message backgroundcolor:white];
    }
}

- (void)handlestagingTourListResponse:(NSDictionary *)dictionary {
    NSLog(@"dic =%@",dictionary);
    self.stagingTourMainTableView.mj_footer.hidden = NO;
    self.stagingTourMainTableView.mj_footer.state = MJRefreshStateIdle;
    
    JFStagingTourListParser *stagingTourListParser = [JFStagingTourListParser sharedStagingTourListParser];
    stagingTourListParser.sourceData = dictionary;
    if (stagingTourListParser.code == [JFKStatusCode integerValue]) {
        self.numberTotal = stagingTourListParser.numberTotal;
        self.pageSize = stagingTourListParser.pageSize;
        [stagingTourListParser.stagingTourSelectItemArrayList enumerateObjectsUsingBlock:^(JFStagingTourfqGoodsItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.stagingTourSelectItemArrayList addObject:obj];
        }];
        
        [self.stagingTourMainTableView reloadData];
    }else {
        NSLog(@"errorMessage =%@",stagingTourListParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:stagingTourListParser.message backgroundcolor:white];
    }
}


#pragma mark - tableView Event

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 5) {
        return self.stagingTourSelectItemArrayList.count;
    }else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *identity=@"stagingTourBannerTableViewCellID";
            stagingTourBannerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"stagingTourBannerTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.bannerItemArrayList.count >indexPath.row) {
                [cell bindeDataWithViewModel:self.bannerItemArrayList[indexPath.row] viewModelList:self.bannerItemArrayList];
            }
            
            cell.delegate =self;
            return cell;
        }
            break;
        case 1:
        {
            static NSString *identity=@"JFstagingTourBystagesTableViewCellID";
            JFstagingTourBystagesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"JFstagingTourBystagesTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell bindeDataWithViewModel:self.fqGoodsItem];
            cell.delegate = self;
            return cell;
            
        }
            break;
        case 2:
        {
            static NSString *identity=@"JFstagingTourSpecialTableViewCellID";
            JFstagingTourSpecialTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"JFstagingTourSpecialTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.subjectItemArrayList.count >indexPath.row) {
                [cell bindeDataWithViewModel:self.subjectItemArrayList[indexPath.row] viewModelList:self.subjectItemArrayList];
            }
            
            cell.delegate = self;
            return cell;
        }
            break;
        case 3:
        {
            static NSString *identity=@"JFstagingTourplayFreeTableViewCellID";
            JFstagingTourplayFreeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"JFstagingTourplayFreeTableViewCell" owner:nil options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.bwItemArrayList.count >0) {
                [cell bindeDataWithViewModel:self.bwItemArrayList];
            }
            cell.delegate = self;
            return cell;
        }
            break;
        case 4:
        {
            static NSString *identity=@"JFstagingTourplayRecommendedTableViewCellID";
            JFstagingTourplayRecommendedTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"JFstagingTourplayRecommendedTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
            break;
        case 5:
        {
            static NSString *identity=@"JFstagingTourRecommendedListTableViewCellID";
            JFstagingTourRecommendedListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"JFstagingTourRecommendedListTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.stagingTourSelectItemArrayList.count > indexPath.row) {
                if (self.stagingTourSelectItemArrayList.count == indexPath.row+1) {
                    [cell.bytagesBottomLineImageView setHidden:YES];
                }
                [cell bindeDataWithViewModel:self.stagingTourSelectItemArrayList[indexPath.row]];
            }
            cell.delegate = self;
            return cell;
        }
            break;
            
        default:
            
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 5) {
        if (self.stagingTourSelectItemArrayList.count > indexPath.row) {
            JFStagingTourfqGoodsItem *fqGoodsItem = self.stagingTourSelectItemArrayList[indexPath.row];
            NSLog(@"加载 webView");
            
            if (SUPPORT_WKWEBVIEW) {
                
                JFWKWebViewController *webViewController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                webViewController.requestUrl = fqGoodsItem.goodsUrl;
                webViewController.isShowNavigation = YES;
                webViewController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
                
            }else {
                JFWebViewController *webViewController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                webViewController.requestUrl = fqGoodsItem.goodsUrl;
                webViewController.isShowNavigation = YES;
                webViewController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
            }
        }
    }
}

// 设置组的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }else if (section == 5){
        return 0.1;
    }else if (section == 4) {
        return 0.1;
    }else {
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            return 195*JFHeightRateScale;
        }
            break;
        case 1:
        {
            return 175;
        }
            break;
        case 2:
        {
            return 175;
        }
            break;
        case 3:
        {
            return 294;
        }
            break;
        case 4:
        {
            return 45;
        }
            break;
        case 5:
        {
            return 95;
        }
            break;
            
        default:
            return 0;
            break;
    }
}

#pragma mark cell Even

- (void)clickCell:(id)cell tag:(JFTableCellClickType)tag userinfo:(id)userinfo {
    
    switch (tag) {
        case JFTableCellClickTypeHeaderBanner: {
            // 加载 webView
            NSLog(@"加载 webView");
            [MobClick event:@"homepag_ebanner"];//首页面banner点击数
            NSLog(@"userinfo = %@",userinfo);
            
            //            JFWebViewController *webViewController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
            //            webViewController.requestUrl = userinfo;
            //            webViewController.isShowNavigation = YES;
            //            webViewController.navigationItem.hidesBackButton = YES;
            //            [self.navigationController pushViewController:webViewController animated:YES];
            
            if (SUPPORT_WKWEBVIEW) {
                JFWKWebViewController *webViewController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                webViewController.requestUrl = userinfo;
                webViewController.isShowNavigation = YES;
                webViewController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
            }else {
                JFWebViewController *webViewController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                webViewController.requestUrl = userinfo;
                webViewController.isShowNavigation = YES;
                webViewController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
            }
            
        }
            break;
        case JFTableCellClickTypefqGoods:
        {
            NSLog(@"分期产品");
            [MobClick event:@"homepage_staging_headlines"];//首页面分期头条点击数
            JFPublicLineListViewController *lineListController = [[JFPublicLineListViewController alloc] initWithNibName:@"JFPublicLineListViewController" bundle:nil];
            lineListController.lineTag = userinfo;
            [self.navigationController pushViewController:lineListController animated:YES];
            
        }
            break;
        case JFTableCellClickTypefqGoodsDetails:
        {
            NSLog(@"商品详情");
            
            //            JFWebViewController *webViewController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
            //            webViewController.requestUrl = userinfo;
            //            webViewController.isShowNavigation = YES;
            //            webViewController.navigationItem.hidesBackButton = YES;
            //            [self.navigationController pushViewController:webViewController animated:YES];
            
            if (SUPPORT_WKWEBVIEW) {
                JFWKWebViewController *webViewController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                webViewController.requestUrl = userinfo;
                webViewController.isShowNavigation = YES;
                webViewController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
            }else {
                JFWebViewController *webViewController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                webViewController.requestUrl = userinfo;
                webViewController.isShowNavigation = YES;
                webViewController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
            }
            
        }
            break;
        case JFTableCellClickTypeFreePlay:
        {
            NSLog(@"白玩");
        }
            break;
        case JFTableCellClickTypeSpecialone:
        case JFTableCellClickTypeSpecialSecond:
        case JFTableCellClickTypeHomeSpecialThird:
        {
            NSLog(@"专题3");
            [MobClick event:@"homepage_special"];//首页面专题点击数
            JFPublicLineListViewController *lineListController = [[JFPublicLineListViewController alloc] initWithNibName:@"JFPublicLineListViewController" bundle:nil];
            lineListController.lineTag = userinfo;
            [self.navigationController pushViewController:lineListController animated:YES];
        }
            break;
        case JFTableCellClickTypeSelectRecommend:
        {
            NSLog(@"精选列表");
            JFPublicLineListViewController *lineListController = [[JFPublicLineListViewController alloc] initWithNibName:@"JFPublicLineListViewController" bundle:nil];
            lineListController.lineTag = userinfo;
            [self.navigationController pushViewController:lineListController animated:YES];
            
        }
            break;
            
        case JFTableCellClickTypestages:
        {
            // 分期线路
            NSLog(@"分期线路");
            JFPublicLineListViewController *lineListController = [[JFPublicLineListViewController alloc] initWithNibName:@"JFPublicLineListViewController" bundle:nil];
            lineListController.lineTag = userinfo;
            [self.navigationController pushViewController:lineListController animated:YES];
        }
            break;
            
        case JFTableCellClickTypefree:
        {
            // 白玩线路
            NSLog(@"白玩线路");
            [MobClick event:@"homepage_white_play"];//首页面白玩点击数
            JFPublicLineListViewController *lineListController = [[JFPublicLineListViewController alloc] initWithNibName:@"JFPublicLineListViewController" bundle:nil];
            lineListController.lineTag = userinfo;
            [self.navigationController pushViewController:lineListController animated:YES];
        }
            break;
        default:
            break;
    }
}




@end

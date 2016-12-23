//
//  JFPublicLineListViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/1.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFPublicLineListViewController.h"

#import "JFLineListBuilder.h"
#import "JFLineListParser.h"
#import "JFString.h"
#import "JFTipsWindow.h"
#import "JFNetworkAFN.h"
#import "JFConnectionType.h"
#import "JFPublicLineListTableViewCell.h"
#import "UIColor+Hex.h"
#import "JFStagingTourListParser.h"
#import "JFStagingTourListBuilder.h"
#import "JFSpecialBuilder.h"
#import "MJRefresh.h"
#import "JFWebViewController.h"
#import "JFWKWebViewController.h"
#import "JFMacro.h"


@interface JFPublicLineListViewController ()<JFURLConnectionDelegate,JFBaseTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) NSInteger pageNumberTag;
@property (nonatomic,strong) NSMutableArray *stagingTourSelectItemArrayList;
@property (nonatomic,strong) NSString *pageSize;
@property (nonatomic,strong) NSString *numberTotal;

@end

@implementation JFPublicLineListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"线路列表" showRightBtn:NO showLeftBtn:YES currentController:self];
    
    self.LineListTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.LineListTableView setBackgroundColor:[UIColor colorWithHexString:@"#f8f8f8"]];
    self.LineListTableView.delegate = self;
    self.LineListTableView.dataSource = self;
    self.stagingTourSelectItemArrayList = [[NSMutableArray alloc] init];
    self.pageNumberTag = 1;
    //    self.LineListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    __weak typeof(self) weakSelf = self;
    self.LineListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            [self loadMoreData];
        }
    }];
}

- (void)loadMoreData {
    
    self.LineListTableView.mj_footer.hidden = YES;
    if ([self.pageSize integerValue] > self.pageNumberTag) {
        //1, 获取数据源
        self.pageNumberTag = self.pageNumberTag+1;
        [self loadNetworkRequest];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.stagingTourSelectItemArrayList = [[NSMutableArray alloc] init];
    self.pageNumberTag = 1;
    [self loadNetworkRequest];
}

- (void)loadNetworkRequest {
    
    if ([self.lineTag isEqualToString:@"FQ"]) {
        
        JFLineListBuilder *lineListBuilder = [JFLineListBuilder sharedLineListBuilder];
        [lineListBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] goodsType:self.lineTag pageNumber:[NSString stringWithFormat:@"%ld",(long)self.pageNumberTag] total:@"0"];
        
        [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:lineListBuilder.requestURL params:lineListBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
        [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeLineListBW;
    }else if ([self.lineTag isEqualToString:@"BW"]) {
        
        
        JFLineListBuilder *lineListBuilder = [JFLineListBuilder sharedLineListBuilder];
        [lineListBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] goodsType:self.lineTag pageNumber:[NSString stringWithFormat:@"%ld",(long)self.pageNumberTag] total:@"0"];
        
        [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:lineListBuilder.requestURL params:lineListBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
        [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeLineListBW;
        
    }else if ([self.lineTag isEqualToString:@"JX"]) {
        
        JFStagingTourListBuilder *stagingTourListBuilder = [JFStagingTourListBuilder sharedStagingTourList];
        
        [stagingTourListBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] pageNumber:[NSString stringWithFormat:@"%ld",(long)self.pageNumberTag] total:@"0"];
        
        [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:stagingTourListBuilder.requestURL params:stagingTourListBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
        [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeLineListBW;
    }else {
        
        // 专题
        JFSpecialBuilder *specialBuilder = [JFSpecialBuilder sharedSpecialBuilder];
        [specialBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] subjectId:self.lineTag pageNumber:[NSString stringWithFormat:@"%ld",(long)self.pageNumberTag] total:self.numberTotal];
        
        [[JFNetworkAFN sharedNetwork] requestHttpDataWithPath:specialBuilder.requestURL params:specialBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
        [JFNetworkAFN sharedNetwork].connectionType = JFConnectionTypeLineListBW;
    }
}

#pragma mark response Event

- (void)jfURLConnection:(JFNetworkAFN *)jfURLConnection withError:(id)error {
    
    if (self.LineListTableView.mj_footer.isRefreshing) {
        [self.LineListTableView.mj_footer endRefreshing];
    }
    
    if (error) {
        NSLog(@"error = %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:error backgroundcolor:white];
        });
        return;
    }
    
    switch (jfURLConnection.connectionType) {
            
        case JFConnectionTypeLineListBW:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            
            [self handleLineListResponse:responsedict];
        }
            break;
        default:
            break;
    }
}

- (void)handleLineListResponse:(NSDictionary *)dictionary {
    NSLog(@"dic =%@",dictionary);
    self.LineListTableView.mj_footer.hidden = NO;
    self.LineListTableView.mj_footer.state = MJRefreshStateIdle;
    
    JFStagingTourListParser *linelistFQParser = [JFStagingTourListParser sharedStagingTourListParser];
    linelistFQParser.sourceData = dictionary;
    
    if (linelistFQParser.code == [JFKStatusCode integerValue]) {
        self.numberTotal = linelistFQParser.numberTotal;
        self.pageSize = linelistFQParser.pageSize;
        [linelistFQParser.stagingTourSelectItemArrayList enumerateObjectsUsingBlock:^(JFStagingTourfqGoodsItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.stagingTourSelectItemArrayList addObject:obj];
        }];
        _noDataView.hidden = (self.stagingTourSelectItemArrayList.count > 0);
        [self.LineListTableView reloadData];
        
    }else {
        NSLog(@"errorMessage =%@",linelistFQParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:linelistFQParser.message backgroundcolor:white];
    }
}

#pragma mark - tableView Event

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count %ld",(unsigned long)self.stagingTourSelectItemArrayList.count);
    return self.stagingTourSelectItemArrayList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identity=@"JFPublicLineListTableViewCellID";
    JFPublicLineListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"JFPublicLineListTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineTag = self.lineTag;
    if (self.stagingTourSelectItemArrayList.count> indexPath.row) {
        [cell bindeDataWithViewModel:self.stagingTourSelectItemArrayList[indexPath.row]];
    }
    cell.delegate =self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath =%ld",(long)indexPath.row);
    
    if (self.stagingTourSelectItemArrayList.count>indexPath.row) {
        
        // self.stagingTourSelectItemArrayList[indexPath.row]
        JFStagingTourfqGoodsItem *fqGoodsItem = self.stagingTourSelectItemArrayList[indexPath.row];
        NSLog(@"加载 webView");
        if (SUPPORT_WKWEBVIEW) {
            JFWKWebViewController *webViewController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
            webViewController.isShowNavigation = YES;
            webViewController.isShare = YES;
            webViewController.shareTypeNumber = line;
            webViewController.requestUrl = fqGoodsItem.goodsUrl;
            webViewController.commodityName = fqGoodsItem.pushName;
            webViewController.navigationItem.hidesBackButton = YES;
            [self.navigationController pushViewController:webViewController animated:YES];
        }else {
            JFWebViewController *webViewController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
            webViewController.isShowNavigation = YES;
            webViewController.isShare = YES;
            webViewController.shareTypeNumber = line;
            webViewController.commodityName = fqGoodsItem.pushName;
            webViewController.requestUrl = fqGoodsItem.goodsUrl;
            webViewController.navigationItem.hidesBackButton = YES;
            [self.navigationController pushViewController:webViewController animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 250*JFHeightRateScale;
}

- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
}



@end

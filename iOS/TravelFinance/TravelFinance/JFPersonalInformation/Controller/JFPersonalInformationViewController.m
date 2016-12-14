//
//  JFPersonalInformationViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/15.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFPersonalInformationViewController.h"

#import "JFPersonalInformationListTableViewCell.h"
#import "JFPersonalInformationTableViewCell.h"
#import "JFPersonalSetingViewController.h"
#import "JFPersonalInformationBuilder.h"
#import "JFPersonalInformationParser.h"
#import "JFString.h"
#import "JFNetworkAFN.h"
#import "JFTipsWindow.h"
#import "UIColor+Hex.h"
#import "JFWebViewController.h"
#import "JFOpeningStageRealNameViewController.h"
#import "JFWKWebViewController.h"
#import "JFMacro.h"


@interface JFPersonalInformationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *informationListArray;
@property (nonatomic, strong) NSMutableArray *informationDetailsListArray;
@property (nonatomic, strong) JFPersonalInformationItem *personInformationItem;

@end

@implementation JFPersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"个人信息" showRightBtn:NO showLeftBtn:YES currentController:self];
    self.personalInformationTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.personalInformationTableView.delegate = self;
    self.personalInformationTableView.dataSource = self;
    //    self.informationListArray = @[@"头像",@"姓名",@"身份证号",@"手机号",@"邮箱",@"我的银行卡",@"设置"];
    self.informationListArray = @[@"头像",@"姓名",@"身份证号",@"手机号",@"我的银行卡",@"设置"];
    self.informationDetailsListArray = [[NSMutableArray alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 首页数据
    JFPersonalInformationBuilder *personInformationBuilder = [JFPersonalInformationBuilder sharedPersonalInformation];
    [personInformationBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
    
    JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
    [afnet requestHttpDataWithPath:personInformationBuilder.requestURL params:personInformationBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    afnet.connectionType = JFConnectionTypePersonInformation;
    
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
            
        case JFConnectionTypePersonInformation:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            
            [self handlestagingTourResponse:responsedict];
        }
            break;
        default:
            break;
    }
}

- (void)handlestagingTourResponse:(NSDictionary *)dictionary {
    NSLog(@"dic =%@",dictionary);
    
    JFPersonalInformationParser *personInformationParser = [JFPersonalInformationParser sharedPersonInformationParser];
    personInformationParser.sourceData = dictionary;
    if (personInformationParser.code == [JFKStatusCode integerValue]) {
        self.personInformationItem = [[JFPersonalInformationItem alloc] init];
        NSLog(@"%@",personInformationParser.personInformationItem.realName);
        self.personInformationItem = personInformationParser.personInformationItem;
        [self.informationDetailsListArray addObject:personInformationParser.personInformationItem.realName];
        [self.informationDetailsListArray addObject:self.personInformationItem.idCardNo];
        [self.informationDetailsListArray addObject:self.personInformationItem.mobile];
//        [self.informationDetailsListArray addObject:self.personInformationItem.email];
        [self.informationDetailsListArray addObject:self.personInformationItem.bankCardNumber];
        [self.informationDetailsListArray addObject:@""];
        [self.personalInformationTableView reloadData];
        
    }else {
        NSLog(@"errorMessage =%@",personInformationParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:personInformationParser.message backgroundcolor:white];
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

#pragma mark tableViewDelegate Even

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return 7;
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        static NSString *identity=@"JFPersonalInformationTableViewCellID";
        JFPersonalInformationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"JFPersonalInformationTableViewCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch ([self.personInformationItem.sex integerValue]) {
            case 0:
            {
                cell.headerImageView.image = [UIImage imageNamed:@"personalcenter_head_unknown"];
            }
                break;
            case 1:
            {
                // 男
                cell.headerImageView.image = [UIImage imageNamed:@"personalcenter_head"];
                
            }
                break;
            case 2:
            {
                // 女
                cell.headerImageView.image = [UIImage imageNamed:@"personalcenter_head_female"];
            }
                break;
                
            default:
                break;
        }
        
        return cell;
        
    }else {
        static NSString *identity=@"JFPersonalInformationListTableViewCellID";
        JFPersonalInformationListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"JFPersonalInformationListTableViewCell" owner:self options:nil]lastObject];
        }
        if (self.informationListArray.count > indexPath.row) {
            cell.nameLabel.text = self.informationListArray[indexPath.row];
        }
        
        if (indexPath.row == 3) {
            [cell.arrorImageView setHidden:YES];
        }
        if (indexPath.row == 5) {
            [cell.realNameLabel setHidden:YES];
        }
        if (self.informationDetailsListArray.count > indexPath.row-1) {
            cell.realNameLabel.text = self.informationDetailsListArray[indexPath.row-1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell.realNameLabel.text.length > 0) {
            if (indexPath.row != 4) {
                [cell.arrorImageView setHidden:YES];
            }
            
        }else {
            cell.realNameLabel.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
            switch (indexPath.row) {
                case 1:
                {
                    cell.realNameLabel.text = @"尚未实名,去认证个人信息";
                }
                    break;
                case 2:
                {
                    cell.realNameLabel.text = @"尚未实名,去认证个人信息";
                }
                    break;
                    //                case 4:
                    //                {
                    //                    cell.realNameLabel.text = @"未填写";
                    //                }
                    //                    break;
                default:
                    break;
            }        }
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 1:
        {
            //tableView.cel.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!(self.personInformationItem.idCardNo.length>0)) {
                // 姓名
                JFOpeningStageRealNameViewController *realNameController = [[JFOpeningStageRealNameViewController alloc] initWithNibName:@"JFOpeningStageRealNameViewController" bundle:nil];
                [self.navigationController pushViewController:realNameController animated:YES];
            }
            
        }
            break;
        case 2:
        {
            if (!(self.personInformationItem.idCardNo.length > 0)) {
                // 身份证号
                JFOpeningStageRealNameViewController *realNameController = [[JFOpeningStageRealNameViewController alloc] initWithNibName:@"JFOpeningStageRealNameViewController" bundle:nil];
                realNameController.personInformationType = @"实名认证";
                [self.navigationController pushViewController:realNameController animated:YES];
            }
            
        }
            break;
        case 4:
        {
            // 我的银行卡
            if (SUPPORT_WKWEBVIEW) {
                JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                payWebController.requestUrl = self.personInformationItem.htmlStr;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
            }else {
                
                JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                payWebController.requestUrl = self.personInformationItem.htmlStr;
                payWebController.htmlSubmit =NO;
                payWebController.isShowNavigation = YES;
                payWebController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:payWebController animated:YES];
            }
            
            
        }
            break;
        case 5:
        {
            // 设置
            JFPersonalSetingViewController *personSetController = [[JFPersonalSetingViewController alloc] initWithNibName:@"JFPersonalSetingViewController" bundle:nil];
            [self.navigationController pushViewController:personSetController animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 85;
    }else {
        return 45;
    }
}

@end

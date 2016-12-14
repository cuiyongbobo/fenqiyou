//
//  JFBindingBankListViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/9.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFBindingBankListViewController.h"

#import "JFBindingBankListTableViewCell.h"
#import "JFBindingBankListParser.h"
#import "JFBindingBankListBuilder.h"
#import "JFNetworkAFN.h"
#import "JFString.h"
#import "JFTipsWindow.h"

@interface JFBindingBankListViewController ()<UITableViewDataSource,UITableViewDelegate,JFURLConnectionDelegate>

@property (nonatomic,strong) NSMutableArray *BankModelArray;

@end

@implementation JFBindingBankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.bindingBankListTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.bindingBankListTableView.delegate = self;
    self.bindingBankListTableView.dataSource = self;
    [self configNavigation:@"支持银行" showRightBtn:NO showLeftBtn:YES currentController:self];
    self.BankModelArray = [[NSMutableArray alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    JFBindingBankListBuilder *bankListPayBuilder = [JFBindingBankListBuilder sharedBankList];
    [bankListPayBuilder buildPostData];
    
    JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
    [afnet requestHttpDataWithPath:bankListPayBuilder.requestURL params:bankListPayBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    afnet.connectionType = JFConnectionTypeBankList;
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
            
        case JFConnectionTypeBankList:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            
            [self handleBindingResponse:responsedict];
        }
            break;
            
        default:
            break;
    }
}


- (void)handleBindingResponse:(NSDictionary *)dictionary {
    
    NSLog(@"dic =%@",dictionary);
    JFBindingBankListParser *bindBankParser = [JFBindingBankListParser sharedbankListParser];
    bindBankParser.sourceData = dictionary;
    
    if (bindBankParser.code == [JFKStatusCode integerValue]) {
        self.BankModelArray = bindBankParser.BankModelArray;
        [self.bindingBankListTableView reloadData];
        if (self.BankModelArray.count >0) {
            [self.noDataView setHidden:YES];
        }
    }else {
        
        NSLog(@"errorMessage =%@",bindBankParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:bindBankParser.message backgroundcolor:white];
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
    
    return self.BankModelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identity=@"JFBindingBankListTableViewCellID";
    JFBindingBankListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"JFBindingBankListTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.BankModelArray.count == indexPath.row+1) {
        [cell.bindingBottomImageView setHidden:YES];
    }
    
    if (self.BankModelArray.count >indexPath.row) {
        
        [cell bindeDataWithViewModel:self.BankModelArray[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 49;
}


@end

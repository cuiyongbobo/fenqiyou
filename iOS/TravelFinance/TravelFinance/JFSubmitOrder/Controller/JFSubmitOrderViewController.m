//
//  JFSubmitOrderViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/7.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFSubmitOrderViewController.h"

#import "JFNetworkAFN.h"
#import "UIColor+Hex.h"
#import "JFsubmitOrderInformationListTableViewCell.h"
#import "JFsubmitOrderTravelInformationTableViewCell.h"
#import "JFsubmitOrderRecommendedPersonTableViewCell.h"
#import "JFsubmitOrderguaranteeAgreementTableViewCell.h"
#import "JFTravelPersonInformationViewController.h"
#import "JFsubmitOrderstagesInformationTableViewCell.h"
#import "JFBindingCardViewController.h"
#import "JFCouponViewController.h"
#import "JFDevice.h"
#import "JFTipsWindow.h"
#import "JFString.h"
#import "JFSubmitOrderBuilder.h"
#import "JFSubmitOrderParser.h"
#import "JFCreditPersonItem.h"
#import "JFBindingCardViewController.h"
#import "NSMutableArray+Hex.h"
#import "NSMutableDictionary+HexDict.h"
#import "JFOrderPayBuilder.h"
#import "JFOrderPayParser.h"
#import "JFWebViewController.h"
#import "JFOpeningStageRealNameViewController.h"
#import "JFOpeningStageBindingBankCardViewController.h"
#import "JFOpeningStageCertificationInstitutionViewController.h"
#import "JFBaseLibCommon.h"
#import "JFNetworkAFN.h"
#import "YKToastView.h"
#import "JFWKWebViewController.h"


@interface JFSubmitOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,JFURLConnectionDelegate,backPersonInformationdelegate,JFBaseTableViewCellDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *submitPaymentLabel;
@property (weak, nonatomic) IBOutlet UITableView *submitOrderTableView;
@property (nonatomic, strong) UITextField *submitOrderPhoneText;
@property (nonatomic, strong) NSMutableArray *MyselfArray;
@property (nonatomic, strong) NSMutableArray *PeerArray;
@property (nonatomic, strong) NSMutableArray *payInformationListArray;
@property (nonatomic, strong) NSMutableDictionary *payInformationListDictionary;
@property (nonatomic,assign) CGRect  Orginframe;


- (IBAction)handleToStage:(id)sender;

@end

@implementation JFSubmitOrderViewController

#pragma mark life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setHidden:NO];
    [self configNavigation:@"提交订单" showRightBtn:NO showLeftBtn:YES currentController:self];
    self.submitOrderTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.submitOrderTableView.delegate = self;
    self.submitOrderTableView.dataSource = self;
    
    if ([self.detailsDictionary[@"orderType"] isEqualToString:@"fq"]) {
        [self.submitButton setTitle:@"去分期" forState:UIControlStateNormal];
        self.realPaymentLabel.text = self.detailsDictionary[@"firstPayment"];
        self.realPaymentNameLabel.text = @"首付:";
    }else {
        [self.submitButton setTitle:@"去投资" forState:UIControlStateNormal];
        self.realPaymentLabel.text = self.detailsDictionary[@"InvestmentAmount"];
        self.realPaymentNameLabel.text = @"投资:";
    }
    
    _payInformationListArray = [[NSMutableArray alloc] init];
    _payInformationListDictionary = [[NSMutableDictionary alloc] init];
    //    self.submitOrderPhoneText.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    
    
    
    // 请求接口
    JFSubmitOrderBuilder *orderBuilder = [JFSubmitOrderBuilder sharedOrder];
    [orderBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
    
    JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
    [afnet requestHttpDataWithPath:orderBuilder.requestURL params:orderBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    afnet.connectionType = JFConnectionTypeUserCreditInformation;
    
    
    // 请求接口
    //    JFSubmitOrderBuilder *orderBuilder = [JFSubmitOrderBuilder sharedOrder]; // b03af224996df86f
    ////    [orderBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId]];
    //
    //    [orderBuilder buildPostData:@"b03af224996df86f"];
    //
    //    JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
    //    [afnet requestHttpDataWithPath:orderBuilder.requestURL params:orderBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    //    afnet.connectionType = JFConnectionTypeUserCreditInformation;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark load h5

- (void)loadh5Information {
    
}


#pragma mark handle Even

- (IBAction)handleToStage:(id)sender {
    NSLog(@"去分期");
    NSLog(@"%@",_detailsDictionary);
    if ([_detailsDictionary[@"travelNumber"] integerValue] >1) {
        
        if (_PeerArray.count >0 && _MyselfArray.count >0) {
            
            NSDictionary *detailsDict = @{@"details":_detailsDictionary};
            [_payInformationListDictionary setAllObject:detailsDict forKey:@"details"];
            
            if (_PeerArray.count >0) {
                NSDictionary *peerInformationDict = @{@"peerInformation":_PeerArray};
                [_payInformationListDictionary setAllObject:peerInformationDict forKey:@"peerInformation"];
                
            }
            if (_MyselfArray.count >0) {
                NSDictionary *myselfInformationDict = @{@"MyselfInformation":_MyselfArray};
                [_payInformationListDictionary setAllObject:myselfInformationDict forKey:@"MyselfInformation"];
            }
            
            if (self.submitOrderPhoneText.text.length >0) {
                NSDictionary *recommendfInformationDict = @{@"recommendPerson":self.submitOrderPhoneText.text};
                [_payInformationListDictionary setAllObject:recommendfInformationDict forKey:@"recommendPerson"];
            }
            
            if (_payInformationListDictionary !=nil) {
                [[NSUserDefaults standardUserDefaults] setObject:self.payInformationListDictionary forKey:@"saveOrderInformation"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            
            if ([_detailsDictionary[@"orderType"] isEqualToString:@"fq"]) {
                
                if ([self.personItem.stageStep integerValue] == 10) {
                    NSLog(@"去支付");
                    [self payment];
                }
            }else if ([_detailsDictionary[@"orderType"] isEqualToString:@"bw"]) {
                // 白玩
                if ([self.personItem.financingStep integerValue] == 0) {
                    NSLog(@"实名认证");
                    
                }else if([self.personItem.financingStep integerValue] == 1) {
                    
                    NSLog(@"去绑卡");
                    JFBindingCardViewController *cardController = [[JFBindingCardViewController alloc] initWithNibName:@"JFBindingCardViewController" bundle:nil];
                    [self.navigationController pushViewController:cardController animated:YES];
                    
                }else if ([self.personItem.financingStep integerValue] == 10) {
                    
                    NSLog(@"去支付");
                    // 这个操作是 测试 绑卡的
                    [self payment];
                    
                }
            }
            
        }else {
            // 两个人 其中一个为空
            NSLog(@"完善出行人信息");
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请完善出行人信息" backgroundcolor:white];
        }
        
        
    }else {
        
        // 出行人为 1 本人
        if (_MyselfArray.count >0) {
            
            NSDictionary *detailsDict = @{@"details":_detailsDictionary};
            [_payInformationListDictionary setAllObject:detailsDict forKey:@"details"];
            
            if (_PeerArray.count >0) {
                NSDictionary *peerInformationDict = @{@"peerInformation":_PeerArray};
                [_payInformationListDictionary setAllObject:peerInformationDict forKey:@"peerInformation"];
            }
            if (_MyselfArray.count >0) {
                NSDictionary *myselfInformationDict = @{@"MyselfInformation":_MyselfArray};
                [_payInformationListDictionary setAllObject:myselfInformationDict forKey:@"MyselfInformation"];
            }
            
            if (self.submitOrderPhoneText.text.length >0) {
                
                NSDictionary *recommendfInformationDict = @{@"recommendPerson":self.submitOrderPhoneText.text};
                [_payInformationListDictionary setAllObject:recommendfInformationDict forKey:@"recommendPerson"];
            }
            
            if (_payInformationListDictionary !=nil) {
                [[NSUserDefaults standardUserDefaults] setObject:self.payInformationListDictionary forKey:@"saveOrderInformation"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            if ([_detailsDictionary[@"orderType"] isEqualToString:@"fq"]) {
                
                if ([self.personItem.stageStep integerValue] == 10) {
                    NSLog(@"去支付");
                    [self payment];
                }
                
            }else if ([_detailsDictionary[@"orderType"] isEqualToString:@"bw"]) {
                
                if ([self.personItem.financingStep integerValue] == 0) {
                    NSLog(@"实名认证");
                    
                    
                }else if([self.personItem.financingStep integerValue] == 1) {
                    
                    NSLog(@"去绑卡");
                    JFBindingCardViewController *cardController = [[JFBindingCardViewController alloc] initWithNibName:@"JFBindingCardViewController" bundle:nil];
                    [self.navigationController pushViewController:cardController animated:YES];
                    
                }else if ([self.personItem.financingStep integerValue] == 10) {
                    
                    NSLog(@"去支付");
                    [self payment];
                }
                
            }
            
        }else {
            
            NSLog(@"完善出行人信息");
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请完善出行人信息" backgroundcolor:white];
        }
        
    }
    
}

#pragma mark text delegate

- (void) registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    //    NSDictionary *userInfo = [aNotification userInfo];
    //    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGRect keyboardRect = [aValue CGRectValue];
    //    int height = keyboardRect.size.height;
    
    //    [UIView animateWithDuration:0.3f animations:^{
    //        self.submitOrderTableView.contentOffset = CGPointMake(0, 100);
    //    }];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
    //    UIView *view = textField.superview;
    //    while (![view isKindOfClass:[JFBaseTableViewCell class]]) {
    //        view = [view superview];
    //    }
    //    UITableViewCell *cell = (UITableViewCell*)view;
    //    CGRect rect = [cell convertRect:cell.frame toView:self.view];
    //    int keybordHeight = 0;
    //    if ([JFDevice screenHeight] > 667) {
    //        keybordHeight = 226;
    //    }else {
    //        keybordHeight = 216;
    //    }
    //
    //    if ([JFDevice screenHeight] -(rect.origin.y/2+rect.size.height)<keybordHeight) {
    //
    //        CGFloat Lowhight=keybordHeight-([JFDevice screenHeight]-(rect.origin.y/2+rect.size.height));
    //
    //        _submitOrderTableView.contentInset = UIEdgeInsetsMake(0, 0, Lowhight, 0);
    //        [_submitOrderTableView scrollToRowAtIndexPath:[_submitOrderTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    //
    //                [UIView animateWithDuration:0.3f animations:^{
    //                    self.Orginframe = self.view.frame;
    //                    self.view.frame = CGRectMake(self.Orginframe.origin.x, self.Orginframe.origin.y-Lowhight, self.Orginframe.size.width, self.Orginframe.size.height);
    //                }];
    //    }
    //
    //
    //        if (rect.origin.y / 2 + rect.size.height>=[JFDevice screenHeight]-330) {
    //            _submitOrderTableView.contentInset = UIEdgeInsetsMake(0, 0, 330, 0);
    //            [_submitOrderTableView scrollToRowAtIndexPath:[_submitOrderTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    //        }
    //    return YES;
    
    UIView *view = textField.superview;
    while (![view isKindOfClass:[JFBaseTableViewCell class]]) {
        view = [view superview];
    }
    UITableViewCell *cell = (UITableViewCell*)view;
    CGRect rect = [cell convertRect:cell.frame toView:self.view];
    float lowHeight = [JFDevice screenHeight] - rect.origin.y / 2 + rect.size.height;
    if (rect.origin.y / 2 + rect.size.height>=[JFDevice screenHeight]-lowHeight) {
        _submitOrderTableView.contentInset = UIEdgeInsetsMake(0, 0, 330, 0);
        [_submitOrderTableView scrollToRowAtIndexPath:[_submitOrderTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    return YES;
    
    
    //    UIView *view = textField.superview;
    //    while (![view isKindOfClass:[JFBaseTableViewCell class]]) {
    //        view = [view superview];
    //    }
    //    UITableViewCell *cell = (UITableViewCell*)view;
    //    CGRect rect = [cell convertRect:cell.frame toView:self.view];
    //    if (rect.origin.y / 2 + rect.size.height>=[JFDevice screenHeight]-330) {
    //        _submitOrderTableView.contentInset = UIEdgeInsetsMake(0, 0, 330, 0);
    //        [_submitOrderTableView scrollToRowAtIndexPath:[_submitOrderTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    //    }
    //    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.submitOrderPhoneText) {
        NSString *verifyCode = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (verifyCode.length > 11) {
            return NO;
        }
    }
    return YES;
    
}



- (void)returnKeyboard:(id) sender{
    
    NSLog(@"text = %@",self.submitOrderPhoneText.text);
    NSLog(@"回收键盘");
    [UIView animateWithDuration:0.3f animations:^{
        [self.submitOrderPhoneText resignFirstResponder];
        self.submitOrderTableView.contentOffset = CGPointMake(0, 0);
    }];
}

- (BOOL)isMobileNumber:(NSString *)mobileNum {
    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if ([regextestmobile evaluateWithObject:mobileNum]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark navigation back
- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"saveOrderInformation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
}

#pragma mark responce Evne

- (void)jfURLConnection:(JFNetworkAFN *)jfURLConnection withError:(id)error {
    
    
    if (error) {
        [[YKToastView sharedToastView] hide];        NSLog(@"error = %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:error backgroundcolor:white];
        });
        return;
    }
    switch (jfURLConnection.connectionType) {
            
        case JFConnectionTyPepayment:
        {
            [[YKToastView sharedToastView] hide];
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            
            [self handleOrderPayResponse:responsedict];
        }
            break;
            
        case JFConnectionTypeUserCreditInformation:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleOrderResponse:responsedict];
        }
            break;
        default:
            break;
    }
}


- (void)saveMyselfInformation {
    
    if ([self.detailsDictionary[@"orderType"] isEqualToString:@"bw"]) {
        
        if ([self.personItem.financingStep integerValue] > 0) {
            self.MyselfArray = [[NSMutableArray alloc] init];
            [_MyselfArray addllObject:self.personItem.realName];
            [_MyselfArray addllObject:self.personItem.idCardNo];
            [_MyselfArray addllObject:self.personItem.mobile];
            [_MyselfArray addllObject:@""];
            [_MyselfArray addllObject:@""];
        }
        
    }else {
        if ([self.personItem.stageStep integerValue] > 0) {
            self.MyselfArray = [[NSMutableArray alloc] init];
            [_MyselfArray addllObject:self.personItem.realName];
            [_MyselfArray addllObject:self.personItem.idCardNo];
            [_MyselfArray addllObject:self.personItem.mobile];
            [_MyselfArray addllObject:@""];
            [_MyselfArray addllObject:@""];
        }
        
    }
}

- (void)handleOrderPayResponse:(NSDictionary *)dictionary  {
    NSLog(@"dic =%@",dictionary);
    JFOrderPayParser *orderPayParser = [JFOrderPayParser sharedOrderPayParser];
    orderPayParser.sourceData = dictionary;
    if (orderPayParser.code == [JFKStatusCode integerValue]) {
        
        if (SUPPORT_WKWEBVIEW) {
            JFWKWebViewController *payWebController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
            payWebController.requestUrl = orderPayParser.dataDictnary[@"htmlStr"];
            if ([orderPayParser.dataDictnary[@"orderType"] isEqualToString:@"fq"]) {
                payWebController.htmlSubmit =NO;
            }else {
                payWebController.htmlSubmit =YES;
            }
            payWebController.isShowNavigation = YES;
            payWebController.isNotShowCloseBtn = YES;
            payWebController.navigationItem.hidesBackButton = YES;
            [self.navigationController pushViewController:payWebController animated:YES];
            
        }else {
            JFWebViewController *payWebController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
            payWebController.requestUrl = orderPayParser.dataDictnary[@"htmlStr"];
            if ([orderPayParser.dataDictnary[@"orderType"] isEqualToString:@"fq"]) {
                payWebController.htmlSubmit =NO;
            }else {
                payWebController.htmlSubmit =YES;
            }
            payWebController.isShowNavigation = YES;
            payWebController.isNotShowCloseBtn = YES;
            payWebController.navigationItem.hidesBackButton = YES;
            [self.navigationController pushViewController:payWebController animated:YES];
            
        }
        
    }else {
        NSLog(@"errorMessage =%@",orderPayParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:orderPayParser.message backgroundcolor:white];
    }
    
}


#pragma mark travelPerson delegate

- (void)backPerson:(JFTravelPedestrian *)information personType:(NSString *)type {
    
    if ([type isEqualToString:@"Myself"]) {
        //        [_MyselfArray addObject:information];
        self.MyselfArray = [[NSMutableArray alloc] init];
        if (information) {
            [_MyselfArray addllObject:information.realName];
            [_MyselfArray addllObject:information.idCard];
            [_MyselfArray addllObject:information.mobile];
            [_MyselfArray addllObject:information.contactRealName];
            [_MyselfArray addllObject:information.contactMobile];
        }
        
    }else if ([type isEqualToString:@"Peer"]) {
        self.PeerArray = [[NSMutableArray alloc] init];
        if (information) {
            //            self.personInformation = information;
            [_PeerArray addllObject:information.realName];
            [_PeerArray addllObject:information.idCard];
            [_PeerArray addllObject:information.mobile];
            [_PeerArray addllObject:information.contactRealName];
            [_PeerArray addllObject:information.contactMobile];
        }
    }
}


#pragma mark pay Even

- (void)payment {
    //
    // 去支付
    // 获取参数
    NSMutableDictionary *informatonDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveOrderInformation"];
    NSLog(@"%@",informatonDict);
    NSDictionary *detailsDictionary = [[NSDictionary alloc] init];
    NSDictionary *peerInformationDictionary = [[NSDictionary alloc] init];
    NSDictionary *MyselfInformationDictionary = [[NSDictionary alloc] init];
    NSDictionary *recommendPersonDictionary = [[NSDictionary alloc] init];
    NSString *peerName = [[NSString alloc] init];
    NSString *peerIdCard = [[NSString alloc] init];
    NSString *peerMobile = [[NSString alloc] init];
    NSString *myselfPersonName = [[NSString alloc] init];
    NSString *myselfPersonMobile = [[NSString alloc] init];
    NSString *myselfPersonIdCard = [[NSString alloc] init];
    NSString *recommendPerson = [[NSString alloc] init];
    NSString *contactName = [[NSString alloc] init];
    NSString *contactTel = [[NSString alloc] init];
    
    if (informatonDict[@"details"] !=nil) {
        detailsDictionary = informatonDict[@"details"];
    }
    
    if (informatonDict[@"MyselfInformation"] !=nil) {
        
        MyselfInformationDictionary = informatonDict[@"MyselfInformation"];
        NSArray *myselfInformationArray = MyselfInformationDictionary[@"MyselfInformation"];
        myselfPersonName = myselfInformationArray[0];
        myselfPersonIdCard = myselfInformationArray[1];
        myselfPersonMobile = myselfInformationArray[2];
        contactName = myselfInformationArray[3];
        contactTel = myselfInformationArray[4];
        
    }
    
    if (informatonDict[@"peerInformation"] !=nil) {
        
        peerInformationDictionary = informatonDict[@"peerInformation"];
        NSArray *peerArray = peerInformationDictionary[@"peerInformation"];
        peerName = peerArray[0];
        peerIdCard = peerArray[1];
        peerMobile = peerArray[2];
        
    }
    
    if (informatonDict[@"recommendPerson"] !=nil) {
        
        recommendPersonDictionary = informatonDict[@"recommendPerson"];
        recommendPerson = recommendPersonDictionary[@"recommendPerson"];
        
    }
    
    NSString *typeID = @"";
    NSDictionary *details = detailsDictionary[@"details"];
    if ([details[@"orderType"] isEqualToString:@"bw"]) {
        typeID = @"0";
    }else {
        typeID = @"1";
    }
    
    
    if ([typeID isEqualToString:@"0"]) {
        // 白玩
        // 请求接口
        YKToastView *toastView = [YKToastView sharedToastViewWWithIndicatorAndText:JFKLoadingMessage];
        [toastView showInView:self.view];
        
        JFOrderPayBuilder *orderPayBuilder = [JFOrderPayBuilder sharedOrderPay];
        [orderPayBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] orderType:typeID tuanNo:details[@"tuanNo"] tuanId:details[@"tuanId"] stageOrFinancialId:details[@"productId"] peerName:peerName peerIdCard:peerIdCard peerMobile:peerMobile contactName:contactName contactTel:contactTel couponId:@"1" recommendMobile:recommendPerson selfMobile:myselfPersonMobile];
        
        JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
        [afnet requestHttpDataWithPath:orderPayBuilder.requestURL params:orderPayBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
        afnet.connectionType = JFConnectionTyPepayment;
        
    }else {
        // 分期
        YKToastView *toastView = [YKToastView sharedToastViewWWithIndicatorAndText:JFKLoadingMessage];
        [toastView showInView:self.view];
        // 请求接口
        JFOrderPayBuilder *orderPayBuilder = [JFOrderPayBuilder sharedOrderPay];
        [orderPayBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] orderType:typeID tuanNo:details[@"tuanNo"] tuanId:details[@"tuanId"] stageOrFinancialId:details[@"productId"] peerName:peerName peerIdCard:peerIdCard peerMobile:peerMobile contactName:contactName contactTel:contactTel couponId:@"1" recommendMobile:recommendPerson selfMobile:myselfPersonMobile];
        
        JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
        [afnet requestHttpDataWithPath:orderPayBuilder.requestURL params:orderPayBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
        afnet.connectionType = JFConnectionTyPepayment;
        
    }
    
    //
}


#pragma mark cell Even

- (void)clickCell:(id)cell tag:(JFTableCellClickType)tag userinfo:(id)userinfo {
    
    switch (tag) {
        case JFTableCellClickTypeTouristContract: {
            
            if (SUPPORT_WKWEBVIEW) {
                JFWKWebViewController *webViewController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                NSString *TouristContractRequestURL = @"/bwOrder/findAgreement?code=TDCJA";
                webViewController.requestUrl =[[JFBaseLibCommon baseH5URL] stringByAppendingString:TouristContractRequestURL];
                webViewController.navigationItem.hidesBackButton = YES;
                webViewController.isShowNavigation = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
            }else {
                
                JFWebViewController *webViewController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                NSString *TouristContractRequestURL = @"/bwOrder/findAgreement?code=TDCJA";
                webViewController.requestUrl =[[JFBaseLibCommon baseH5URL] stringByAppendingString:TouristContractRequestURL];
                webViewController.navigationItem.hidesBackButton = YES;
                webViewController.isShowNavigation = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
            }
            
            
        }
            break;
        case JFTableCellClickTypeAntimoneylaundering: {
            
            if (SUPPORT_WKWEBVIEW) {
                JFWKWebViewController *webViewController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                NSString *AntimoneylaunderingRequestURL = @"/bwOrder/findAgreement?code=JK";
                webViewController.requestUrl =[[JFBaseLibCommon baseH5URL] stringByAppendingString:AntimoneylaunderingRequestURL];
                webViewController.navigationItem.hidesBackButton = YES;
                webViewController.isShowNavigation = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
            }else {
                
                JFWebViewController *webViewController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                NSString *AntimoneylaunderingRequestURL = @"/bwOrder/findAgreement?code=JK";
                webViewController.requestUrl =[[JFBaseLibCommon baseH5URL] stringByAppendingString:AntimoneylaunderingRequestURL];
                webViewController.navigationItem.hidesBackButton = YES;
                webViewController.isShowNavigation = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
            }
            
            
        }
            break;
        case JFTableCellClickTypeServiceAgreement: {
            
            if (SUPPORT_WKWEBVIEW) {
                JFWKWebViewController *webViewController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                NSString *ServiceAgreementRequestURL = @"/bwOrder/findAgreement?code=LCSLY";
                webViewController.requestUrl =[[JFBaseLibCommon baseH5URL] stringByAppendingString:ServiceAgreementRequestURL];
                webViewController.navigationItem.hidesBackButton = YES;
                webViewController.isShowNavigation = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
            }else {
                JFWebViewController *webViewController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                NSString *ServiceAgreementRequestURL = @"/bwOrder/findAgreement?code=LCSLY";
                webViewController.requestUrl =[[JFBaseLibCommon baseH5URL] stringByAppendingString:ServiceAgreementRequestURL];
                webViewController.navigationItem.hidesBackButton = YES;
                webViewController.isShowNavigation = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
            }
            
            
        }
            break;
        case JFTableCellClickTypeFinancingModel: {
            
            if (SUPPORT_WKWEBVIEW) {
                
                JFWKWebViewController *webViewController = [[JFWKWebViewController alloc] initWithNibName:@"JFWKWebViewController" bundle:nil];
                NSString *FinancingModelRequestURL = @"/bwOrder/findAgreement?code=RZWJFB";
                webViewController.requestUrl =[[JFBaseLibCommon baseH5URL] stringByAppendingString:FinancingModelRequestURL];
                webViewController.navigationItem.hidesBackButton = YES;
                webViewController.isShowNavigation = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
            }else {
                JFWebViewController *webViewController = [[JFWebViewController alloc] initWithNibName:@"JFWebViewController" bundle:nil];
                NSString *FinancingModelRequestURL = @"/bwOrder/findAgreement?code=RZWJFB";
                webViewController.requestUrl =[[JFBaseLibCommon baseH5URL] stringByAppendingString:FinancingModelRequestURL];
                webViewController.navigationItem.hidesBackButton = YES;
                webViewController.isShowNavigation = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
            }
            
        }
            break;
        default:
            break;
    }
    
}


- (void)handleOrderResponse:(NSDictionary *)dictionary {
    
    NSLog(@"dic =%@",dictionary);
    JFSubmitOrderParser *orderParser = [JFSubmitOrderParser sharedOrderParser];
    orderParser.sourceData = dictionary;
    if (orderParser.code == [JFKStatusCode integerValue]) {
        self.personItem = orderParser.personItem;
        
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"errorMessage =%@",orderParser.message);
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:orderParser.message backgroundcolor:white];
            
        });
    }
}




#pragma mark tableViewDelegate Even

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 1) {
        return 3;
    }else if (section == 2){
        
        if ([_detailsDictionary[@"travelNumber"] integerValue] >1) {
            return 2;
        }else {
            return 1;
        }
        
    }else if (section == 3){
        return 1;
    }else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *identity=@"JFsubmitOrderInformationListTableViewCellID";
            JFsubmitOrderInformationListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"JFsubmitOrderInformationListTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell bindeDataWithViewModel:self.detailsDictionary];
            return cell;
        }
            break;
            
        case 1:
        {
            static NSString *identity=@"JFsubmitOrderstagesInformationTableViewCellID";
            JFsubmitOrderstagesInformationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"JFsubmitOrderstagesInformationTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            switch (indexPath.row) {
                case 0:
                {
                    if ([self.detailsDictionary[@"orderType"] isEqualToString:@"fq"]) {
                        cell.stagesNameLabel.text = @"首付金额:";
                        cell.submitPaymentLabel.text = self.detailsDictionary[@"firstPayment"];
                    }else {
                        cell.stagesNameLabel.text = @"投资金额:";
                        cell.submitPaymentLabel.text = self.detailsDictionary[@"InvestmentAmount"];
                    }
                    
                }
                    break;
                case 1:
                {
                    
                    if ([self.detailsDictionary[@"orderType"] isEqualToString:@"fq"]) {
                        cell.stagesNameLabel.text = @"分期期数:";
                        cell.submitPaymentLabel.text = self.detailsDictionary[@"numberPeriods"];
                    }else {
                        cell.stagesNameLabel.text = @"投资期数:";
                        cell.submitPaymentLabel.text = self.detailsDictionary[@"InvestmentPeriod"];
                    }
                }
                    break;
                case 2:
                {
                    if ([self.detailsDictionary[@"orderType"] isEqualToString:@"fq"]) {
                        cell.stagesNameLabel.text = @"每月还款:";
                        cell.submitPaymentLabel.text = self.detailsDictionary[@"monthlyRepayment"];
                        [cell.submitLinebottomImageView setHidden:YES];
                    }else {
                        cell.stagesNameLabel.text = @"收益说明:";
                        cell.submitPaymentLabel.text = self.detailsDictionary[@"IncomeDescription"];
                        [cell.submitLinebottomImageView setHidden:YES];
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
            
            return cell;
        }
            break;
            
        case 2:
        {
            static NSString *identity=@"JFsubmitOrderTravelInformationTableViewCellID";
            JFsubmitOrderTravelInformationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"JFsubmitOrderTravelInformationTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 1) {
                cell.TravelPersonLabel.text = @"同行人";
                [cell.submitBottomImageView setHidden:YES];
            }
            [cell.submitCountLabel setHidden:YES];
            
            return cell;
            
        }
            break;
        case 3:
        {
            static NSString *identity=@"JFsubmitOrderTravelInformationTableViewCellIDID";
            JFsubmitOrderTravelInformationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"JFsubmitOrderTravelInformationTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.TravelPersonLabel.text = @"使用优惠券";
            
            if (self.personItem.couponCount >0) {
                cell.submitCountLabel.text = [NSString stringWithFormat:@"%ld",(long)[self.personItem.couponCount integerValue]];
            }else {
                cell.submitCountLabel.text = @"暂无";
                [cell.submitBottomImageView setHidden:YES];
            }
            
            return cell;
        }
            break;
            
        case 4:
        {
            static NSString *identity=@"JFsubmitOrderRecommendedPersonTableViewCellID";
            JFsubmitOrderRecommendedPersonTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"JFsubmitOrderRecommendedPersonTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.submitOrderPhoneText = cell.RecommendedPersonTextField;
            self.submitOrderPhoneText.delegate = self;
            UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, [JFDevice screenHeight],44)];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake( [JFDevice screenWidth]- 60, 7,50, 30)];
            [button setTitle:@"完成"forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#3e93f0"] forState:UIControlStateNormal];
            [bar addSubview:button];
            cell.RecommendedPersonTextField.inputAccessoryView = bar;
            [button addTarget:self action:@selector(returnKeyboard:) forControlEvents:UIControlEventTouchUpInside];
            switch (indexPath.row) {
                case 0:
                    cell.RecommendedPersonTextField.placeholder = @"请输入手机号";
                    break;
                case 1:
                    break;
                case 2:
                    break;
                default:
                    break;
            }
            return cell;
        }
            break;
            
        case 5:
        {
            
            static NSString *identity=@"JFsubmitOrderguaranteeAgreementTableViewCellID";
            JFsubmitOrderguaranteeAgreementTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
            
            if (cell==nil) {
                
                if ([JFDevice screenHeight]<= 568) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"JFsubmitOrderguaranteeAgreementTableViewCell" owner:self options:nil]objectAtIndex:0];
                    
                }else {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"JFsubmitOrderguaranteeAgreementTableViewCell" owner:self options:nil]lastObject];
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            
            if ([self.detailsDictionary[@"orderType"] isEqualToString:@"fq"]) {
                cell.orderType = @"fq";
            }else {
                cell.orderType = @"bw";
            }
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        NSLog(@"点击");
        
        if (indexPath.row == 0) {
            JFTravelPersonInformationViewController *personViewController = [[JFTravelPersonInformationViewController alloc] initWithNibName:@"JFTravelPersonInformationViewController" bundle:nil];
            personViewController.persondelegate =self;
            personViewController.personType = @"Myself";
            personViewController.personItem = self.personItem;
            personViewController.orderType = self.detailsDictionary[@"orderType"];
            [self.navigationController pushViewController:personViewController animated:YES];
        }else {
            
            JFTravelPersonInformationViewController *personViewController = [[JFTravelPersonInformationViewController alloc] initWithNibName:@"JFTravelPersonInformationViewController" bundle:nil];
            personViewController.persondelegate =self;
            //            if (self.personInformation) {
            //                personViewController.personInformation = self.personInformation;
            //            }
            personViewController.personType = @"Peer";
            personViewController.personItem = self.personItem;
            personViewController.orderType = self.detailsDictionary[@"orderType"];
            [self.navigationController pushViewController:personViewController animated:YES];
        }
        
    }else if (indexPath.section ==3){
        NSLog(@"点击");
        JFCouponViewController *couponViewController = [[JFCouponViewController alloc] initWithNibName:@"JFCouponViewController" bundle:nil];
        [self.navigationController pushViewController:couponViewController animated:YES];
    }
}

// 设置组的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            return 170;
        }
            break;
            
        case 1:
        {
            return 44;
        }
        case 2:
        {
            return 44;
        }
            break;
        case 3:
        {
            return 44;
        }
            break;
        case 4:
        {
            return 44;
        }
            break;
        case 5:
        {
            return 135;
        }
            break;
            
        default:
            return 0;
            break;
    }
}

@end

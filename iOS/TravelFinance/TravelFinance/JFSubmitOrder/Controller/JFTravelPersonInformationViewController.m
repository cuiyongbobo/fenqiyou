//
//  JFTravelPersonInformationViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/8.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFTravelPersonInformationViewController.h"

#import "JFsubmitOrderPersonalInformationTableViewCell.h"
#import "JFsubmitOrderInformationTableViewCell.h"
#import "JFsubmitOrderFinishTableViewCellTableViewCell.h"
#import "JFDevice.h"
#import "UIColor+Hex.h"
#import "JFTravelPersonBuilder.h"
#import "JFTravelPersonParser.h"
#import "JFNetworkAFN.h"
#import "JFString.h"
#import "JFTipsWindow.h"
#import "JFMacro.h"


@interface JFTravelPersonInformationViewController ()<UITableViewDataSource,UITableViewDelegate,JFBaseTableViewCellDelegate,UITextFieldDelegate,JFURLConnectionDelegate>

@property (nonatomic,strong) NSArray *informationArray;
@property (nonatomic,strong) NSArray *informationArraySecond;

@property (nonatomic,strong) UITextField *realNameText;
@property (nonatomic,strong) UITextField *IDCardNumberText;
@property (nonatomic,strong) UITextField *phoneNumberText;
@property (nonatomic,strong) UITextField *emergencyRealNameText;
@property (nonatomic,strong) UITextField *emergencyPhoneNumberText;


@property (nonatomic, strong) JFTravelPersonItem *travelPerson;

@end

@implementation JFTravelPersonInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.PersonInformationTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.PersonInformationTableView.delegate = self;
    self.PersonInformationTableView.dataSource = self;
    [self configNavigation:@"出行人" showRightBtn:NO showLeftBtn:YES currentController:self];
    
    _informationArray = @[@"真实姓名",@"身份证号",@"手机号"];
    _informationArraySecond = @[@"真实姓名",@"手机号"];
    _phoneNumberText.delegate = self;
    _emergencyPhoneNumberText.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark navigation back

- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
}

#pragma mark - textfieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.realNameText) {
        if (![textField.text isEqualToString:self.realNameText.text] ) {
            self.realNameText.text = textField.text;
        }
    }else if (textField == self.IDCardNumberText) {
        if (![textField.text isEqualToString:self.IDCardNumberText.text] ) {
            self.IDCardNumberText.text = textField.text;
        }
    }else if (textField == self.phoneNumberText) {
        if (![textField.text isEqualToString:self.phoneNumberText.text] ) {
            self.phoneNumberText.text = textField.text;
        }
    }else if (textField == self.emergencyRealNameText) {
        if (![textField.text isEqualToString:self.emergencyRealNameText.text] ) {
            self.emergencyRealNameText.text = textField.text;
        }
    }else if (textField == self.emergencyPhoneNumberText) {
        if (![textField.text isEqualToString:self.emergencyPhoneNumberText.text] ) {
            self.emergencyPhoneNumberText.text = textField.text;
        }
    }
    
    UIView *view = textField.superview;
    while (![view isKindOfClass:[JFBaseTableViewCell class]]) {
        view = [view superview];
    }
    UITableViewCell *cell = (UITableViewCell*)view;
    CGRect rect = [cell convertRect:cell.frame toView:self.view];
    float lowHeight = [JFDevice screenHeight] - rect.origin.y / 2 + rect.size.height;
    if (rect.origin.y / 2 + rect.size.height>=[JFDevice screenHeight]-lowHeight) {
        _PersonInformationTableView.contentInset = UIEdgeInsetsMake(0, 0, 330, 0);
        [_PersonInformationTableView scrollToRowAtIndexPath:[_PersonInformationTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneNumberText) {
        NSString *verifyCode = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (verifyCode.length > 11) {
            return NO;
        }
    }else if (textField == _emergencyPhoneNumberText) {
        NSString *verifyCode = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (verifyCode.length > 11) {
            return NO;
        }
    }
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    // [aTextfield resignFirstResponder];//关闭键盘
    _PersonInformationTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_realNameText resignFirstResponder];
    [_IDCardNumberText resignFirstResponder];
    [_phoneNumberText resignFirstResponder];
    [_emergencyRealNameText resignFirstResponder];
    [_emergencyPhoneNumberText resignFirstResponder];
    return YES;
}


- (void)returnKeyboard:(id) sender{
    
    NSLog(@"回收键盘");
    _PersonInformationTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_realNameText resignFirstResponder];
    [_IDCardNumberText resignFirstResponder];
    [_phoneNumberText resignFirstResponder];
    [_emergencyRealNameText resignFirstResponder];
    [_emergencyPhoneNumberText resignFirstResponder];
    
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
            
        case JFConnectionTypeTravelPerson:
        {
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleTravelPersonResponse:responsedict];
        }
            break;
            
        default:
            break;
    }
}

- (void)handleTravelPersonResponse:(NSDictionary *)dictionary {
    
    NSLog(@"dic =%@",dictionary);
    JFTravelPersonParser *travelPersonParser = [JFTravelPersonParser sharedTravelPersonParser];
    travelPersonParser.sourceData = dictionary;
    if (travelPersonParser.code == [JFKStatusCode integerValue]) {
        self.travelPerson = travelPersonParser.travelPerson;
        
        if ([self.orderType isEqualToString:@"fq"]) {
            if ([travelPersonParser.travelPerson.isReal isEqualToString:@"0"] && [travelPersonParser.travelPerson.isBlack isEqualToString:@"0"]) {
                
                // 走业务
                NSLog(@"走业务");
                // 同人 已经实名
                JFTravelPedestrian *pedstrian = [[JFTravelPedestrian alloc] init];
                pedstrian.realName = self.realNameText.text;
                pedstrian.idCard = self.IDCardNumberText.text;
                pedstrian.mobile = self.phoneNumberText.text;
                pedstrian.contactRealName = self.emergencyRealNameText.text;
                pedstrian.contactMobile = self.emergencyPhoneNumberText.text;
                
                if ([self.persondelegate respondsToSelector:@selector(backPerson:personType:)]) {
                    [self.persondelegate backPerson:pedstrian personType:self.personType];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }else {
                [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:travelPersonParser.travelPerson.message backgroundcolor:white];
            }
            
        }else {
            
            // 白玩
            if ([travelPersonParser.travelPerson.isReal isEqualToString:@"0"]) {
                // 走业务
                NSLog(@"走业务");
                // 同人 已经实名
                JFTravelPedestrian *pedstrian = [[JFTravelPedestrian alloc] init];
                pedstrian.realName = self.realNameText.text;
                pedstrian.idCard = self.IDCardNumberText.text;
                pedstrian.mobile = self.phoneNumberText.text;
                pedstrian.contactRealName = self.emergencyRealNameText.text;
                pedstrian.contactMobile = self.emergencyPhoneNumberText.text;
                
                if ([self.persondelegate respondsToSelector:@selector(backPerson:personType:)]) {
                    [self.persondelegate backPerson:pedstrian personType:self.personType];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:travelPersonParser.travelPerson.message backgroundcolor:white];
            }
        }
        
    }else {
        
        NSLog(@"errorMessage =%@",travelPersonParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:travelPersonParser.message backgroundcolor:white];
    }
    
}


#pragma mark cell Click Even

- (void)clickCell:(id)cell tag:(JFTableCellClickType)tag userinfo:(id)userinfo {
    
    switch (tag) {
        case JFTableCellClickTypesubmitOrderFinish: {
            
            NSLog(@"完成按钮");
            
            if ([self checkPersonInformation]) {
                
                // 判断是否实名认证
                if ([self.personType isEqualToString:@"Myself"]) {
                    // 本人
                    if ([self.orderType isEqualToString:@"fq"]) {
                        
                        // 本人 已经实名
                        JFTravelPedestrian *pedstrian = [[JFTravelPedestrian alloc] init];
                        pedstrian.realName = self.realNameText.text;
                        pedstrian.idCard = self.IDCardNumberText.text;
                        pedstrian.mobile = self.phoneNumberText.text;
                        pedstrian.contactRealName = self.emergencyRealNameText.text;
                        pedstrian.contactMobile = self.emergencyPhoneNumberText.text;
                        
                        if ([self.persondelegate respondsToSelector:@selector(backPerson:personType:)]) {
                            [self.persondelegate backPerson:pedstrian personType:self.personType];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }else if([self.orderType isEqualToString:@"bw"]){
                        
                        if (!([self.personItem.financingStep integerValue]> 0)){
                            
                            // 请求接口
                            JFTravelPersonBuilder *travelPersonBuilder = [JFTravelPersonBuilder sharedTravelPerson];
                            [travelPersonBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] realName:self.realNameText.text idCardNo:self.IDCardNumberText.text validateBlack:@"1" isSelf:@"0" type:@"0"];
                            
                            JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
                            [afnet requestHttpDataWithPath:travelPersonBuilder.requestURL params:travelPersonBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
                            afnet.connectionType = JFConnectionTypeTravelPerson;
                        }else {
                            // 本人 已经实名
                            JFTravelPedestrian *pedstrian = [[JFTravelPedestrian alloc] init];
                            pedstrian.realName = self.realNameText.text;
                            pedstrian.idCard = self.IDCardNumberText.text;
                            pedstrian.mobile = self.phoneNumberText.text;
                            pedstrian.contactRealName = self.emergencyRealNameText.text;
                            pedstrian.contactMobile = self.emergencyPhoneNumberText.text;
                            
                            if ([self.persondelegate respondsToSelector:@selector(backPerson:personType:)]) {
                                [self.persondelegate backPerson:pedstrian personType:self.personType];
                            }
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                    
                }else {
                    // 同行人
                    if ([self.orderType isEqualToString:@"fq"]) {
                        // 请求接口
                        JFTravelPersonBuilder *travelPersonBuilder = [JFTravelPersonBuilder sharedTravelPerson];
                        [travelPersonBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] realName:self.realNameText.text idCardNo:self.IDCardNumberText.text validateBlack:@"0" isSelf:@"1" type:@"1"];
                        
                        JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
                        [afnet requestHttpDataWithPath:travelPersonBuilder.requestURL params:travelPersonBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
                        afnet.connectionType = JFConnectionTypeTravelPerson;
                        
                    }else if([self.orderType isEqualToString:@"bw"]){
                        
                        // 请求接口
                        JFTravelPersonBuilder *travelPersonBuilder = [JFTravelPersonBuilder sharedTravelPerson];
                        [travelPersonBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] realName:self.realNameText.text idCardNo:self.IDCardNumberText.text validateBlack:@"1" isSelf:@"1" type:@"0"];
                        
                        JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
                        [afnet requestHttpDataWithPath:travelPersonBuilder.requestURL params:travelPersonBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
                        afnet.connectionType = JFConnectionTypeTravelPerson;
                        
                    }
                    
                }
                
                
            }
            
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark check Person

- (BOOL)checkPersonInformation {
    BOOL continuePay = NO;
    if ([self.personType isEqualToString:@"Myself"]) {
        
        // 姓名
        // [self isMobileNumber:self.realNameText.text]
        if ([self isChineseName:self.realNameText.text]) {
            
            // 身份证
            if (![JFString judgeString:self.IDCardNumberText.text]) {
                
                // 本人手机号
                if ([self isMobileNumber:self.phoneNumberText.text]) {
                    
                    // 联系人姓名
                    if ([self isChineseName:self.emergencyRealNameText.text]) {
                        
                        // 联系人手机号
                        // [self isMobileNumber:self.emergencyPhoneNumberText.text]
                        if ([self isMobileNumber:self.emergencyPhoneNumberText.text]) {
                            
                            if ([self.realNameText.text isEqualToString:self.emergencyRealNameText.text] && [self.phoneNumberText.text isEqualToString:self.emergencyPhoneNumberText.text]) {
                                
                                [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"联系人信息不能与本人信息相同" backgroundcolor:white];
                            }else {
                                // 非空验证完毕
                                continuePay = YES;
                            }
                            
                        }else {
                            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请输入联系人有效手机号" backgroundcolor:white];
                        }
                        
                    }else {
                        
                        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请输入有效联系人姓名" backgroundcolor:white];
                        
                    }
                    
                }else {
                    [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请输入本人有效手机号" backgroundcolor:white];
                }
                
            }else {
                
                [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请输入身份证号" backgroundcolor:white];
            }
            
            
        }else {
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请输入本人姓名" backgroundcolor:white];
        }
        
        
    }else {
        
        // 同行人
        
        // 姓名
        if (![JFString judgeString:self.realNameText.text]) {
            
            // 身份证
            if (![JFString judgeString:self.IDCardNumberText.text]) {
                
                // 本人手机号
                if ([self isMobileNumber:self.phoneNumberText.text]) {
                    
                    continuePay = YES;
                }else {
                    [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请输入同行人手有效机号" backgroundcolor:white];
                }
                
            }else {
                
                [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请输入身份证号" backgroundcolor:white];
            }
            
            
        }else {
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请输入同行人姓名" backgroundcolor:white];
        }
        
    }
    return continuePay;
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


- (BOOL)isChineseName:(NSString *)name {
    NSString * phoneRegex = @"^([\u4e00-\u9fa5]){2,7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if ([regextestmobile evaluateWithObject:name]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

#pragma mark tableViewDelegate Even

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    if ([_personType isEqualToString:@"Myself"]) {
    //        return 2;
    //    }else {
    //        return 2;
    //    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else if (section == 1){
        if ([_personType isEqualToString:@"Peer"]) {
            return 1;
        }else {
            return 4;
        }
    }else {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                static NSString *identity=@"JFsubmitOrderPersonalInformationTableViewCellIDs";
                JFsubmitOrderPersonalInformationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
                
                if (cell==nil) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"JFsubmitOrderPersonalInformationTableViewCell" owner:self options:nil]lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if ([_personType isEqualToString:@"Peer"]) {
                    cell.submitPersonInformationLabel.text =@"同行人信息";
                }
                return cell;
                
            }else {
                
                static NSString *identity=@"JFsubmitOrderInformationTableViewCellIDs";
                JFsubmitOrderInformationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
                if (cell==nil) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"JFsubmitOrderInformationTableViewCell" owner:self options:nil]lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (_informationArray.count > indexPath.row-1) {
                    cell.submitNameLabel.text = _informationArray[indexPath.row-1];
                }
                
                //
                switch (indexPath.row) {
                    case 1:
                    {
                        
                        if ([JFString judgeString:self.realNameText.text]) {
                            cell.submitRealNameText.placeholder = @"请输入真实姓名";
                            self.realNameText = cell.submitRealNameText;
                        }else {
                            
                            cell.submitRealNameText.text = self.realNameText.text;
                            self.realNameText = cell.submitRealNameText;
                        }
                        
                        if ([self.personType isEqualToString:@"Myself"]) {
                            
                            // 是本人
                            if ([self.orderType isEqualToString:@"fq"]) {
                                
                                if ([self.personItem.stageStep integerValue] >0) {
                                    cell.submitRealNameText.text = self.personItem.realName;
                                    cell.submitRealNameText.enabled = NO;
                                }
                                
                            }else if ([self.orderType isEqualToString:@"bw"]) {
                                if ([self.personItem.financingStep integerValue] >0) {
                                    cell.submitRealNameText.text = self.personItem.realName;
                                    cell.submitRealNameText.enabled = NO;
                                }
                            }
                        }
                    }
                        break;
                    case 2:
                    {
                        if ([JFString judgeString:self.IDCardNumberText.text]) {
                            cell.submitRealNameText.placeholder = @"请输入身份证号";
                            self.IDCardNumberText = cell.submitRealNameText;
                        }else {
                            cell.submitRealNameText.text = self.IDCardNumberText.text;
                            self.IDCardNumberText = cell.submitRealNameText;
                        }
                        
                        if ([self.personType isEqualToString:@"Myself"]) {
                            if ([self.orderType isEqualToString:@"fq"]) {
                                if ([self.personItem.stageStep integerValue] >0) {
                                    cell.submitRealNameText.text = self.personItem.idCardNo;
                                    cell.submitRealNameText.enabled = NO;
                                }
                                
                            }else if ([self.orderType isEqualToString:@"bw"]) {
                                if ([self.personItem.financingStep integerValue] >0) {
                                    cell.submitRealNameText.text = self.personItem.idCardNo;
                                    cell.submitRealNameText.enabled = NO;
                                }
                            }
                        }
                    }
                        break;
                    case 3:
                    {
                        if ([JFString judgeString:self.phoneNumberText.text]) {
                            cell.submitRealNameText.placeholder = @"请输入手机号";
                            cell.submitRealNameText.keyboardType = UIKeyboardTypeNumberPad;
                            self.phoneNumberText = cell.submitRealNameText;
                        }else {
                            cell.submitRealNameText.text = self.phoneNumberText.text;
                            cell.submitRealNameText.keyboardType = UIKeyboardTypeNumberPad;
                            self.phoneNumberText = cell.submitRealNameText;
                        }
                        
                        
                        if ([self.personType isEqualToString:@"Myself"]) {
                            if ([self.orderType isEqualToString:@"fq"]) {
                                if ([self.personItem.stageStep integerValue] >0) {
                                    cell.submitRealNameText.text = self.personItem.mobile;
                                    cell.submitRealNameText.enabled = NO;
                                }
                                
                            }else if ([self.orderType isEqualToString:@"bw"]) {
                                if ([self.personItem.financingStep integerValue] >0) {
                                    cell.submitRealNameText.text = self.personItem.mobile;
                                    cell.submitRealNameText.enabled = NO;
                                }
                            }
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
                
                cell.submitRealNameText.delegate = self;
                UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, [JFDevice screenHeight],44)];
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake( [JFDevice screenWidth]- 60, 7,50, 30)];
                [button setTitle:@"完成"forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithHexString:@"#3e93f0"] forState:UIControlStateNormal];
                [bar addSubview:button];
                cell.submitRealNameText.inputAccessoryView = bar;
                [button addTarget:self action:@selector(returnKeyboard:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                
                if ([_personType isEqualToString:@"Peer"]) {
                    
                    static NSString *identity=@"JFsubmitOrderFinishTableViewCellTableViewCellIDs";
                    JFsubmitOrderFinishTableViewCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
                    if (cell==nil) {
                        cell=[[[NSBundle mainBundle]loadNibNamed:@"JFsubmitOrderFinishTableViewCellTableViewCell" owner:self options:nil]lastObject];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                    return cell;
                    
                }else {
                    static NSString *identity=@"JFsubmitOrderPersonalInformationTableViewCellID";
                    JFsubmitOrderPersonalInformationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
                    if (cell==nil) {
                        cell=[[[NSBundle mainBundle]loadNibNamed:@"JFsubmitOrderPersonalInformationTableViewCell" owner:self options:nil]lastObject];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.submitPersonInformationLabel.text = @"紧急联系人信息";
                    return cell;
                }
                
            }else {
                
                if (indexPath.row == 3) {
                    static NSString *identity=@"JFsubmitOrderFinishTableViewCellTableViewCellID";
                    JFsubmitOrderFinishTableViewCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
                    if (cell==nil) {
                        cell=[[[NSBundle mainBundle]loadNibNamed:@"JFsubmitOrderFinishTableViewCellTableViewCell" owner:self options:nil]lastObject];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                    return cell;
                }else {
                    static NSString *identity=@"JFsubmitOrderInformationTableViewCellID";
                    JFsubmitOrderInformationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
                    if (cell==nil) {
                        cell=[[[NSBundle mainBundle]loadNibNamed:@"JFsubmitOrderInformationTableViewCell" owner:self options:nil]lastObject];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.submitNameLabel.text = _informationArraySecond[indexPath.row-1];
                    
                    switch (indexPath.row) {
                        case 1:
                        {
                            if ([JFString judgeString:self.emergencyRealNameText.text]) {
                                cell.submitRealNameText.placeholder = @"请输入联系人姓名";
//                                cell.submitRealNameText.returnKeyType = UIReturnKeyDefault;
                                self.emergencyRealNameText = cell.submitRealNameText;
                            }else {
                                cell.submitRealNameText.text = self.emergencyRealNameText.text;
                                self.emergencyRealNameText = cell.submitRealNameText;
                            }
                            
                        }
                            break;
                        case 2:
                        {
                            
                            if ([JFString judgeString:self.emergencyPhoneNumberText.text]) {
                                cell.submitRealNameText.placeholder = @"请输入手机号";
                                cell.submitRealNameText.keyboardType = UIKeyboardTypeNumberPad;
                                self.emergencyPhoneNumberText = cell.submitRealNameText;
                            }else {
                                cell.submitRealNameText.text = self.emergencyPhoneNumberText.text;
                                cell.submitRealNameText.keyboardType = UIKeyboardTypeNumberPad;
                                self.emergencyPhoneNumberText = cell.submitRealNameText;
                            }
                            
                        }
                            break;
                            
                        default:
                            break;
                    }
                    cell.submitRealNameText.delegate = self;
                    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, [JFDevice screenHeight],44)];
                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake( [JFDevice screenWidth]- 60, 7,50, 30)];
                    [button setTitle:@"完成"forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithHexString:@"#3e93f0"] forState:UIControlStateNormal];
                    [bar addSubview:button];
                    cell.submitRealNameText.inputAccessoryView = bar;
                    [button addTarget:self action:@selector(returnKeyboard:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                }
            }
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


// 设置组的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.1;
    }else if (section == 1){
        if ([_personType isEqualToString:@"Peer"]) {
            return 0.1;
        }else {
            return 10;
        }
        
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            return 44;
        }
            break;
        case 1:
        {
            if ([_personType isEqualToString:@"Peer"]) {
                return 100;
            }else {
                if (indexPath.row == 3) {
                    return 100;
                }
                return 44;
            }
        }
            break;
        default:
            return 0;
            break;
    }
}



@end

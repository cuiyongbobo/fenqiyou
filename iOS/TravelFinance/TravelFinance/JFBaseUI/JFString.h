//
//  JFString.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

static NSString * const JFKStatusCode = @"1000";

static NSString * const JFKTerminalType = @"3";

static NSString * const JFKAccount = @"我的";

static NSString * const JFKStagingTour = @"分期游";

static NSString * const JFKUserPhoneNumber = @"phoneNumber";

static NSString * const JFKUserId = @"userId";

static NSString * const JFKIsReal = @"isReal";

static NSString * const JFKImplementGuide = @"guide";

static NSString * const JFKHelpCenterRequestURL = @"/app/helpCenter";

static NSString * const JFKAboutUsRequestURL = @"/app/aboutUs";

static NSString * const JFKStageOrderRequestURL = @"/app/appBill?userId=1e796844e984469d&fqCode=5";

static NSString * const JFKOverdueRepaymentRequestURL = @"/app/appBill?userId=1e796844e984469d&fqCode=1";

static NSString * const JFKNoBillsRequestURL = @"/app/appBill?userId=1e796844e984469d&fqCode=3";

static NSString * const JFKMonthlyRepaymentRequestURL = @"/app/appBill?userId=1e796844e984469d&fqCode=2";

static NSString * const JFKAllBillsRequestURL = @"/app/appBill?userId=1e796844e984469d&fqCode=4";

static NSString * const JFKImmediateRepaymentRequestURL = @"/app/appBill?userId=1e796844e984469d&fqCode=6";




static NSString * const JFKSexSave = @"sex";

static NSString * const KYKNetErrorMessage = @"您的网络信号不给力，请稍候重试。";

static NSString * const JFKLoadingMessage = @"努力加载中..";

static NSString * const JFKCreditAuthorization = @"CreditAuthorization";

static NSString * const JFKSesameAuthorization = @"SesameAuthorization";

static NSString * const JFKBankStatusCode = @"3017"; // 已经开户

static NSString * const KYKWithdrawals = @"转出";

static NSString * const KYKWithdrawalsPayAction = @"转出确认";

static NSString * const KYKFeedback = @"用户反馈";

static NSString * const KYKMyInfo = @"我的资料";

static NSString * const KYKMyBankCards = @"我的银行卡";

static NSString * const KYKAddBankCard = @"添加银行卡";

static NSString * const KYKChangeCard = @"更换银行卡";

static NSString * const KYKChangeCardResult = @"更换银行卡结果";

static NSString * const KYKAnnouncement = @"公告";

static NSString * const KYKListNoMore = @"没有更多了";

static NSString * const KYKTrnsferOut = @"转出";

static NSString * const KYKPayCardCheckingStatus = @"审核结果";

static NSString * const KYKTransferOutSellType = @"KYKTransferOutSellType";

static NSString * const kNotificationReservationPushString = @"您预约的本期简理财项目将于5分钟后发布，好多人在排队，悄悄告诉您，马上准备抢购吧！";

static NSString * const KYKSetPayPassword = @"设置支付密码";

static NSString * const KYKConfirmPayPassword = @"确认支付密码";

static NSString * const KYKFindPayPassword = @"找回支付密码";

static NSString * const KYKModifyPayPassword = @"修改支付密码";

static NSString * const KYKHomeTotalAssets= @"总资产明细";

static NSString * const KYKHomeTotalEarnins= @"收益明细";

static NSString * const KYKHomeCurrent = @"可转出资产";

static NSString * const KYKLoadBuy= @"买入";

static NSString * const KYKTradeDetail= @"交易详情";

static NSString * const KYKAddRate = @"加息计划";

static NSString * const KYKAddRateAssets = @"加息计划明细";

static NSString * const KYKAddRateAdvanceTurnOut = @"提前退出";

static NSString * const YKYAddRateTurnInDetail = @"加入详情";

static NSString * const KYKAddRateTurnOutDetail = @"退出详情";

static NSString * const KYKAddRateExperienceGoldList = @"待激活体验金";

static NSString * const KYKAuthentication = @"实名认证";

static NSString * const KYKWagesPlan = @"工资理财计划";

static NSString * const KYKRentPlan = @"房租计划";

static NSString *const  KYKJoinedMortgagePlan = @"房贷计划";

static NSString * const KYKWagesRecord = @"工资计划记录";

static NSString * const KYKMortgageRecord = @"房贷计划记录";

static NSString * const KYKRentRecord = @"房租计划记录";

static NSString * const KYKUdeskRobot = @"自助客服";

static NSString * const KYKUdeskChat = @"人工客服";

static NSString * const KYKUdeskFeedbackTicket = @"提交问题";

static NSString * const KYKHomeTotalAssetsGetEmail = @"发送协议";

static NSString * const KYKHomeTotalAssetsCheckIdentifyCard = @"身份验证";

static NSString * const KYKHomeTotalSendProtocol = @"发送协议";

static NSString * const KYKHomeTotalSendProtocolResult = @"发送结果";

static NSString * const KYKDreamPlan = @"梦想计划"; // 梦想计划列表、设置、详情三个页面

static NSString * const KYKDreamPlanAssets = @"梦想计划明细";

static NSString * const KYKDreamPlanStopResult = @"计划详情";


static NSString * const KYKConnectionTypeError = @"您请求的服务暂无响应";


static NSString * const KYKWithoutNetworkFooterViewTip = @"没有网络，点击重新加载";
static NSString * const KYKMJRefreshFooterNoMoreData = @"所有数据加载完毕，没有更多的数据了";
static NSString * const KYKMJRefreshFooterLoadMoreData = @"下拉加载更多";

static NSString * const KYKHomeToBeMatchAssets = @"待匹配";

static NSString * const KYKHomeHaveMatchAssets = @"已匹配资产";

static NSString * const KYKChangePhoneNumber = @"更换手机号";

static NSString * const KYKSendDeclaractionTemplate = @"发送声明模版";

static NSString * const JFKSetGesturePassword = @"alreadySet";

static CGFloat const kYKButtonFontSize = 16;

@interface JFString : NSObject

+ (NSString *)numberStrToWanWith:(NSString *)numberStr;

/*
 将数字转化为千分位 默认摸出小数点后2位，若有其他需求，请使用注释掉的函数
 symbol 货币标记
 number 数值
 */

+ (NSString *)getCurrency:(double)number;


//最后几块多，几十多，几百多
+ (NSString *)chineseWithNumber:(double)number;

//手机号码格式化
+ (NSString *)formatPhoneNumber:(NSString *)phoneNumber;

//银行卡号格式化
+ (NSString *)formatBankCardNumber:(NSString *)bankCardNumber;

//+ (NSString *)getIntegerValue:(double)number;

+ (NSString *)intValueStringFromDouble:(double)number;

+ (NSString *)doubleValueStringFromDouble:(double)number;

+ (BOOL)isContainEmoji:(NSString *)string;

+ (BOOL)judgeString:(NSString *)string;


@end

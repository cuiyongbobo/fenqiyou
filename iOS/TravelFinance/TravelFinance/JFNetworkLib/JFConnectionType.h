//
//  JFConnectionType.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/27.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#ifndef JFConnectionType_h
#define JFConnectionType_h

/**
 *  u9json类型网络请求与响应类型
 */

typedef NS_ENUM(NSUInteger, YKConnectionType) {
    
    /* 账户/项目类 */
    
    // YKConnectionTypeNone                       = 0,         /* 无意义接口 */
    
    JFConnectionTypeTravelOrder                      = 98,        /* 出行订单 */
    
    JFConnectionTypePersonalCenter                     = 99,        /* 个人中心 */
    
    JFConnectionTypeQuota                       = 100,       /* 获取额度 */
    
    JFConnectionTypeSesameAuthorizationdecryp           = 101,       /* 加载简理财详情 */
    
    JFConnectionTypeSesameAuthorizationEncryp                = 102,       /* 芝麻授权加密 */
    
    JFConnectionTypeBankList           = 103,       /* 银行卡列表 */
    
    JFConnectionTyPepayment           = 104,       /* 支付 */
    
    JFConnectionTypeBindingCard        = 105,       /* 绑卡 */
    
    JFConnectionTypeTravelPerson           = 106,       /* 实名认证 */
    
    JFConnectionTypeUserCreditInformation            = 107,       /* 用户授信信息 */
    
    JFConnectionTypeLineListBW          = 108,       /* 白玩线路列表 */
    
    JFConnectionTypestagingTourList  = 109,       /* 精选 */
    
    JFConnectionTypestagingTour            = 110,       /* 主页 */
    
    JFConnectionTypePhoneCheck                      = 150,       /* 注册登录 */
    
    JFConnectionTypeSendCodeRegister              = 151,       /* 发送短信码 */
    
    JFConnectionTypeRegister     = 152,       /* 上传头像 */
    
    JFConnectionTypeLogin       = 153,       /* 密码登录 */
    
    JFConnectionTypedynamicLogin      = 154,       /* 动态码登录 */
    
    JFConnectionTypeSpecial         = 155,       /* 专题 */
    
    JFConnectionTypeOpendingStageCredit    = 156,       /* 信用卡授权 */
    
    JFConnectionTypealReadyTravelOrder                      = 157,       /* 已出发订单 */
    
    JFConnectionTypeCancelTravelOrder         = 158,       /* 取消的订单 */
    
    JFConnectionTypeInvestmentOrder       = 159,       /* 投资订单 */
    
    JFConnectionTypeInvestmentQuitOrder            = 160,       /* 已经退出的投资订单 */
    
    JFConnectionTypePersonInformation        = 161,       /* 个人信息 */
    
    JFConnectionTypeResetLoginPassword = 162,       /* 重置登录密码 */
    
    JFConnectionTypeUpdateVersion       = 163,       /* 版本更新 */
    
    JFConnectionTypePullBankInformation              = 164,       /* 发送投资协议 */
    
    YKConnectionTypeReplacementBankCardSendMsg = 165,       /* 用户审核通过验证银行预留手机号 */
    
    JFConnectionTypeIDDisting            = 166,       /* 加息计划信息 */
    
    YKConnectionTypeLoadAdvanceTurnOutInfo     = 167,       /* 提前转出详情 */
    
    YKConnectionTypeLoadOrderAddRate           = 168,       /* 预约加息计划 */
    
    YKConnectionTypeLoadAddRateAssets          = 169,       /* 加息计划明细 */
    
    YKConnectionTypeLoadAddRateDetail          = 170,       /* 加息计划详情 */
    
    YKConnectionTypeuploadChangeCardInfo       = 171,       /* 上传用户审核资料 */
    
    KConnectionTypeAccountUploadImage          = 172,       /* 上传审核照片 */
    
    KConnectionTypeLoadTradeRecordDetail       = 173,       /* 获取交易记录详情 */
    
    YKConnectionTypeCheckUserType              = 174,       /* 新老用户判断 */
    
    YKConnectionTypeHomeGetEmail               = 175,       /* 获取邮箱 */
    
    YKConnectionTypeHomeCheckIdentifyCard      = 176,       /* 合同下载身份验证*/
    
    YKConnectionTypeLoadBankInfo               = 178,       /* 校验银行卡 */
    
    YKConnectionTypeLogout                     = 180,       /* 退出登录 */
    
    YKConnectionTypeLoadToBeMatchAssets        = 181,        /* 加载待匹配资产 */
    
    YKConnectionTypeLoadChangePhoneNumber      = 182,        /* 更改手机号 */
    
    YKConnectionTypeLoadLoginSms               = 183,        /* 获取登录短信信息 */
    
    YKConnectionTypeCheckLoginSmsStatus        = 184,        /* 获取短信登录状态 */
    
    /* 资金理财类 */
    
    YKConnectionTypeLoadBankList               = 200,       /* 加载银行卡列表 */
    
    YKConnectionTypeLoadWithdrawals            = 201,       /* 加载提现页面信息 */
    
    YKConnectionTypeCashToAccount              = 202,       /* 提现到账户：余额或银行卡 */
    
    YKConnectionTypeCheckWithdrawals           = 203,       /* 检查提现是否超限：次数和金额 */
    
    YKConnectionTypeTranferOut                 = 204,       /* 加载转出信息 */
    
    YKConnectionTypeSumitTransferOut           = 205,       /* 提交转出信息 */
    
    YKConnectionTypeLoadTranferIn              = 206,       /* 加载赎买信息 */
    
    YKConnectionTypeSubmitTransferIn           = 207,       /* 提交购买信息 */
    
    YKConnectionTypeSendSMS                    = 208,       /* 发送短信验证码 */
    
    YKConnectionTypeCmbcBindcard               = 209,       /* 民生绑卡 */
    
    YKConnectionTypeCmbcRecharge               = 210,       /* 民生充值 */
    
    YKConnectionTypeCmbcCardtrade              = 211,       /* 民生验卡扣款5块钱验证 */
    
    YKConnectionTypeCheckSellCount             = 212,       /* 检查转出次数是否超限 */
    
    YKConnectionTypeCheckBankStatus            = 213,       /* 检查购买时银行是否维护 */
    
    YKConnectionTypeCheckCardAvailable         = 214,       /* 验证该卡是否可绑定 */
    
    YKConnectionTypeLoadAddRateTurnIn          = 215,       /* 转入加息计划 */
    
    YKConnectionTypeLoadAddRateTurnOut         = 216,       /* 转出加息计划 */
    
    YKConnectionTypeCheckBuyStatus             = 217,       /* 检查买入状态 */
    
    YKConnectionTypeSubmitAlipay               = 218,       /* 提交支付宝买入信息*/
    
    YKConnectionTypeLoadCertification          = 219,       /* 实名认证 */
    
    YKConnectionTypeLoadPaySms                 = 220,       /* 支付短信验证码 */
    
    YKConnectionTypeSubmitSmsBuy               = 221,       /* 校验短信支付 */
    
    YKConnectionTypeLoadBindCardInfo           = 222,       /* 获取绑卡信息 */
    
    YKConnectionTypeBindCardSmsVerify          = 223,        /* 添加绑卡 */
    
    /* 运营活动类 */
    
    YKConnectionTypeLoadEventsPage             = 300,       /* 加载活动页面列表即发现列表 */
    
    YKConnectionTypeAnnouncementList           = 301,       /* 加载公告列表 */
    
    YKConnectionTypeLoadNotification           = 302,       /* 加载消息弹窗 */
    
    YKConnectionTypeLoadSharedImage            = 303,       /* 加载分享图片信息 */
    
    YKConnectionTypeTipViewState               = 304,       /* 加载工具栏角标状态 */
    
    YKConnectionTypeHavePrivilegePrincipal     = 310,       /* 检查用户是否有特权本金 */
    
    YKConnectionTypeUserloadPrivilegePrincipal = 311,       /* 加载简理财页特权本金 */
    
    YKConnectionTypeUserloadBanner             = 312,       /* 加载banner广告 */
    
    YKConnectionTypeLoadEventIcon              = 313,       /* 加载拖拽浮动icon */
    
    YKConnectionTypeUpdateNewTaskStatus        = 314,       /* 改变新手引导状态 */
    
    YKConnectionTypeUpdateOperationTaskStatus  = 315,       /* 更改用户任务状态 */
    
    YKConnectionTypeGiveMePraise               = 316,       /* 是否显示给我好评 */
    
    YKConnectionTypeLoadOperationPage          = 317,       /* 加载发现模块运营列表 */
    
    YKConnectionTypeUploadWeChatUserInfo       = 318,       /* 上传微信用户信息 */
    
    YKConnectionTypesendRoseToSomeBody         = 319,       /* 上传扒花游戏用户信息 */
    
    YKConnectionTypeConfigCenter               = 320,       /* 配置中心 */
    
    YKConnectionTypeLoadRedDotStatus           = 322,        /* 启动页，发现、公告小红点合并接口 */
    
    YKConnectionTypeLoadWeChatAccessToken      = 9001,      /* 获取微信授权的accessToken */
    
    YKConnectionTypeLoadWeChatUserInfo         = 9002,      /* 获取微信授权的用户信息 */
    
    YKConnectionTypeBuriedPointSDKAccess       = 9003,      /* 埋点SDK鉴权 */
    
    YKConnectionTypeBuriedPointSDKUpload       = 9004,      /* 埋点SDK数据上传 */
    
    
    /* 理财计划类 */
    
    YKConnectionTypeLoadPlansList              = 400,       /* 加载计划页面列表 */
    
    YKConnectionTypeLoadHasJoinedWagesPlan     = 401,       /* 已加入工资计划接口 */
    
    YKConnectionTypeLoadNotJoinedWagesPlan     = 402,       /* 未加入工资计划接口 */
    
    YKConnectionTypeLoadJoinedWagesPlan        = 403,       /* 工资计划设置和修改以及加入页*/
    
    YKConnectionTypeLoadWagesPlanRecord        = 404,       /* 工资理财记录 */
    
    YKConnectionTypeLoadHasJoinedMortgagePlan  = 405,       /* 已加入房贷计划*/
    
    YKConnectionTypeLoadJoinedMortgagePlan     = 406,       /* 房贷计划设置和修改页*/
    
    YKConnectionTypeLoadMortgagePlanWithdraw   = 407,       /* 房贷计划提现结果*/
    
    YKConnectionTypeLoadMortgagePlanRecord     = 408,       /* 房贷计划记录*/
    
    YKConnectionTypeLoadHasJoinedRentPlan      = 409,       /* 已加入房租计划接口 */
    
    YKConnectionTypeLoadNotJoinedRentPlan      = 410,       /* 未加入房租计划接口 */
    
    YKConnectionTypeLoadWithdrawRentPlan       = 411,       /* 房租计划提现接口 */
    
    YKConnectionTypeLoadRentPlanRecord         = 412,       /* 房租计划记录接口 */
    
    YKConnectionTypeLoadStopPlans              = 413,       /* 终止计划 */
    
    YKConnectionTypeLoadDreamPlanList          = 414,       /* 梦想计划攒钱中列表 */
    
    YKConnectionTypeLoadDreamPlanSetting       = 415,       /* 梦想计划设置页 */
    
    YKConnectionTypeLoadCreateDreamPlan        = 416,       /* 创建梦想计划 */
    
    YKConnectionTypeLoadDreamPlanDetail        = 417,       /* 梦想计划详情页 */
    
    YKConnectionTypeLoadSavingMoneyDreamPlan   = 418,       /* 梦想计划详情页立即为梦想加速 */
    
    YKConnectionTypeLoadStopDreamPlan          = 419,       /* 梦想计划详情页终止梦想计划 */
    
    YKConnectionTypeLoadDreamPlanAssetsList    = 420,       /* 梦想计划资产明细接口 */
    
    
    
};


#endif /* JFConnectionType_h */

//
//  STIDCard.h
//  lib_st_idcard
//
//  Created by makun on 3/2/15.
//  Copyright (c) 2015 SenseTime. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, STIDCardMode)
{
    kIDCardSmart = 0    ,   //身份证正面反面智能检测
    kIDCardFrontal      ,   //身份证正面
    kIDCardBack         ,   //身份证反面
    kIDCardBothSides        //身份证正反两面都尝试
};

typedef NS_ENUM(NSInteger, STIDCardSide)
{
    STIDCardSideFront = 1,  //身份证正面
    STIDCardSideBack,       //身份证反面
};

typedef NS_ENUM(NSInteger, STIDCardType)
{
    STIDCardTypeUnknow = 0,	///< 未知
    STIDCardTypeNormal,		///< 正常身份证
    STIDCardTypeTemp		///< 临时身份证
};

typedef NS_OPTIONS(uint32_t, STIDCardItemOption) {
    kIDCardItemAll = 0,            ///全部包括
    kIDCardItemName = 1<<0,			///< 姓名
    kIDCardItemSex = 1<<1,			///< 性别
    kIDCardItemNation = 1<<2,     ///< 民族
    kIDCardItemBirthday = 1<<3,		///< 生日
    kIDCardItemAddr = 1<<4,		///< 地址
    kIDCardItemNum = 1<<5,			///< 身份证号
    kIDCardItemAuthority = 1<<6,		///< 签发机关
    kIDCardItemTimelimit = 1<<7,		///< 有效期限
};

/*! @brief STIDCard 函数类
 *
 * 该类封装了SenseTime的全自动身份证检测和识别功能
 */

@interface STIDCard : NSObject



@property (nonatomic, strong, readonly) NSString    *strVersion   ;   //SDK版本号

// Foreground Content
@property (nonatomic, strong, readonly) NSString    *strName    ;   //姓名
@property (nonatomic, strong, readonly) NSString    *strSex     ;   //性别
@property (nonatomic, strong, readonly) NSString    *strNation  ;   //民族
@property (nonatomic, strong, readonly) NSString    *strYear    ;   //出生年
@property (nonatomic, strong, readonly) NSString    *strMonth   ;   //出生月
@property (nonatomic, strong, readonly) NSString    *strDay     ;   //出生日
@property (nonatomic, strong, readonly) NSString    *strAddress ;   //住址
@property (nonatomic, strong, readonly) NSString    *strID      ;   //公民身份证号

// Background Content
@property (nonatomic, strong, readonly) NSString    *strAuthority;   //签发机关
@property (nonatomic, strong, readonly) NSString    *strValidity ;   //有效期

// Image of Card & Face
@property (nonatomic, strong, readonly) UIImage    *imgOriginCaptured;     //摄像头捕捉到的图像
@property (nonatomic, strong, readonly) UIImage    *imgCardDetected    ;   //检测出的卡片图像
@property (nonatomic, strong, readonly) UIImage    *imgCardFace        ;   //检测出的卡片人像

//CGRect of
@property (nonatomic, assign, readonly) CGRect    rectName    ;   //从检测出的卡片图像获取的姓名位置
@property (nonatomic, assign, readonly) CGRect    rectID      ;   //从检测出的卡片图像获取的公民身份证号位置

@property (nonatomic, strong, readonly) NSString    *strDate   ;   //出生年月日

/*! @brief iMode 控制识别身份证哪个面：
 *              0 - kIDCardFrontal   - 正面 ,
 *              1 - kIDCardBack      - 反面,
 *              2 - kIDCardBothSides - 双面识别
 *              3 - kIDCardSmart     - 智能检测 （default）
 */
@property (nonatomic, assign)   STIDCardMode    iMode  ;

/// 表示检测到的身份证是那个面
@property (nonatomic, readonly) STIDCardSide side;

@property (nonatomic, readonly) STIDCardType type;
//No： try Rect Detection & full size as cropped Rect in recognizeCardWithBuffer

/*! @brief bFaceExist 是否存在人像
 */
@property (nonatomic, assign) BOOL bFaceExist ;

@property (nonatomic, assign, readonly)   BOOL    bTempIDCard  ;// 是否是临时身份证


/*!
 * @brief STIDCard 初始化函数
 *
 * 在使用身份证识别功能之前调用, 可以初始化一次，多次进行身份证识别。
 * 身份证识别依赖若干识别数据文件（*.dat）,请完整加入应用工程，否则初始化不成功，返回nil。
 *
 * @param 无需
 * @return 如果数据完整，初始化成功，返回 STIDCard 对象；否则返回 nil 。
 *          初始化不成功一般是由于没有导入SDK必须的数据文件（*.dat）
 */
- (instancetype)init ;
/**
 *	@brief	 用于配置用户的api账户。需要在扫描之前进行配置。否则无法返回结果。建议在app启动时配置。
 *
 *	@param 	apiID 	用户账户的API ID
 *	@param 	apiSecret 	用户账户的API SECRET
 */
+(void)setupTheAPIAccountWithID:(NSString *)apiID andWithSecret:(NSString *)apiSecret;

/*! @brief recognizeCard 接口提供身份证检测和识别功能，用于图片输入
 *
 * 上传图片最大大小 5MB,图片分辨率最大支持 3000px*3000px，过小分辨率可能导致识别不出小的文字
 * @param imageCard 上传的图片
 * @return 检测识别结果的状态。
 *          -2 : 无图像
 *          -1 : 检测不成功
 *          -3 : 检测成功, Alignment 不成功 (v3.4)
 *          -5 : API账户授权错误
 *           0 : 检测成功，识别不成功
 *           1 : 识别有误，校验不成功
 *           2 : 识别成功
 *       当识别成功后，请在上述成员变量strName, ... , strAuthority 中获取识别结果
 *       也可调用下面的【getFrontalInfo 】函数获取识别结果的正面文字信息
 *       也可调用下面的【getBackSideInfo】函数获取识别结果的反面文字信息
 */
- (int) recognizeCard:(UIImage *)imageCard ;

/*! @brief recognizeCardWithBuffer 接口提供身份证检测和识别功能，用于视频帧数据输入
 *
 * @param pImageCard 视频帧数据，格式是BGRA格式
 * @param iWidth    视频帧图像的宽度
 * @param iHeight   视频帧图像的高度
 * @return 检测识别结果的状态。
 *          -2 : 无图像
 *          -1 : 检测不成功
 *          -3 : 检测成功, Alignment 不成功 (v3.4)
 *           0 : 检测成功，识别不成功
 *           1 : 识别有误，校验不成功
 *           2 : 识别成功
 *       当识别成功后，请在上述成员变量strName, ... , strAuthority 中获取识别结果
 *       也可调用下面的【getFrontalInfo 】函数获取识别结果的正面文字信息
 *       也可调用下面的【getBackSideInfo】函数获取识别结果的反面文字信息
 */
- (int) recognizeCardWithBuffer:(unsigned char *) pImageCard  width:(int) iWidth height:(int)iHeight ;

/*! @brief getFrontalInfo 接口提供身份证识别结果的正面文字信息
 *
 * @return 身份证识别结果 正面信息：
 *
 *  姓名: 马某
 *  性别: 男
 *  民族: 回
 *  出生: 1912 年 3 月 5 日
 *  住址: 广东省深圳市南山区。。。。。。
 *  号码: 610104123456788330
 */
- (NSString *) getFrontalInfo ;


/*! @brief getBackSideInfo 接口提供身份证识别结果的反面文字信息
 *
 * @return 身份证识别结果 反面信息：
 *
 *  签发机关: 深圳市公安局南山分局
 *  有效期限: 20041123-20241123
 */
- (NSString *) getBackSideInfo ;

- (void)setRecognizeItemsOptions:(STIDCardItemOption) option;

@end

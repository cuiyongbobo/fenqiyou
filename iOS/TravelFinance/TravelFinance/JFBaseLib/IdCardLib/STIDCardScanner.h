//
//  STIDCardScanner ： 身份证扫描控制器
//  SenseTime
//
//  Created by Mark on 15/1/24.
//  Copyright (c) 2015年 SenseTime.com . All rights reserved.


#import <UIKit/UIKit.h>
#import "STIDCard.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_OPTIONS(NSInteger, STIDCardErrorCode) {
    kIDCardCameraAuthorizationFailed    = 1 << 0,
    kIDCardHandleInitFailed             = 1 << 1,
    kIDCardAPIAcountFailed              = 1 << 2,
    kIDCardAuthFileNotFound             = 1 << 3,
    kIDCardModelFileNotFound            = 1 << 4,
    kIDCardInvalidAuth                  = 1 << 5,
    kIDCardInvalidAPPID                 = 1 << 6,
    kIDCardAuthExpire                   = 1 << 7,
};

@protocol STIDCardScannerDelegate <NSObject>

@optional
/**
 *	@brief 获取结果的回调函数（新版，优先回调）
 *
 *	@param 	idcard 	扫描结果，其中包含卡片图像，摄像头获取的图像和卡片数字
 */
-(void) getCardResult: (STIDCard *)idcard;
/**
 *	@brief 获取结果的回调函数（旧版，在新版回调不被支持时才会调用）
    @param   imgCapture  摄像头获取的图片
    @param   bankcard    扫描结果，其中包含卡片图像和卡片数字
 */
-(void) getCard:(UIImage *) image withInformation:(STIDCard *)idCardInformation ;

/**
 *	@brief	 出现错误时的回调函数
 *  @param errorCode 代表不同错误的错误代码
 */
-(void) getError: (STIDCardErrorCode) errorCode;

@required
/**
 *	@brief	 退出扫描界面的回调函数。
 */
-(void) didCancel;

@end

/*! @brief STIDCardScanner 函数类
 *
 * 该类封装了SenseTime的带有摄像头的全自动身份证检测和识别功能
 */

@interface STIDCardScanner : UIViewController

@property (nonatomic, weak) id<STIDCardScannerDelegate> delegate;
/**
 *	@brief	 包含朝向的初始化方法
 *
 *	@param 	orientation 	视频的朝向，目前支持AVCaptureVideoOrientationPortrait/AVCaptureVideoOrientationLandscapeRight/AVCaptureVideoOrientationLandscapeLeft三种
 *
 *	@return	扫描实例
 */
- (instancetype)initWithOrientation:(AVCaptureVideoOrientation)orientation;

/*! @brief hideMaskView 控制是否显示内置的取景框和提示
 *
 *  @param bHide
 *          NO ： 不隐藏默认取景框和提示文字 （default）
 *          YES： 隐藏默认的取景框和提示文字，用于开发者自定义取景框界面
 *
 *         注意：
 *              该方法在 present 出了 STIDCardScanner 之后或
 *              继承了 STIDCardScanner 的 viewDidLoad {} 中调用才能生效
 */
 - (void)hideMaskView:(BOOL) bHide ;

/*! @brief doRecognitionProcess 设置是否进行视频帧的识别处理
 *
 *  @param bProcessEnabled
 *          YES：    对从设置起后的每帧都进行身份证识别处理 （默认值）
 *          NO：     对从设置起后的每帧都不做识别处理，还保留视频播放
 */
- (void) doRecognitionProcess:(BOOL) bProcessEnabled ; 

/*! @brief didCancel 程序控制关闭摄像头并取消 STIDCardScanner
 *
 *      请使用其他 Controller 调用 STIDCardScanner 的 didCancel 来控制摄像头的关闭，如用于超时控制；
 *      也可继承本类，通过重载 didCancel 来控制关闭的方式和时机 。
 */
- (void) didCancel; // 允许其他 Controller 主动控制关闭 STIDCardScanner

/*! @brief cardMode 控制识别身份证哪个面：
 *              0 - kIDCardFrontal   - 正面 ,
 *              1 - kIDCardBack      - 反面,
 *              2 - kIDCardBothSides - 双面识别
 *              3 - kIDCardSmart     - 智能检测 （default）
 *
 *         注意：
 *              该方法在 present 出了 STIDCardScanner 之后或
 *              继承了 STIDCardScanner 的 viewDidLoad {} 中调用才能生效
 */
@property (nonatomic, assign)   STIDCardMode    cardMode  ;

/*! @brief callDelegate_getCard: withInformation: 支持自定义扫描成功后的处理流程，支持预览结果和重扫；
 *          v3.6   : 2015.6.11,
 *  @param image 扫描窗区域的截图，包含含有完整身份证边缘的用于识别的图像
 *  @param stIDCard 身份证识别的结果，含识别出的文字信息
 *
 *  该方法用于自定义扫描出结果后的流程；
 *  默认是暂停识别处理，给delegate返回识别的图像 image 和识别结果 stIDCard。 
 *  开发者可以继承本类后，重定义识别后的流程，例如给用户展示结果，支持重新扫描或确认结果后结束扫描。
 */
- (void) callDelegate_getCard:(UIImage *)image withInformation:(STIDCard *)stIDCard ;

/*! @brief moveWindowVerticalFromCenterWithDelta 调整取景框的位置
 *                  用于开发者自定义取景框，从中央上上下移动是为了在不同屏幕上的适配问题(仅限于竖屏)
 *                  用于和定义的界面保持一致
 *
 *  @param iDeltaY    取景框从中央位置上下移动的偏移量
 *          <0：     取景框从中央位置上移
 *          >0：     取景框从中央位置下移
 */
- (void)moveWindowVerticalFromCenterWithDelta:(int) iDeltaY ;

/**
 *	@brief	 返回扫描界面中扫描框的实际大小和位置
 *
 *	@return	扫描界面中扫描框的frame
 */
- (CGRect)maskWindowRect;

/**
 *	@brief	 设置需要识别的条目
 *
 *	@param 	option 	需要识别的条目，不同条目间用 | 连接
 */
- (void)setRecognizeItemOption:(STIDCardItemOption)option;


/**
 *	@brief	 设置扫描页背景的颜色和透明度
 *
 *	@param 	color 	扫描页背景的颜色
 *	@param 	alpha 	扫描页北京的透明度
 */
- (void)setTheScanLineColor:(UIColor *)color;

/**
 *	@brief	 设置扫描页背景的颜色和透明度
 *
 *	@param 	color 	扫描页背景的颜色
 *	@param 	alpha 	扫描页北京的透明度
 */
- (void)setTheMaskLayerColor:(UIColor *)color andAlpha:(CGFloat)alpha;


- (void)setHintLabel:(UILabel *)label;

@end

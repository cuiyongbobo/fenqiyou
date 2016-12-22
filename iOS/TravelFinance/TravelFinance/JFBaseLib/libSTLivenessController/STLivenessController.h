//
//  STLivenessController.h
//  STLivenessController
//
//  Created by sluin on 15/12/4.
//  Copyright © 2015年 SunLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "STLivenessDetectorDelegate.h"

@interface STLivenessController : UIViewController

/**
 *  设置语音提示默认是否开启 , 不设置时默认为YES即开启.
 */
@property (nonatomic , assign) BOOL bVoicePrompt;


/**
*  初始化方法
*
*  @param dDurationPerModel    每个模块允许的最大检测时间,小于等于0时为不设置超时时间.
*  @param strBundlePath        活体资源 st_liveness_resource.bundle 的路径 , 形如 @"path/st_liveness_resource.bundle"
*  @param modelPath  模型资源 M_Finance_Composite_General_Liveness_1.0.model的路径
*  @param strFinanceLicensePath SenseID_Liveness.lic的路径.
*
*  @return 活体检测器实例
*/
- (instancetype)initWithDuration:(double)dDurationPerModel
             resourcesBundlePath:(NSString *)strBundlePath
                modelPath:(NSString *)strModelPath
              financeLicensePath:(NSString *)strFinanceLicensePath;

/**
 *  活体检测器配置方法
 *
 *  @param delegate     回调代理
 *  @param queue        回调线程
 *  @param arrDetection 动作序列, 如 @[@(LIVE_BLINK) ,@(LIVE_MOUTH) ,@(LIVE_NOD) ,@(LIVE_YAW)] , 参照 STLivenessEnumType.h
 */
- (void)setDelegate:(id <STLivenessDetectorDelegate>)delegate
      callBackQueue:(dispatch_queue_t)queue
  detectionSequence:(NSArray *)arrDetection;


/**
 *  设置活体检测器默认输出方案及难易度, 可根据需求在 startDetection 之前调用使生效.
 *  @param iComplexity 活体检测的复杂度, 默认为 LIVE_COMPLEXITY_NORMAL
 */
- (void)setComplexity:(LivefaceComplexity)iComplexity;


/**
 *  开始检测, 检测的输出方案以及难易程度为之前最近一次调用 setOutputType:complexity: 所指定方案及难易程度.
 */
- (void)startDetection;



/**
 *  取消检测
 */
- (void)cancelDetection;



/**
 *  获取SDK版本
 *
 *  @return SDK版本
 */
+ (NSString *)getSDKVersion;



@end

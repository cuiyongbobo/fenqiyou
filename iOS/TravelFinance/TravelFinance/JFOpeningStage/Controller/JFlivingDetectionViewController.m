//
//  JFlivingDetectionViewController.m
//  Living
//
//  Created by cuiyong on 16/12/21.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFlivingDetectionViewController.h"

#import "STLivenessController.h"
#import "JFFaceDetectionBuilder.h"
#import "JFFaceDetectionParser.h"
#import "JFNetworkAFN.h"
#import "JFString.h"
#import "YKToastView.h"
#import "JFTipsWindow.h"
#import "NSString+Base64.h"
#import "JFTipsWindow.h"
#import "JFResultViewController.h"
#import "JFMacro.h"
#import "AppDelegate.h"

@interface JFlivingDetectionViewController ()<STLivenessDetectorDelegate,UIAlertViewDelegate>

@property (nonatomic , weak) STLivenessController *livenessVC;
@property (nonatomic, strong) NSMutableArray *arrImage;

@end

@implementation JFlivingDetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"人脸识别" showRightBtn:NO showLeftBtn:YES currentController:self];
    
    self.logoHeight.constant = 87*JFHeightRateScale;
    //    self.arrImage = [[NSMutableArray alloc] init];
    
}

#pragma - mark STLivenessDetectorDelegate

// 每个模块开始检测时会回调此方法
- (void)livenessDidStartDetectionWithDetectionType:(LivefaceDetectionType)iDetectionType detectionIndex:(int)iDetectionIndex {
}

- (void)livenessFaceRect:(STRect *)rect{
    
}

// 检测开始后,当初始化检测器时如果Duration大于0则每帧都会回调此方法(示例程序中为10),dPast为当前模块已耗时,dDurationPerModel为每个模块设定的最大时间
- (void)livenessTimeDidPast:(double)dPast durationPerModel:(double)dDurationPerModel {
    
}

// 活体检测成功的回调 , data为加密后的数据 , arrSTImage 为 STImage 对象的数组
- (void)livenessDidSuccessfulGetData:(NSData *)data stImages:(NSArray *)arrSTImage {
    // 注意,在您的app中千万不要这么做,这里是保存在 app/Documents 目录下用来离线校验文件内容,在实际场景中应该直接将该数据上传.
    if (data.length > 0) {
        
        // 取出每个阶段的图片
        NSMutableArray *arrImage = [NSMutableArray array];
        for (STImage *stImage in arrSTImage) {
            [arrImage addObject:stImage.image];
        }
        //        self.arrImage = arrImage;
        [self dismissViewControllerAnimated:YES completion:^{
            
            // 上传图片
            NSData * imageData = UIImageJPEGRepresentation(arrImage.firstObject,0.5);
            float length = [imageData length]/1000;
            NSLog(@"length= %f",length);
            NSString *imageDataStr = [NSString base64StringFromData:imageData length:[imageData length]];
            
            YKToastView *toastView = [YKToastView sharedToastViewWWithIndicatorAndText:JFKLoadingMessage];
            [toastView showInView:self.view];
            
            // 请求接口
            JFFaceDetectionBuilder *faceBuilder = [JFFaceDetectionBuilder sharedFace];
            [faceBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] type:@"1" dataImageStr:imageDataStr];
            JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
            [afnet requestHttpDataWithPath:faceBuilder.requestURL params:faceBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
            afnet.connectionType = JFConnectionTypeFaceDetection;
            
        }];
        
    }
}

// 活体检测失败的回调 , 包括失败的类型 , 失败时检测类型 , 失败时检测类型所在检测序列中的位置 , 0 为第一个 .
- (void)livenessDidFailWithErrorType:(LivefaceErrorType)iErrorType detectionType:(LivefaceDetectionType)iDetectionType detectionIndex:(int)iDetectionIndex data:(NSData *)data stImages:(NSArray *)arrSTImage
{
    
    // 注意,在您的app中千万不要这么做,这里是保存在 app/Documents 目录下用来离线校验文件内容,在实际场景中应根据实际情况选择处理回传数据
    //    if (data.length > 0){
    //
    //        for (int i = 0; i < arrSTImage.count; i ++) {
    //
    //            STImage *stImage = arrSTImage[i];
    //        }
    //    }
    switch (iErrorType) {
        case LIVENESS_FINANCELICENS_FILE_NOT_FOUND:
        {
            //            self.lblMessage.text = @"授权文件不存在";
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"授权文件不存在" backgroundcolor:white];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case LIVENESS_FINANCELICENS_CHECK_LICENSE_FAIL:
        {
            //            self.lblMessage.text = @"未通过授权验证";
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"未通过授权验证" backgroundcolor:white];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case LIVENESS_INVALID_APPID:
        {
            //            self.lblMessage.text = @"绑定包名错误";
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"绑定包名错误" backgroundcolor:white];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case LIVENESS_AUTH_EXPIRE:
        {
            //            self.lblMessage.text = @"授权文件过期";
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"授权文件过期" backgroundcolor:white];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case LIVENESS_MODELSBUNDLE_FILE_NOT_FOUND:
        {
            //            self.lblMessage.text = @"模型文件不存在";
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"模型文件不存在" backgroundcolor:white];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
        case  LIVENESS_MODELSBUNDLE_CHECK_MODEL_FAIL:
        {
            //            self.lblMessage.text = @"模型文件错误";
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"模型文件错误" backgroundcolor:white];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
        case LIVENESS_NOFACE:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检测失败" message:@"动作幅度过⼤,请保持人脸在屏幕中央,重试⼀次" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            break;
            
        }
            
        case LIVENESS_TIMEOUT:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"检测超时，请重试一次" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            break;
            
        }
            
        case LIVENESS_WILL_RESIGN_ACTIVE:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检测失败" message:@"请保持程序在前台运⾏行，重试一次" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            break;
        }
            
        case LIVENESS_CAMERA_ERROR:
        {
            //            self.lblMessage.text = @"权限检测失败,请前往通用－设置－隐私开启相机权限";
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"权限检测失败,请前往通用－设置－隐私开启相机权限" backgroundcolor:white];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
        }
            
        case LIVENESS_CONFIG_FAIL:
        {
            //            self.lblMessage.text = @"配置错误";
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"配置错误" backgroundcolor:white];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
        }
        default:
            break;
    }
}

// 活体检测取消的回调 , 活体检测取消时的检测类型 , 取消时检测类型所在检测序列中的位置 , 0 为第一个

- (void)livenessDidCancelWithDetectionType:(LivefaceDetectionType)iDetectionType detectionIndex:(int)iDetectionIndex {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self.livenessVC cancelDetection];
        }
            break;
            
        case 1:
        {
            [self.livenessVC startDetection];
        }
            break;
        default:
            break;
    }
}


#pragma mark net respones
- (void)jfURLConnection:(JFNetworkAFN *)jfURLConnection withError:(id)error {
    
    if (error) {
        [[YKToastView sharedToastView] hide];
        NSLog(@"error = %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:error backgroundcolor:white];
        });
        return;
    }
    
    switch (jfURLConnection.connectionType) {
            
        case JFConnectionTypeFaceDetection:
        {
            [[YKToastView sharedToastView] hide];
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleFaceResponse:responsedict];
        }
            break;
            
        default:
            break;
    }
}


- (void)handleFaceResponse:(NSDictionary *)dictionary {
    NSLog(@"dic =%@",dictionary);
    JFFaceDetectionParser *faceParser = [JFFaceDetectionParser sharedFaceParser];
    faceParser.sourceData = dictionary;
    
    if (faceParser.code == [JFKStatusCode integerValue]) {
        
        if ([faceParser.sourceDictionary[@"code"] integerValue] == 1) {
            
            // 去往认证机构
            //        [self dismissViewControllerAnimated:YES completion:nil];
            JFResultViewController *resultController = [[JFResultViewController alloc] initWithNibName:@"JFResultViewController" bundle:nil];
            [self.navigationController pushViewController:resultController animated:YES];
        }else {
            
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:faceParser.sourceDictionary[@"msg"] backgroundcolor:white];
        }
        
    }else {
        
        NSLog(@"errorMessage =%@",faceParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:faceParser.message backgroundcolor:white];
    }
}



#pragma mark handle Even
- (IBAction)handleFaceDetection:(id)sender {
    
    // 资源路径
    NSString *strResourcesBundlePath = [[NSBundle mainBundle] pathForResource:@"st_liveness_resource" ofType:@"bundle"];
    
    // 获取模型路径
    NSString *strModelPath = [[NSBundle mainBundle] pathForResource:@"M_Finance_Composite_General_Liveness_1.0" ofType:@"model"];
    // 获取授权文件路径
    NSString *strFinanceLicensePath =  [[NSBundle mainBundle]pathForResource:@"SenseID_Liveness.lic" ofType:@""];
    
    // 开始检测的方法
    STLivenessController *livenessVC = [[STLivenessController alloc]
                                        initWithDuration:10.0
                                        resourcesBundlePath:strResourcesBundlePath
                                        modelPath:strModelPath
                                        financeLicensePath:strFinanceLicensePath];
    self.livenessVC = livenessVC;
    
    //可以根据实际需求自由组合,第一个动作需要为眨眼
    NSArray *arrLivenessSequence = @[@(LIVE_BLINK) , @(LIVE_MOUTH) , @(LIVE_YAW)];
    // 设置代理及回调线程
    [livenessVC setDelegate:self callBackQueue:dispatch_get_main_queue() detectionSequence:arrLivenessSequence];
    // 设置活体检测复杂度
    [livenessVC setComplexity: LIVE_COMPLEXITY_NORMAL];
    // 设置默认语音提示状态,如不设置默认为开启
    livenessVC.bVoicePrompt = YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:livenessVC];
    [navigationController setNavigationBarHidden:YES];
    [self presentViewController:navigationController animated:YES completion:nil];
    
    
}
@end

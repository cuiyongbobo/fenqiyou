//
//  JFResultViewController.m
//  OcrID
//
//  Created by cuiyong on 16/12/20.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFResultViewController.h"

#import "STIDCardScanner.h"
#import "JFResultViewController.h"
#import "JFNetworkAFN.h"
#import "JFOcrIDDistinguishBuilder.h"
#import "JFOcrIDDistinguishParser.h"
#import "JFString.h"
#import "YKToastView.h"
#import "JFTipsWindow.h"
#import "NSString+Base64.h"
#import "JFlivingDetectionViewController.h"



typedef NS_OPTIONS(NSInteger, RecogResultType) {
    kResultTypeFront = 1,
    kResultTypeBack = 2,
    kResultTypeNameAndNumOnly = 3,
    kResultTypeUICustom = 4,
    kResultTypeScanFrontAndBack = 5,
};

@interface JFResultViewController ()<STIDCardScannerDelegate>
{
    RecogResultType _type;
    BOOL _frontID;
    BOOL _binedID;
}
@property (nonatomic, strong) STIDCardScanner *scanFrontAndBackVC;

@end

@implementation JFResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"身份验证" showRightBtn:NO showLeftBtn:YES currentController:self];
    
    self.frontIDImageView.layer.cornerRadius = 4;
    self.frontIDImageView.layer.masksToBounds = YES;
    
    self.behindIDImageView.layer.cornerRadius = 4;
    self.behindIDImageView.layer.masksToBounds = YES;
    
    
    UITapGestureRecognizer *frontTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanFrontTap:)];
    [self.frontIDImageView addGestureRecognizer:frontTapGesture];
    
    
    UITapGestureRecognizer *behindTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanbehindTap:)];
    [self.behindIDImageView addGestureRecognizer:behindTapGesture];
    
    self.dicfrontRecogResult = [[NSMutableDictionary alloc] init];
    self.dicbehindRecogResult = [[NSMutableDictionary alloc] init];
    
}


#pragma mark handle Even

- (void)scanFrontTap:(UITapGestureRecognizer *) frontTap {
    NSLog(@"frontTap");
    
    STIDCardScanner *scanVC = [[STIDCardScanner alloc] initWithOrientation:AVCaptureVideoOrientationPortrait];
    scanVC.delegate = self;
    _type = kResultTypeFront;
    scanVC.cardMode = kIDCardFrontal;
    [self presentViewController:scanVC animated:YES completion:nil];
}

- (void)scanbehindTap:(UITapGestureRecognizer *) behindTap {
    NSLog(@"behindTap");
    
    //    self.lbError.hidden = YES;
    STIDCardScanner *scanVC = [[STIDCardScanner alloc] initWithOrientation:AVCaptureVideoOrientationPortrait];
    scanVC.delegate = self;
    _type = kResultTypeBack;
    scanVC.cardMode = kIDCardBack;
    [self presentViewController:scanVC animated:YES completion:nil];
    
}

#pragma mark - ID card delegate - ID Card回调方法

- (void)getCardResult:(STIDCard *)idcard {
    //    [self removeErrorMessage];
    if (idcard.bTempIDCard) {
        NSLog(@"TEMP ID CARD");
    }
    switch (_type) {
        case kResultTypeFront:
        {
            [self praseIDCardFront:idcard];
        }
            break;
        case kResultTypeBack:
        {
            [self praseIDCardBack:idcard];
        }
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [_scanFrontAndBackVC doRecognitionProcess:YES];
    _scanFrontAndBackVC = nil;
}

- (void)praseIDCardFront:(STIDCard *)idcard{
    
    
    NSData * imageData = UIImageJPEGRepresentation(idcard.imgCardDetected,0.5);
    float length = [imageData length]/1000;
    NSLog(@"%f",length);
    
    NSString *imageDataStr = [NSString base64StringFromData:imageData length:[imageData length]];
    
    NSDictionary *dic = @{@"name": idcard.strName, @"gender": idcard.strSex, @"nation": idcard.strNation, @"birth": idcard.strDate, @"address": idcard.strAddress, @"number": idcard.strID,@"frontimage":imageDataStr};
    self.frontIDImageView.image = idcard.imgCardDetected;
    [self.dicfrontRecogResult addEntriesFromDictionary:dic];
    
    _frontID = YES;
    
    if (_frontID == YES && _binedID == YES) {
        
        [self.uploadButton setBackgroundImage:[UIImage imageNamed:@"openingstage_ocr_confirm_select"] forState:UIControlStateNormal];
    }
    
}

- (void)praseIDCardBack:(STIDCard *)idcard{
    
    NSData * imageData = UIImageJPEGRepresentation(idcard.imgCardDetected,0.5);
    float length = [imageData length]/1000;
    NSLog(@"%f",length);
    NSString *imageDataStr = [NSString base64StringFromData:imageData length:[imageData length]];
    NSDictionary *dic = @{@"organization": idcard.strAuthority, @"validityDate": idcard.strValidity,@"binedimage":imageDataStr};
    self.behindIDImageView.image = idcard.imgCardDetected;
    [self.dicfrontRecogResult addEntriesFromDictionary:dic];
    
    _binedID = YES;
    
    if (_frontID == YES && _binedID == YES) {
        
        [self.uploadButton setBackgroundImage:[UIImage imageNamed:@"openingstage_ocr_confirm_select"] forState:UIControlStateNormal];
    }
}


- (void)didCancel {
    _scanFrontAndBackVC = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)getError:(STIDCardErrorCode)errorCode {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    switch (errorCode) {
        case kIDCardAPIAcountFailed:
        {
            //            self.lbError.text = @"API账户信息错误，请检查网络以及API_ID和API_SECRET";
            NSLog(@"API账户信息错误，请检查网络以及API_ID和API_SECRET");
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"API账户信息错误，请检查网络以及API_ID和API_SECRET" backgroundcolor:white];
        }
            break;
        case kIDCardHandleInitFailed:
        {
            //            self.lbError.text = @"算法SDK初始化失败：\n模型与算法库不匹配";
            NSLog(@"算法SDK初始化失败：\n模型与算法库不匹配");
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"算法SDK初始化失败：\n模型与算法库不匹配" backgroundcolor:white];
        }
            break;
        case kIDCardCameraAuthorizationFailed:
        {
            //            self.lbError.text = @"相机授权失败，请在设置中打开相机权限";
            NSLog(@"相机授权失败，请在设置中打开相机权限");
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"相机授权失败，请在设置中打开相机权限" backgroundcolor:white];
        }
            break;
        case kIDCardAuthFileNotFound:
        {
            //            self.lbError.text = @"授权文件不存在";
            NSLog(@"授权文件不存在");
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"授权文件不存在" backgroundcolor:white];
        }
            break;
        case kIDCardModelFileNotFound:
        {
            //            self.lbError.text = @"模型文件不存在";
            NSLog(@"模型文件不存在");
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"模型文件不存在" backgroundcolor:white];
        }
            break;
        case kIDCardInvalidAuth:
        {
            //            self.lbError.text = @"授权文件不合法";
            NSLog(@"授权文件不合法");
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"授权文件不合法" backgroundcolor:white];
        }
            break;
        case kIDCardInvalidAPPID:
        {
            //            self.lbError.text = @"绑定包名错误";
            NSLog(@"绑定包名错误");
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"绑定包名错误" backgroundcolor:white];
        }
            break;
        case kIDCardAuthExpire:
        {
            //            self.lbError.text = @"授权文件过期";
            NSLog(@"授权文件过期");
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"授权文件过期" backgroundcolor:white];
        }
            break;
        default:
            break;
    }
}

- (IBAction)handleDetermine:(id)sender {
    
    NSLog(@"frontRecogResult = %@",self.dicfrontRecogResult);
    
    YKToastView *toastView = [YKToastView sharedToastViewWWithIndicatorAndText:JFKLoadingMessage];
    [toastView showInView:self.view];
    // 请求接口
    JFOcrIDDistinguishBuilder *bindingBuilder = [JFOcrIDDistinguishBuilder sharedDisting];
    [bindingBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] type:@"2" dataDict:self.dicfrontRecogResult];
    
    JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
    [afnet requestHttpDataWithPath:bindingBuilder.requestURL params:bindingBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    afnet.connectionType = JFConnectionTypeIDDisting;
}


#pragma mark response Evne

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
            
        case JFConnectionTypeIDDisting:
        {
            [[YKToastView sharedToastView] hide];
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:jfURLConnection.responseData options:NSJSONReadingMutableContainers error:nil];
            [self handleDistingResponse:responsedict];
        }
            break;
            
        default:
            break;
    }
}


- (void)handleDistingResponse:(NSDictionary *)dictionary {
    NSLog(@"dic =%@",dictionary);
    JFOcrIDDistinguishParser *bindingParser = [JFOcrIDDistinguishParser sharedDistingParser];
    bindingParser.sourceData = dictionary;
    
    if (bindingParser.code == [JFKStatusCode integerValue]) {
        
        JFlivingDetectionViewController *livingContorller = [[JFlivingDetectionViewController alloc] initWithNibName:@"JFlivingDetectionViewController" bundle:nil];
        [self.navigationController pushViewController:livingContorller animated:YES];
        
    }else {
        
        NSLog(@"errorMessage =%@",bindingParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:bindingParser.message backgroundcolor:white];
    }
}


@end

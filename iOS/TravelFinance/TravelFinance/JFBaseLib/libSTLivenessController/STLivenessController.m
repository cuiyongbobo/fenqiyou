//
//  STLivenessController.m
//  STLivenessController
//
//  Created by sluin on 15/12/4.
//  Copyright © 2015年 SunLin. All rights reserved.
//

#import "STLivenessController.h"
#import "STLivenessDetector.h"
#import "STLivenessCommon.h"
#import "UIView+STLayout.h"
#import "SZNumberLabel.h"
#import "STTracker.h"

@interface STLivenessController () <STLivenessDetectorDelegate , AVCaptureVideoDataOutputSampleBufferDelegate,UIAlertViewDelegate>
{
    dispatch_queue_t _callBackQueue;
    
    CGFloat _fImageWidth;
    CGFloat _fImageHeight;
    CGFloat _fScale;
    
    BOOL _b3_5InchScreen;
    
    NSArray *_arrDetection;
}

@property (nonatomic , copy) NSString *strBundlePath;

@property (nonatomic , strong) STTracker *tracker;

@property (nonatomic , strong) STLivenessDetector *detector;

@property (nonatomic , weak) id <STLivenessDetectorDelegate>delegate;

@property (nonatomic , strong) UIImageView *imageMaskView;
@property (nonatomic , strong) UIView *blackMaskView;


@property (nonatomic , strong) UIView *stepBackGroundView;
@property (nonatomic , strong) UIView *stepBGViewBGView;


@property (nonatomic , strong) UIImageView *imageAnimationBGView;
@property (nonatomic , strong) UIImageView *imageAnimationView;

@property (nonatomic , strong) UILabel *lblTrackerPrompt;

@property (nonatomic , strong) UILabel *lblCountDown;

@property (nonatomic , strong) UILabel *lblPrompt;

@property (nonatomic , strong) UIButton *btnSound;

@property (nonatomic , assign) float fCurrentPlayerVolume;

@property (nonatomic , strong) UIButton *btnBack;

@property (nonatomic , strong) AVAudioPlayer *blinkAudioPlayer;
@property (nonatomic , strong) AVAudioPlayer *mouthAudioPlayer;
@property (nonatomic , strong) AVAudioPlayer *nodAudioPlayer;
@property (nonatomic , strong) AVAudioPlayer *yawAudioPlayer;
@property (nonatomic , strong) AVAudioPlayer *currentAudioPlayer;


@property (nonatomic , strong) NSArray *arrMothImages;
@property (nonatomic , strong) NSArray *arrYawImages;
@property (nonatomic , strong) NSArray *arrPitchImages;
@property (nonatomic , strong) NSArray *arrBlinkImages;

@property (nonatomic , strong) AVCaptureDeviceInput * deviceInput;
@property (nonatomic , strong) AVCaptureVideoDataOutput * dataOutput;
@property (nonatomic , strong) AVCaptureSession *session;
@property (nonatomic , strong) AVCaptureDevice *deviceFront;
@property (nonatomic , assign) CGRect previewframe;

@property (nonatomic , assign) BOOL bShowCountDownView;

@property (nonatomic , copy) NSString *strResourcesBundlePath;

@property (nonatomic , strong) UIImage *imageSoundOn;

@property (nonatomic , strong) UIImage *imageSoundOff;

@end

@implementation STLivenessController

- (instancetype)init
{
    NSLog(@" ╔—————————————————————— WARNING —————————————————————╗");
    NSLog(@" | [[STLivenessController alloc] init] is not allowed |");
    NSLog(@" |     Please use  \"initWithDuration\" , thanks !    |");
    NSLog(@" ╚————————————————————————————————————————————————————╝");
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma - mark -
#pragma - mark Public method

- (instancetype)initWithDuration:(double)dDurationPerModel resourcesBundlePath:(NSString *)strBundlePath modelPath:(NSString *)strModelPath financeLicensePath:(NSString *)strFinanceLicensePath
{
    self = [super init];
    if (self) {
        
        self.tracker = [[STTracker alloc]initWithModelPath:strModelPath financeLicensePath:strFinanceLicensePath];
        self.detector = [[STLivenessDetector alloc]initWithDuration:dDurationPerModel modelPath:strModelPath financeLicensePath:strFinanceLicensePath];
        
        self.bShowCountDownView = dDurationPerModel > 0;
        
        if (!strBundlePath || [strBundlePath isEqualToString:@""] || ![[NSFileManager defaultManager] fileExistsAtPath:strBundlePath]) {
            NSLog(@" ╔————————————————————————— WARNING ————————————————————————╗");
            NSLog(@" |                                                          |");
            NSLog(@" |  Please add st_liveness_resource.bundle to your project !|");
            NSLog(@" |                                                          |");
            NSLog(@" ╚——————————————————————————————————————————————————————————╝");
            return nil;
        }
        
        self.strBundlePath = strBundlePath;
        
        self.imageSoundOn = [self imageWithFullFileName:@"st_sound_on.png"];
        self.imageSoundOff = [self imageWithFullFileName:@"st_sound_off.png"];
        
        self.bVoicePrompt = YES;
        self.fCurrentPlayerVolume = 0.8;
    }
    return self;
}

- (void)setDelegate:(id<STLivenessDetectorDelegate>)delegate callBackQueue:(dispatch_queue_t)queue detectionSequence:(NSArray *)arrDetection{
    
    if (!arrDetection) {
        NSLog(@" ╔———————————— WARNING ————————————╗");
        NSLog(@" |                                 |");
        NSLog(@" |  Please set detection sequence !|");
        NSLog(@" |                                 |");
        NSLog(@" ╚—————————————————————————————————╝");
    }else{
        
        self.previewframe = CGRectMake(0,0, kSTScreenWidth, kSTScreenHeight);
        
        double prepareCenterX = kSTScreenWidth/2.0;
        double prepareCenterY = kSTScreenHeight/2.0;
        double prepareRadius = kSTScreenWidth/2.5;

        [self.tracker setDelegate:self callBackQueue:queue prepareCenterPoint:CGPointMake(prepareCenterX, prepareCenterY) prepareRadius:prepareRadius];
   
        [self.detector setDelegate:self callBackQueue:queue detectionSequence:arrDetection];
        
        _arrDetection = [arrDetection mutableCopy];
        
    }
    
    if (self.delegate != delegate) {
        self.delegate = delegate;
    }
    
    if (_callBackQueue != queue) {
        _callBackQueue = queue;
    }
}

- (void)setBVoicePrompt:(BOOL)bVoicePrompt
{
    _bVoicePrompt = bVoicePrompt;
    
    [self setPlayerVolume];
}

- (void)setComplexity:(LivefaceComplexity)iComplexity{
    if (self.detector) {
        [self.detector setComplexity:iComplexity];
    }
}


- (void)startDetection
{
    [self.tracker startTracking];
}

- (void)cancelDetection
{
    [self.tracker stopTracking];
    [self.detector cancelDetection];
}

+ (NSString *)getSDKVersion
{
    return [STLivenessDetector getSDKVersion];
}

#pragma - mark -
#pragma - mark Life Cycle

- (void)loadView {
    [super loadView];
    
    _b3_5InchScreen = (kSTScreenHeight == 480);
    
    [self setupUI];
    
    [self displayViewsIfRunning:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
#if !TARGET_IPHONE_SIMULATOR

    BOOL bSetupCaptureSession = [self setupCaptureSession];
    
    if (!bSetupCaptureSession) {
        return;
    }
    [self setupAudio];
#endif

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.detector && self.session && self.dataOutput && ![self.session isRunning]) {
        [self.session startRunning];
    }
    [self cameraStart];
}

- (void)dealloc
{
    if (self.session) {
        [self.session beginConfiguration];
        [self.session removeOutput:self.dataOutput];
        [self.session removeInput:self.deviceInput];
        [self.session commitConfiguration];
        
        if ([self.session isRunning]) {
            [self.session stopRunning];
        }
        self.session = nil;
    }
    
    if ([self.currentAudioPlayer isPlaying]) {
        [self.currentAudioPlayer stop];
    }
    
    if ([self.imageAnimationView isAnimating]) {
        [self.imageAnimationView stopAnimating];
    }

}

#pragma - mark -
#pragma - mark Private Methods

- (void)setupUI
{
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage *imageMask = [self imageWithFullFileName:_b3_5InchScreen ? @"st_mask_s.png" : @"st_mask_b.png"];
    
    UIImage *imageMouth1 = [self imageWithFullFileName:@"st_mouth1.png"];
    UIImage *imageMouth2 = [self imageWithFullFileName:@"st_mouth2.png"];
    
    UIImage *imagePitch1 = [self imageWithFullFileName:@"st_pitch1.png"];
    UIImage *imagePitch2 = [self imageWithFullFileName:@"st_pitch2.png"];
    UIImage *imagePitch3 = [self imageWithFullFileName:@"st_pitch3.png"];
    UIImage *imagePitch4 = [self imageWithFullFileName:@"st_pitch4.png"];
    UIImage *imagePitch5 = [self imageWithFullFileName:@"st_pitch5.png"];
    
    UIImage *imageBlink1 = [self imageWithFullFileName:@"st_blink1.png"];
    UIImage *imageBlink2 = [self imageWithFullFileName:@"st_blink2.png"];
    
    UIImage *imageYaw1 = [self imageWithFullFileName:@"st_yaw1.png"];
    UIImage *imageYaw2 = [self imageWithFullFileName:@"st_yaw2.png"];
    UIImage *imageYaw3 = [self imageWithFullFileName:@"st_yaw3.png"];
    UIImage *imageYaw4 = [self imageWithFullFileName:@"st_yaw4.png"];
    UIImage *imageYaw5 = [self imageWithFullFileName:@"st_yaw5.png"];
    
    self.arrMothImages = [NSArray arrayWithObjects:imageMouth1 , imageMouth2, nil];
    
    self.arrPitchImages = [NSArray arrayWithObjects:imagePitch1 , imagePitch2 , imagePitch3 , imagePitch4, imagePitch5, imagePitch4 , imagePitch3 , imagePitch2, nil];
    self.arrBlinkImages = [NSArray arrayWithObjects:imageBlink1 , imageBlink2, nil];
    self.arrYawImages = [NSArray arrayWithObjects:imageYaw1 , imageYaw2 , imageYaw3, imageYaw4, imageYaw5, imageYaw4, imageYaw3, imageYaw2 ,nil];
    
    self.imageMaskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSTScreenWidth, kSTScreenHeight)];
    self.imageMaskView.image = imageMask;
    self.imageMaskView.userInteractionEnabled = YES;
    self.imageMaskView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageMaskView];
    
    self.blackMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSTScreenWidth, kSTScreenHeight)];
    self.blackMaskView.backgroundColor = [UIColor blackColor];
    self.blackMaskView.alpha = 0.3;
    [self.imageMaskView addSubview:self.blackMaskView];
    
    self.stepBackGroundView = [[UIView alloc] initWithFrame: _b3_5InchScreen ? CGRectMake(0, 0, _arrDetection.count * 16.0 + (_arrDetection.count - 1) * 8.0, 16.0):CGRectMake(0, 0, _arrDetection.count * 20.0 + (_arrDetection.count - 1) * 10.0, 20.0)];
    self.stepBackGroundView.backgroundColor = [UIColor clearColor];
    self.stepBackGroundView.hidden = YES;
    self.stepBackGroundView.stCenterX = kSTScreenWidth / 2.0;
    self.stepBackGroundView.stBottom = self.imageMaskView.stBottom - 20;
    self.stepBackGroundView.userInteractionEnabled = NO;
    
    
    self.stepBGViewBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.stepBackGroundView.frame.size.width + 6.0, self.stepBackGroundView.frame.size.height + 6.0)];
    self.stepBGViewBGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.stepBGViewBGView.layer.cornerRadius = self.stepBGViewBGView.frame.size.height / 2.0;
    self.stepBGViewBGView.center = self.stepBackGroundView.center;
    self.stepBGViewBGView.hidden = YES;
    [self.imageMaskView addSubview:self.stepBGViewBGView];
    [self.imageMaskView addSubview:self.stepBackGroundView];
    
    for (int i = 0; i < _arrDetection.count;  i ++) {
        
        SZNumberLabel *lblStepNumber = [[SZNumberLabel alloc] initWithFrame:_b3_5InchScreen ? CGRectMake(i * 20.0 + i * 4.0, 0, 16.0, 16.0):CGRectMake(i * 25.0 + i * 5.0, 0, 20.0, 20.0) number:i + 1];
        lblStepNumber.tag = i + kSTViewTagBase;
        [self.stepBackGroundView addSubview:lblStepNumber];
    }
    
    // ------动画
    self.imageAnimationBGView = [[UIImageView alloc] initWithFrame:_b3_5InchScreen ? CGRectMake(0, 0, kSTScreenWidth, 130.0) :CGRectMake(0, 0, kSTScreenWidth, 150.0)];
    self.imageAnimationBGView.stBottom = self.stepBGViewBGView.stTop - 16.0;
    [self.imageMaskView addSubview:self.imageAnimationBGView];
    
    CGFloat fAnimationViewWidth = _b3_5InchScreen ? 80.0 : 100.0;
    
    self.imageAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake((kSTScreenWidth - fAnimationViewWidth) / 2, 0, fAnimationViewWidth, fAnimationViewWidth)];
    self.imageAnimationView.stY = self.imageAnimationBGView.stHeight - self.imageAnimationView.stHeight + 10;
    self.imageAnimationView.animationDuration = 2.0f;
    self.imageAnimationView.layer.cornerRadius = self.imageAnimationView.frame.size.width / 2;
    self.imageAnimationView.backgroundColor = kSTColorWithRGB(0xC8C8C8);
    [self.imageAnimationBGView addSubview:self.imageAnimationView];
    
    // ------倒计时
    float fLabelCountDownWidth = _b3_5InchScreen ? 36.0 : 45.0;
    self.lblCountDown = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fLabelCountDownWidth , fLabelCountDownWidth)];
    self.lblCountDown.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.lblCountDown.textColor = [UIColor whiteColor];
    self.lblCountDown.stRight = self.imageMaskView.stWidth * 0.85;
    self.lblCountDown.stCenterY = self.imageAnimationView.stCenterY + self.imageAnimationBGView.stTop;
    self.lblCountDown.layer.cornerRadius = fLabelCountDownWidth / 2.0f;
    self.lblCountDown.clipsToBounds = YES;
    self.lblCountDown.adjustsFontSizeToFitWidth = YES;
    self.lblCountDown.font = [UIFont systemFontOfSize:fLabelCountDownWidth / 2.0f];
    self.lblCountDown.textAlignment = NSTextAlignmentCenter;
    self.lblCountDown.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self.imageMaskView addSubview:self.lblCountDown];

    // ------提示文字
    self.lblPrompt = [[UILabel alloc] initWithFrame:_b3_5InchScreen ? CGRectMake(0, 0, 100, 30.0):CGRectMake(0, 0, 100, 38.0)];
    self.lblPrompt.center = CGPointMake(self.imageAnimationView.stCenterX, self.imageAnimationView.stTop - 14.0-10);
    self.lblPrompt.font = [UIFont systemFontOfSize:_b3_5InchScreen ? 15.0 : 20];
    self.lblPrompt.textAlignment = NSTextAlignmentCenter;
    self.lblPrompt.textColor = [UIColor whiteColor];
    self.lblPrompt.layer.cornerRadius = self.lblPrompt.stHeight / 2.0;
    self.lblPrompt.layer.masksToBounds = YES;
    self.lblPrompt.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.imageAnimationBGView addSubview:self.lblPrompt];

    // ------tracker提示文字
    self.lblTrackerPrompt = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSTScreenWidth, 38.0)];
    self.lblTrackerPrompt.center = CGPointMake(self.imageAnimationView.stCenterX, self.imageAnimationView.stTop);
    self.lblTrackerPrompt.font = [UIFont systemFontOfSize:_b3_5InchScreen ? 15.0 : 20.0];
    self.lblTrackerPrompt.textAlignment = NSTextAlignmentCenter;
    self.lblTrackerPrompt.textColor = [UIColor whiteColor];

    [self.imageAnimationBGView addSubview:self.lblTrackerPrompt];
    
    // ------语音按钮
    UIButton *btnSound = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSound setFrame:_b3_5InchScreen ? CGRectMake(kSTScreenWidth - 50, 30, 30, 30): CGRectMake(kSTScreenWidth - 58, 30, 38, 38)];
    [btnSound setImage:self.bVoicePrompt ? self.imageSoundOn : self.imageSoundOff forState:UIControlStateNormal];
    [btnSound addTarget:self action:@selector(onBtnSound) forControlEvents:UIControlEventTouchUpInside];
    [self.imageMaskView addSubview:btnSound];
    self.btnSound = btnSound;
    
    // ------返回按钮
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];

    [btnBack setFrame:_b3_5InchScreen ? CGRectMake(20, 30, 30, 30):CGRectMake(20, 30, 38, 38)];
    [btnBack setImage:[self imageWithFullFileName:@"st_scan_back.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(onBtnBack) forControlEvents:UIControlEventTouchUpInside];
    [self.imageMaskView addSubview:btnBack];
    self.btnBack = btnBack;

}

- (void)setupAudio
{
    NSString *strBlinkPath = [self audioPathWithFullFileName:@"st_notice_blink.mp3"];
    self.blinkAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:strBlinkPath] error:nil];
    self.blinkAudioPlayer.volume = self.fCurrentPlayerVolume;
    self.blinkAudioPlayer.numberOfLoops = -1;
    [self.blinkAudioPlayer prepareToPlay];
    
    NSString *strMouthPath = [self audioPathWithFullFileName:@"st_notice_mouth.mp3"];
    self.mouthAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:strMouthPath] error:nil];
    self.mouthAudioPlayer.volume = _fCurrentPlayerVolume;
    self.mouthAudioPlayer.numberOfLoops = -1;
    [self.mouthAudioPlayer prepareToPlay];
    
    NSString *strNodPath = [self audioPathWithFullFileName:@"st_notice_nod.mp3"];
    self.nodAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:strNodPath] error:nil];
    self.nodAudioPlayer.volume = _fCurrentPlayerVolume;
    self.nodAudioPlayer.numberOfLoops = -1;
    [self.nodAudioPlayer prepareToPlay];
    
    NSString *strYawPath = [self audioPathWithFullFileName:@"st_notice_yaw.mp3"];
    self.yawAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:strYawPath] error:nil];
    self.yawAudioPlayer.volume = _fCurrentPlayerVolume;
    self.yawAudioPlayer.numberOfLoops = -1;
    [self.yawAudioPlayer prepareToPlay];
}


- (BOOL)setupCaptureSession
{
#if !TARGET_IPHONE_SIMULATOR

    self.session = [[AVCaptureSession alloc] init];
    // iPhone 4S, +
    self.session.sessionPreset = AVCaptureSessionPreset640x480;
    _fImageWidth = 640.0;
    _fImageHeight = 480.0;
    
    _fScale = [UIScreen mainScreen].scale;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
    captureVideoPreviewLayer.frame = self.previewframe;
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    [self.view.layer addSublayer:captureVideoPreviewLayer];
    [self.view bringSubviewToFront:self.blackMaskView];
    [self.view bringSubviewToFront:self.imageMaskView];
    
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionFront) {
                self.deviceFront = device;
            }
        }
    }
    
    int frameRate;
    CMTime frameDuration = kCMTimeInvalid;
    
    frameRate = 30;
    frameDuration = CMTimeMake( 1, frameRate );
    
    NSError *error = nil;
    if ( [self.deviceFront lockForConfiguration:&error] ) {
        self.deviceFront.activeVideoMaxFrameDuration = frameDuration;
        self.deviceFront.activeVideoMinFrameDuration = frameDuration;
        [self.deviceFront unlockForConfiguration];
    }
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.deviceFront error:&error];
    self.deviceInput = input;
 
    
    self.dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    [self.dataOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    [self.dataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    
    dispatch_queue_t queueBuffer = dispatch_queue_create("LIVENESS_BUFFER_QUEUE", NULL);
    
    [self.dataOutput setSampleBufferDelegate:self queue:queueBuffer];
    
    [self.session beginConfiguration];
    
    if ([self.session canAddOutput:self.dataOutput]) {
        [self.session addOutput:self.dataOutput];
    }
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    
    [self.session commitConfiguration];
#endif

    return YES;
}

- (UIImage *)imageWithFullFileName:(NSString *)strFileName
{
    NSString *strFilePath = [NSString pathWithComponents:@[self.strBundlePath , @"images" , strFileName]];
    
    return [UIImage imageWithContentsOfFile:strFilePath];
}

- (NSString *)audioPathWithFullFileName:(NSString *)strFileName
{
    NSString *strFilePath = [NSString pathWithComponents:@[self.strBundlePath , @"sounds" , strFileName]];
    return strFilePath;
}

- (void)displayViewsIfRunning:(BOOL)bRunning
{
    self.blackMaskView.hidden = bRunning;
    self.imageAnimationView.hidden = !bRunning;
    self.lblPrompt.hidden = !bRunning;
    self.stepBackGroundView.hidden = !bRunning;
    self.stepBGViewBGView.hidden = !bRunning;
    self.lblCountDown.hidden = self.bShowCountDownView ? !bRunning : YES;
    self.lblTrackerPrompt.hidden = bRunning;
    self.lblTrackerPrompt.text = @"";
}

- (void)showPromptWithDetectionType:(LivefaceDetectionType)iType detectionIndex:(int)iIndex
{
    if (self.currentAudioPlayer) {
        
        [self stopAudioPlayer];
    }
    
    SZNumberLabel *lblNumber = [self.stepBackGroundView viewWithTag:kSTViewTagBase + iIndex];
    lblNumber.bHighlight = YES;
    
    if ([self.imageAnimationView isAnimating]) {
        [self.imageAnimationView stopAnimating];
    }
    
    CATransition *transion = [CATransition animation];
    transion.type = @"push";
    transion.subtype = @"fromRight";
    transion.duration = 0.5f;
    transion.removedOnCompletion = YES;
    [self.imageAnimationBGView.layer addAnimation:transion forKey:nil];
    
    switch (iType) {
        case LIVE_YAW:
        {
            self.lblPrompt.text = @"请摇头";
            self.imageAnimationView.animationDuration = 2.0f;
            self.imageAnimationView.animationImages = self.arrYawImages;
            self.currentAudioPlayer = self.yawAudioPlayer;
            break;
        }
            
        case LIVE_BLINK:
        {
            self.lblPrompt.text = @"请眨眼";
            self.imageAnimationView.animationDuration = 1.0f;
            self.imageAnimationView.animationImages = self.arrBlinkImages;
            self.currentAudioPlayer = self.blinkAudioPlayer;
            break;
        }
            
        case LIVE_MOUTH:
        {
            self.lblPrompt.text = @"请张嘴";
            self.imageAnimationView.animationDuration = 1.0f;
            self.imageAnimationView.animationImages = self.arrMothImages;
            self.currentAudioPlayer = self.mouthAudioPlayer;
            break;
        }
        case LIVE_NOD:
        {
            self.lblPrompt.text = @"请点头";
            self.imageAnimationView.animationDuration = 2.0f;
            self.imageAnimationView.animationImages = self.arrPitchImages;
            self.currentAudioPlayer = self.nodAudioPlayer;
            break;
        }
        case LIVE_NONE:
        {
            break;
        }
    }
    
    if (![self.imageAnimationView isAnimating]) {
        [self.imageAnimationView startAnimating];
    }
    
    if (self.currentAudioPlayer) {
        
        [self stopAudioPlayer];
        [self.currentAudioPlayer play];
    }
}

- (void)stopAudioPlayer
{
    if ([self.currentAudioPlayer isPlaying]) {
        [self.currentAudioPlayer stop];
    }
    
    self.currentAudioPlayer.currentTime = 0;
}

- (void)clearStepViewAndStopSound
{
    if (self.currentAudioPlayer) {
        
        [self stopAudioPlayer];
    }
    for (SZNumberLabel *lblNumber in self.stepBackGroundView.subviews) {
        lblNumber.bHighlight = NO;
    }
}

- (void)setPlayerVolume
{
    [self.btnSound setImage:self.bVoicePrompt ? self.imageSoundOn : self.imageSoundOff forState:UIControlStateNormal];
    
    self.fCurrentPlayerVolume = self.bVoicePrompt ? 0.8 : 0;
    
    self.blinkAudioPlayer.volume = self.fCurrentPlayerVolume;
    self.mouthAudioPlayer.volume = self.fCurrentPlayerVolume;
    self.nodAudioPlayer.volume = self.fCurrentPlayerVolume;
    self.yawAudioPlayer.volume = self.fCurrentPlayerVolume;
   
}

- (void)cameraStart
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    [self.tracker startTracking];
                }else{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(livenessDidFailWithErrorType:detectionType:detectionIndex:data:stImages:)]) {
                        dispatch_async(_callBackQueue, ^{
                            
                            [self.delegate livenessDidFailWithErrorType:LIVENESS_CAMERA_ERROR detectionType:LIVE_BLINK detectionIndex:0 data:nil stImages:nil];
                        });
                    }
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            [self.tracker startTracking];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(livenessDidFailWithErrorType:detectionType:detectionIndex:data:stImages:)]) {
                dispatch_async(_callBackQueue, ^{
                    
                    [self.delegate livenessDidFailWithErrorType:LIVENESS_CAMERA_ERROR detectionType:LIVE_BLINK detectionIndex:0 data:nil stImages:nil];
                });
            }
            break;
        }
        default:
            break;
    }

}

#pragma - mark -
#pragma - mark Event Response

- (void)onBtnBack
{
    [self cancelDetection];
}
- (void)onBtnSound
{
    self.bVoicePrompt = !self.bVoicePrompt;
    
    [self setPlayerVolume];
}


#pragma - mark -
#pragma - mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (self.tracker) {
        [self.tracker trackWithCMSanmpleBuffer:sampleBuffer faceOrientaion:LIVE_FACE_LEFT];
    }
    
    if (self.detector) {
        [self.detector trackAndDetectWithCMSampleBuffer:sampleBuffer faceOrientaion:LIVE_FACE_LEFT];
    }
}

#pragma - mark -
#pragma - mark STLivenessDetectorDelegate

- (void)livenessFaceRect:(STRect *)rect{

    if (self.delegate && [self.delegate respondsToSelector:@selector(livenessFaceRect:)]) {
        dispatch_async(_callBackQueue, ^{
            [self.delegate livenessFaceRect:rect];
        });
    }
}

- (void)livenessTrackerStatus:(LivefaceErrorType)status{
        switch (status) {
            case LIVENESS_FINANCELICENS_FILE_NOT_FOUND:
            case LIVENESS_FINANCELICENS_CHECK_LICENSE_FAIL:
            case LIVENESS_MODELSBUNDLE_FILE_NOT_FOUND:
            case LIVENESS_MODELSBUNDLE_CHECK_MODEL_FAIL:
            case LIVENESS_INVALID_APPID:
            case LIVENESS_AUTH_EXPIRE:
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(livenessDidFailWithErrorType:detectionType:detectionIndex:data:stImages:)]) {
                    dispatch_async(_callBackQueue, ^{
                        [self.delegate livenessDidFailWithErrorType:status detectionType:LIVE_BLINK detectionIndex:0 data:nil stImages:nil];
                    });
                }
                break;
            }
            case LIVENESS_NOFACE:
            {
                self.lblTrackerPrompt.text = @"请将人脸移入框内";
                break;
            }
            case LIVENESS_FACE_TOO_FAR:
            {
                self.lblTrackerPrompt.text = @"请移动手机靠近面部";
                break;
            }
            case LIVENESS_FACE_TOO_CLOSE:
            {
                self.lblTrackerPrompt.text = @"请移动手机远离面部";
                break;
            }

            case LIVENESS_DETECTING:
            {
                self.lblTrackerPrompt.text = @"准备开始检测";
                break;
            }
            case LIVENESS_SUCCESS:
            {
                self.lblTrackerPrompt.text = @"";
                [self.tracker stopTracking];
                if (self.session && [self.session isRunning] && self.detector) {
                    [self.detector startDetection];
                }
                break;
            }
            case LIVENESS_WILL_RESIGN_ACTIVE:
            {
                self.lblTrackerPrompt.text = @"";
                [self.tracker stopTracking];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请保持程序在前台运行, 重试一次" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                break;
            }
            default:
                break;
        }
}

- (void)livenessDidStartDetectionWithDetectionType:(LivefaceDetectionType)iDetectionType detectionIndex:(int)iDetectionIndex
{
    [self displayViewsIfRunning:YES];
    [self showPromptWithDetectionType:iDetectionType detectionIndex:iDetectionIndex];

    if (self.delegate && [self.delegate respondsToSelector:@selector(livenessDidStartDetectionWithDetectionType:detectionIndex:)]) {
        dispatch_async(_callBackQueue, ^{
            [self.delegate livenessDidStartDetectionWithDetectionType:iDetectionType detectionIndex:iDetectionIndex];
        });
    }
}

- (void)livenessTimeDidPast:(double)dPast durationPerModel:(double)dDurationPerModel
{
    if (dDurationPerModel != 0) {
        self.lblCountDown.text = [NSString stringWithFormat:@"%d" , ((int)dDurationPerModel - (int)dPast)];
        if (self.delegate && [self.delegate respondsToSelector:@selector(livenessTimeDidPast:durationPerModel:)]) {
            dispatch_async(_callBackQueue, ^{
                [self.delegate livenessTimeDidPast:dPast durationPerModel:dDurationPerModel];
            });
        }
    }
}

- (void)videoFrameRate:(int)rate{
    
//    printf("%d FPS\n",rate);

}

- (void)livenessDidSuccessfulGetData:(NSData *)data stImages:(NSArray *)arrSTImage
{
    [self clearStepViewAndStopSound];
    [self displayViewsIfRunning:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(livenessDidSuccessfulGetData:stImages:)]) {
        dispatch_async(_callBackQueue, ^{
            [self.delegate livenessDidSuccessfulGetData:data stImages:arrSTImage];
        });
    }
}

- (void)livenessDidFailWithErrorType:(LivefaceErrorType)iErrorType detectionType:(LivefaceDetectionType)iDetectionType detectionIndex:(int)iDetectionIndex data:(NSData *)data stImages:(NSArray *)arrSTImage
{
    [self clearStepViewAndStopSound];
    [self displayViewsIfRunning:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(livenessDidFailWithErrorType:detectionType:detectionIndex:data:stImages:)]) {
        dispatch_async(_callBackQueue, ^{
            [self.delegate livenessDidFailWithErrorType:iErrorType detectionType:iDetectionType detectionIndex:iDetectionIndex data:data stImages:arrSTImage];
        });
    }
}

- (void)livenessDidCancelWithDetectionType:(LivefaceDetectionType)iDetectionType detectionIndex:(int)iDetectionIndex
{
    [self clearStepViewAndStopSound];
    [self displayViewsIfRunning:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(livenessDidCancelWithDetectionType:detectionIndex:)]) {
        dispatch_async(_callBackQueue, ^{
            [self.delegate livenessDidCancelWithDetectionType:iDetectionType detectionIndex:iDetectionIndex];
        });
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self cancelDetection];
    }else{
        [self.tracker startTracking];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

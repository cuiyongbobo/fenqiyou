//
//  YKShareViewController.m
//  Yinker
//
//  Created by cuiyong on 16/4/14.
//  Copyright © 2016年 Yinker. All rights reserved.
//

#import "YKShareViewController.h"
//#import "UMMobClick/MobClick.h"
#import "YKShareModelMgr.h"
//#import "YKConfigMgr.h"
//#import "MacroFrame.h"

#import "JFDevice.h"
#import "JFMacro.h"
#import "JFBaseLibCommon.h"





NSUInteger const kType = 1;
NSUInteger const kYKShareHeight = 278;


@interface YKShareViewController ()

@property (nonatomic, weak) IBOutlet UIButton *wChatFriendsShareBtn;
@property (nonatomic, weak) IBOutlet UIButton *wChatShareBtn;
@property (nonatomic, weak) IBOutlet UIButton *qqShareBtn;
@property (nonatomic, weak) IBOutlet UIButton *qZoneShareBtn;
@property (weak,nonatomic)  IBOutlet UIView *bottomBgView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leadingCstOfLeftTopBtn;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leadingCstOfLeftBottomBtn;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *trailingCstOfRightTopBtn;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *trailingCstOfRightBottomBtn;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightCstOfContentView;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UIButton *topBtn;

@property (nonatomic, assign) BOOL hasQQ;
@property (nonatomic, assign) BOOL hasWChat;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *hCstOfHLine;

@end

@implementation YKShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leadingCstOfLeftTopBtn.constant = self.leadingCstOfLeftBottomBtn.constant = self.trailingCstOfRightTopBtn.constant = self.trailingCstOfRightBottomBtn.constant = ([JFDevice screenWidth] - 65 * 2)/4.0;
    self.hCstOfHLine.constant = FIXEDCONSTRAINT(1);
}
- (IBAction)hideSelf:(id)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.bottomBgView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, kYKShareHeight);
    }];
    self.bottomView.hidden = YES;
    self.topBtn.hidden = YES;
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.4];
}

- (IBAction)wxShareSessionEvent:(id)sender {
    [self shareButtonAction:ShareTypeWXSceneSession];
}

- (IBAction)wxShareTimeLineEvent:(id)sender {
    [self shareButtonAction:ShareTypeWXSceneTimeline];
}

- (IBAction)qqShareBtnEvent:(id)sender {
    [self shareButtonAction:ShareTypeQQSceneSession];
}

- (IBAction)qqShareTimeLineEvent:(id)sender {
    [self shareButtonAction:ShareTypeQQSceneTimeline];
}

-(void)shareButtonAction:(shareType)shareType
{
    self.bottomBgView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, kYKShareHeight);
    [self delayMethod];
    
//    NSString *wxUrl = self.params[@"share"][@"wxUrl"];
//    NSString *imgUrl = self.params[@"share"][@"picUrl"];
//    NSString *content = self.params[@"share"][@"content"];
//    NSString *title = self.params[@"share"][@"title"];
//    NSString *comUrl = self.params[@"share"][@"comUrl"];
    
    NSString *wxUrl = @"http://guonei.news.baidu.com";
    NSString *imgUrl = @"http://img4.duitang.com/uploads/item/201510/06/20151006220022_whFLZ.thumb.224_0.jpeg";
    NSString *content = @"理财有风险，投资需谨慎";
    NSString *title = @"优玖分期游";
    NSString *comUrl = @"http://guonei.news.baidu.com";
    
    
    //    YKConfigMgr *config = [YKConfigMgr sharedYKConfigMgr];
    switch (shareType) {
        case ShareTypeWXSceneSession: //wx好友
        {
            //            [MobClick event:@"share_WXSceneSession" label:wxUrl];
            if([YKShareModelMgr registeShareOfType:shareType AndAppID:[JFBaseLibCommon jfWXAppId]])
                
                [YKShareModelMgr sendLinkTitle:title description:content ImageName:imgUrl URLAdd:wxUrl Type:ShareTypeWXSceneSession];
        }
            break;
        case ShareTypeWXSceneTimeline: //wx朋友圈
        {
            //            [MobClick event:@"share_WXSceneTimeline" label:wxUrl];
            if([YKShareModelMgr registeShareOfType:shareType AndAppID:[JFBaseLibCommon jfWXAppId]])
                [YKShareModelMgr sendLinkTitle:title description:content ImageName:imgUrl URLAdd:wxUrl Type:ShareTypeWXSceneTimeline];
        }
            break;
        case ShareTypeQQSceneSession: //QQ好友
        {
            //            [MobClick event:@"share_QQ" label:comUrl];
            if([YKShareModelMgr registeShareOfType:shareType AndAppID:[JFBaseLibCommon tencentAppId]])
                [YKShareModelMgr sendLinkTitle:title description:content ImageName:imgUrl URLAdd:comUrl Type:ShareTypeQQSceneSession];
        }
            break;
        case ShareTypeQQSceneTimeline: //QQ朋友圈
        {
            //            [MobClick event:@"share_QZone" label:comUrl];
            if([YKShareModelMgr registeShareOfType:shareType AndAppID:[JFBaseLibCommon tencentAppId]])
                [YKShareModelMgr sendLinkTitle:title description:content ImageName:imgUrl URLAdd:comUrl Type:ShareTypeQQSceneTimeline];
        }
            break;
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bottomBgView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, kYKShareHeight);
    [UIView animateWithDuration:0.4 animations:^{
        self.bottomBgView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-kYKShareHeight, [UIScreen mainScreen].bounds.size.width, kYKShareHeight);
    }];
    self.bottomView.hidden = NO;
    self.topBtn.hidden = NO;
}

- (void)delayMethod {
    [self.view removeFromSuperview];
    if (self.parentViewController) {
        [self removeFromParentViewController];
    }
}


@end

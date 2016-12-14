//
//  JFOpeningStageCreditAuthorizationViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/16.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFOpeningStageCreditAuthorizationViewController.h"

#import "JFOpeningStageCreditBuilder.h"
#import "JFOpeningStageCreditParser.h"
#import "JFNetworkAFN.h"
#import "JFString.h"
#import "JFTipsWindow.h"

@interface JFOpeningStageCreditAuthorizationViewController ()

@end

@implementation JFOpeningStageCreditAuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"信用卡授权" showRightBtn:NO showLeftBtn:YES currentController:self];
}

#pragma mark navigation back
- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
}



#pragma mark Even

- (IBAction)HandleConfirm:(id)sender {
    
    [self.creditText resignFirstResponder];
    // 请求接口
    JFOpeningStageCreditBuilder *opendingStageBuilder = [JFOpeningStageCreditBuilder sharedOpeningStage];
    [opendingStageBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] creditCardNo:self.creditText.text];
    
    JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
    [afnet requestHttpDataWithPath:opendingStageBuilder.requestURL params:opendingStageBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
    afnet.connectionType = JFConnectionTypeOpendingStageCredit;
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
            
        case JFConnectionTypeOpendingStageCredit:
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
    JFOpeningStageCreditParser *openingStageParser = [JFOpeningStageCreditParser sharedOpeningStageParser];
    openingStageParser.sourceData = dictionary;
    if (openingStageParser.code == [JFKStatusCode integerValue]) {
        
        // CreditAuthorizationResult
        if (_CreditAuthorizationResult) {
            self.CreditAuthorizationResult(YES);
        }
        // 信用卡 授权成功
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        NSLog(@"errorMessage =%@",openingStageParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:openingStageParser.message backgroundcolor:white];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.creditText resignFirstResponder];
}




@end

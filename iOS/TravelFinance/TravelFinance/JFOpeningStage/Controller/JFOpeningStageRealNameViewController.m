//
//  JFOpeningStageRealNameViewController.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/16.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFOpeningStageRealNameViewController.h"

#import "JFTravelPersonBuilder.h"
#import "JFNetworkAFN.h"
#import "JFString.h"
#import "JFTipsWindow.h"
#import "JFTravelPersonParser.h"

#import "JFOpeningStageBindingBankCardViewController.h"
#import "JFOpeningStageCertificationInstitutionViewController.h"


@interface JFOpeningStageRealNameViewController ()<JFURLConnectionDelegate>

@end

@implementation JFOpeningStageRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigation:@"实名认证" showRightBtn:NO showLeftBtn:YES currentController:self];
}

#pragma mark navigation back
- (void)navigationGobackHandleButtonEvent {
    NSLog(@"go back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightHandleButtonEvent {
    NSLog(@"业务操作");
}


- (BOOL)isMobileNumber:(NSString *)mobileNum {
    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if ([regextestmobile evaluateWithObject:mobileNum]) {
        return YES;
    }else{
        return NO;
    }
}


- (BOOL)isChineseName:(NSString *)name {
    NSString * phoneRegex = @"^([\u4e00-\u9fa5]){2,7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if ([regextestmobile evaluateWithObject:name]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma 正则匹配用户身份证号15或18位
- (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

#pragma mark handle Even

- (IBAction)handleRealAuthentication:(id)sender {
    
    [self.realNameText resignFirstResponder];
    [self.identityCardText resignFirstResponder];
    
    if ([self isChineseName:self.realNameText.text]) {
        if ([self checkUserIdCard:self.identityCardText.text]) {
            
            // 请求接口
            JFTravelPersonBuilder *travelPersonBuilder = [JFTravelPersonBuilder sharedTravelPerson];
            [travelPersonBuilder buildPostData:[[NSUserDefaults standardUserDefaults] objectForKey:JFKUserId] realName:self.realNameText.text idCardNo:self.identityCardText.text validateBlack:@"0" isSelf:@"0" type:@"1"];
            
            JFNetworkAFN *afnet = [[JFNetworkAFN alloc] init];
            [afnet requestHttpDataWithPath:travelPersonBuilder.requestURL params:travelPersonBuilder.postData withMethodType:HttpRequestTypePost cacheSupport:NO delegate:self];
            afnet.connectionType = JFConnectionTypeTravelPerson;
            
        }else {
            
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请输入合身份证" backgroundcolor:white];
        }
        
        
    }else {
        
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:@"请输入中文名字" backgroundcolor:white];
    }
    
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
            
        case JFConnectionTypeTravelPerson:
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
    JFTravelPersonParser *travelPersonParser = [JFTravelPersonParser sharedTravelPersonParser];
    travelPersonParser.sourceData = dictionary;
    if (travelPersonParser.code == [JFKStatusCode integerValue]) {
        self.travelPerson = travelPersonParser.travelPerson;
        
        if ([travelPersonParser.travelPerson.isReal isEqualToString:@"0"] && [travelPersonParser.travelPerson.isBlack isEqualToString:@"0"]) {
            if ([self.personInformationType isEqualToString:@"实名认证"]) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                // 走业务
                NSLog(@"走分期授权业务");
                JFOpeningStageCertificationInstitutionViewController *bindingBankController = [[JFOpeningStageCertificationInstitutionViewController alloc] initWithNibName:@"JFOpeningStageCertificationInstitutionViewController" bundle:nil];
                [self.navigationController pushViewController:bindingBankController animated:YES];
            }
            
           
        }else {
            [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:travelPersonParser.travelPerson.message backgroundcolor:white];
        }
        
        
    }else {
        
        NSLog(@"errorMessage =%@",travelPersonParser.message);
        [[JFTipsWindow sharedTipview] HiddenTipView:NO viewcontroller:self tiptext:travelPersonParser.message backgroundcolor:white];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.realNameText resignFirstResponder];
    [self.identityCardText resignFirstResponder];
}



@end

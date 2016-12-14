//
//  YKUpdateVersionViewController.m
//  Yinker
//
//  Created by cuiyong on 16/5/23.
//  Copyright © 2016年 Yinker. All rights reserved.
//

#import "YKUpdateVersionViewController.h"

#import "JFBaseLibCommon.h"

@interface YKUpdateVersionViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@end

@implementation YKUpdateVersionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString * htmlString = self.updateVersionItem.memo;
    //@"1.sdfasdfasdf</br>2.1234567</br>3.1234567";
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.contentLb.attributedText = attrStr;
    self.titleLb.text = [NSString stringWithFormat:@"V%@版 上线了",self.updateVersionItem.curVersion];
    
    switch ([self.updateVersionItem.isUpdate integerValue]) {
        case LatestVersion:
        {
            // 最新
        }
            break;
        case UpdatedVersion:
        {
            // 更新
            [self.closeBtn setHidden:NO];
        }
            break;
        case forceUpdatedVersion:
        {
            // 强制更新
            [self.closeBtn setHidden:YES];
        }
            break;
        default:
            break;
    }
}

- (IBAction)hideSelf:(id)sender {
    
    NSLog(@"hideSelfBUtton");
    [self.view removeFromSuperview];
}


- (IBAction)updateEvent:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@",[JFBaseLibCommon appAppleID]]]];
}

- (void)hideClostBtn:(BOOL)buttonHidden {
    self.closeBtn.hidden = buttonHidden;
}

@end

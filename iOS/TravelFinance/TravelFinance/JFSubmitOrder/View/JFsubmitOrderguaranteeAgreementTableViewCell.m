//
//  JFsubmitOrderguaranteeAgreementTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/7.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFsubmitOrderguaranteeAgreementTableViewCell.h"

#import "JFMacro.h"

@interface JFsubmitOrderguaranteeAgreementTableViewCell ()

@end

@implementation JFsubmitOrderguaranteeAgreementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([JFDevice screenHeight]<= 568) {
            
            if ([self.orderType isEqualToString:@"fq"]) {
                [self.borrowingButtonPhone4 setTitle:@"《借款服务" forState:UIControlStateNormal];
                [self.borrowingButtonphones4 setTitle:@"协议》" forState:UIControlStateNormal];
            }else {
                [self.borrowingButtonPhone4 setTitle:@"《出借服务" forState:UIControlStateNormal];
                [self.borrowingButtonphones4 setTitle:@"协议》" forState:UIControlStateNormal];
            }
            
        }else {
            
            if ([self.orderType isEqualToString:@"fq"]) {
                [self.borrowingButton setTitle:@"《借款服务协议》" forState:UIControlStateNormal];
            }else {
                [self.borrowingButton setTitle:@"《出借服务协议》" forState:UIControlStateNormal];
            }
        }
    });
    
}

- (void)bindeDataWithViewModel:(NSString *) viewModel {
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)handleCheck:(id)sender {
    
}

- (IBAction)handleTouristContract:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    switch (button.tag-200) {
        case 0:
        {
            // 旅游合同
            if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
                [self.delegate clickCell:self tag:JFTableCellClickTypeTouristContract userinfo:nil];
            }
            
        }
            break;
        case 1:
        {
            if ([self.orderType isEqualToString:@"fq"]) {
                
                if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
                    [self.delegate clickCell:self tag:JFTableCellClickTypeAntimoneylaundering userinfo:nil];
                }
                
            }else {
                if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
                    [self.delegate clickCell:self tag:JFTableCellClickTypeServiceAgreement userinfo:nil];
                }
            }
            
        }
            break;
            
        default:
            break;
    }
    
}

- (IBAction)handleTouristContractPhone:(id)sender {
    
    NSLog(@"执行协议");
    UIButton *button = (UIButton *)sender;
    switch (button.tag-200) {
        case 0:
        {
            // 旅游合同
            if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
                [self.delegate clickCell:self tag:JFTableCellClickTypeTouristContract userinfo:nil];
            }
        }
            break;
        case 1:
        {
            if ([self.orderType isEqualToString:@"fq"]) {
                
                if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
                    [self.delegate clickCell:self tag:JFTableCellClickTypeAntimoneylaundering userinfo:nil];
                }
            }else {
                if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
                    [self.delegate clickCell:self tag:JFTableCellClickTypeServiceAgreement userinfo:nil];
                }
            }
        }
            break;
        default:
            break;
    }
}



@end

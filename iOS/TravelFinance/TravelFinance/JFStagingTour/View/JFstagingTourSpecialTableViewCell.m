//
//  JFstagingTourSpecialTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/29.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFstagingTourSpecialTableViewCell.h"

#import "JFStagingTourlistSubjectItem.h"
#import "UIImageView+WebCache.h"
#import "JFMacro.h"

@interface JFstagingTourSpecialTableViewCell ()

@property (nonatomic, strong) NSMutableArray *specialItemArray;

@end
@implementation JFstagingTourSpecialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapSpecialOneViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hundleSpecialOneEven:)];
    [self.specialLeftView addGestureRecognizer:tapSpecialOneViewGesture];
    
    
    UITapGestureRecognizer *tapSpecialSecondViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hundleSpecialSecondEven:)];
    [self.specialRightTopView addGestureRecognizer:tapSpecialSecondViewGesture];
    
    UITapGestureRecognizer *tapSpecialThirdViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hundleSpecialThirdEven:)];
    [self.specialRightBottomView addGestureRecognizer:tapSpecialThirdViewGesture];
    
    self.specialItemArray = [[NSMutableArray alloc] init];
    
    self.firstSubjectwidth.constant = 125*JFWidthRateScale;
    self.secondSubjectwidth.constant = 56*JFWidthRateScale;
    self.thirdSubjectwidth.constant = 56*JFWidthRateScale;
    self.secondwidth.constant = 28*JFWidthRateScale;
    self.thirdwidth.constant = 28*JFWidthRateScale;
    self.firstLineWidth.constant = 187*JFWidthRateScale;
    self.firstWidth.constant = 35*JFWidthRateScale;
    self.firstSubjectHeight.constant = 101*JFHeightRateScale;
    self.secondSubjectHeight.constant = 56*JFHeightRateScale;
    self.thirdSubjectHeight.constant = 56*JFHeightRateScale;
}

- (void)bindeDataWithViewModel:(JFStagingTourlistSubjectItem *) viewModel viewModelList:(NSMutableArray *)viewModelArray {
    
    self.specialItemArray = viewModelArray;
    [viewModelArray enumerateObjectsUsingBlock:^(JFStagingTourlistSubjectItem  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.orders integerValue] == 1) {
            //            [self.specialItemArray addObject:obj];
            self.specialTitleLabel.text = obj.name;
            self.specialSubtitleLabel.text = obj.pushTitle;
            [self.specialOneLogoImageView sd_setImageWithURL:[NSURL URLWithString:obj.imgPath] placeholderImage:[UIImage imageNamed:@""]];
        }else if([obj.orders integerValue] == 2){
            //            [self.specialItemArray addObject:obj];
            self.specialSecondTitleLabel.text = obj.name;
            self.specialSecondSubtitleLabel.text = obj.pushTitle;
            [self.specialSecondLogoImageView sd_setImageWithURL:[NSURL URLWithString:obj.imgPath] placeholderImage:[UIImage imageNamed:@""]];
            
        }else if ([obj.orders integerValue] == 3){
            //            [self.specialItemArray addObject:obj];
            self.specialThirdTitleLabel.text = obj.name;
            self.specialThirdSubtitleLabel.text = obj.pushTitle;
            [self.stagingtour_specialThirdLogo sd_setImageWithURL:[NSURL URLWithString:obj.imgPath] placeholderImage:[UIImage imageNamed:@""]];
        }
        
    }];
}

- (void) hundleSpecialOneEven:(UITapGestureRecognizer*) gesture {
    
    if (self.specialItemArray.count > 0) {
        
        [self.specialItemArray enumerateObjectsUsingBlock:^(JFStagingTourlistSubjectItem  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.orders integerValue] == 1) {
                if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
                    [self.delegate clickCell:self tag:JFTableCellClickTypeSpecialone userinfo:obj.subjectId];
                }
            }else if([obj.orders integerValue] == 2){
            }else if ([obj.orders integerValue] == 3){
            }
            
        }];
    }
}

- (void) hundleSpecialSecondEven:(UITapGestureRecognizer*) gesture {
    if (self.specialItemArray.count > 1) {
        
        [self.specialItemArray enumerateObjectsUsingBlock:^(JFStagingTourlistSubjectItem  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.orders integerValue] == 1) {
            }else if([obj.orders integerValue] == 2){
                if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
                    [self.delegate clickCell:self tag:JFTableCellClickTypeSpecialSecond userinfo:obj.subjectId];
                }
            }else if ([obj.orders integerValue] == 3){
            }
            
        }];
    }
}

- (void) hundleSpecialThirdEven:(UITapGestureRecognizer*) gesture {
    if (self.specialItemArray.count > 2) {
        
        [self.specialItemArray enumerateObjectsUsingBlock:^(JFStagingTourlistSubjectItem  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.orders integerValue] == 1) {
            }else if([obj.orders integerValue] == 2){
            }else if ([obj.orders integerValue] == 3){
                if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
                    [self.delegate clickCell:self tag:JFTableCellClickTypeHomeSpecialThird userinfo:obj.subjectId];
                }
            }
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

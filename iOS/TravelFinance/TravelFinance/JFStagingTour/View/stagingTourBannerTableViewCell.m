//
//  stagingTourBannerTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/29.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "stagingTourBannerTableViewCell.h"

#import "SDCycleScrollView.h"
#import "JFStagingTourBannerItem.h"
#import "JFMacro.h"
#import "JFDevice.h"

@interface stagingTourBannerTableViewCell ()<SDCycleScrollViewDelegate>

@property (nonatomic ,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic ,strong) NSMutableArray *bannerViewModelArray;

@end

@implementation stagingTourBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bannerViewModelArray = [[NSMutableArray alloc] init];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [JFDevice screenWidth], 195*JFHeightRateScale) delegate:self placeholderImage:[UIImage imageNamed:@"stagingtour_bannerdefault"]];
    [self addSubview:self.cycleScrollView];
    
    //    [self.routeView setHidden:YES];
//    self.bannerHeight.constant = 195*JFHeightRateScale;
}

- (IBAction)integralClickFunc:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
        
        [self.delegate clickCell:self tag:JFTableCellClickTypeintegral userinfo:@""];
    }
    
}

- (IBAction)stagesClickFunc:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
        
        [self.delegate clickCell:self tag:JFTableCellClickTypestages userinfo:@"FQ"];
    }
    
}

- (IBAction)freeClickFunc:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
        
        [self.delegate clickCell:self tag:JFTableCellClickTypefree userinfo:@"BW"];
    }
    
}

- (IBAction)TravelTreasureClickFunc:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
        
        [self.delegate clickCell:self tag:JFTableCellClickTypeTravel userinfo:@""];
    }
    
}

- (void)bindeDataWithViewModel:(JFStagingTourBannerItem *) viewModel viewModelList:(NSMutableArray *)viewModelArray {
    
    self.bannerViewModelArray = viewModelArray;
    
    NSMutableArray *bannerImageArray = [[NSMutableArray alloc] init];
    [viewModelArray enumerateObjectsUsingBlock:^(JFStagingTourBannerItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [bannerImageArray addObject:obj.imgUrl];
    }];
    
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"banner_qh_on"];
    _cycleScrollView.pageDotImage = [UIImage imageNamed:@"banner_qh_off"];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.imageURLStringsGroup = bannerImageArray;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
        JFStagingTourBannerItem *bannerItem = self.bannerViewModelArray[index];
        NSString *locationUrlStr = [NSString stringWithFormat:@"%@", bannerItem.linkUrl];
        [self.delegate clickCell:self tag:JFTableCellClickTypeHeaderBanner userinfo:locationUrlStr];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}







@end

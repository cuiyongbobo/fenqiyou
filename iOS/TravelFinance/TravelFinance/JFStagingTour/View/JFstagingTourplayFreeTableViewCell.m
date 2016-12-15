//
//  JFstagingTourplayFreeTableViewCell.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/29.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFstagingTourplayFreeTableViewCell.h"

#import "JFStagingTourlistBwItem.h"
#import "JFstagingTourplayFreeTtemView.h"
#import "UIImageView+WebCache.h"
#import "JFDevice.h"
#import "MyScrollView.h"

@interface JFstagingTourplayFreeTableViewCell ()<JFBannerScrollViewDelegate>

@property (nonatomic ,strong) NSMutableArray *freeItemViewModelArray;

@end

@implementation JFstagingTourplayFreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.freeItemViewModelArray = [[NSMutableArray alloc] init];
}

- (void)bindeDataWithViewModel:(NSMutableArray *) viewModel {
    self.freeItemViewModelArray = viewModel;
}

- (void)layoutSubviews {
    [self.playFreeScrollView layoutIfNeeded];
    
    if (self.freeItemViewModelArray.count >0) {
        [self  initShuffling];
    }
}

#pragma mark 图片自动播放

-(void)initShuffling {
    MyScrollView *_bannerView = [[MyScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.playFreeScrollView.frame)) imageArr:self.freeItemViewModelArray];
    _bannerView.freePlayDelegate = self;
    [self.playFreeScrollView addSubview:_bannerView];
}

- (void)didSelectBannerView:(NSInteger)index {
    
    if (self.freeItemViewModelArray.count > index) {
        JFStagingTourlistBwItem *listFreeItem = self.freeItemViewModelArray[index];
        if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
            [self.delegate clickCell:self tag:JFTableCellClickTypefqGoodsDetails userinfo:listFreeItem.goodsUrl];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

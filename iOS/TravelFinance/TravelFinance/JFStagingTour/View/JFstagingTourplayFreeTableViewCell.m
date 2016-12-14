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
#import "NewPagedFlowView.h"
#import "JFstagingTourplayFreeTtemView.h"

@interface JFstagingTourplayFreeTableViewCell ()<UIScrollViewDelegate,NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
{
    NSTimer *_selftimers;
}
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
    [self  initShuffling];
}

#pragma mark 图片自动播放

-(void)initShuffling
{
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, [JFDevice screenWidth], 218)];
    
    //    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:self.playFreeScrollView.bounds];
    
    pageFlowView.backgroundColor = [UIColor whiteColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    
    //提前告诉有多少页
    //    pageFlowView.orginPageCount = self.imageArray.count;
    
    pageFlowView.isOpenAutoScroll = NO;
    
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 24 - 8, [JFDevice screenWidth], 8)];
    pageFlowView.pageControl = pageControl;
    //    [pageFlowView addSubview:pageControl];
    
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为NewPagedFlowView的容器View,才会显示正常,如下
     *****************************/
    
    //    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    //    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:self.playFreeScrollView.bounds];
    
    [self.playFreeScrollView addSubview:pageFlowView];
    
    [pageFlowView reloadData];
    
    //    [self.contentView addSubview:bottomScrollView];
    
    
}

- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake([JFDevice screenWidth]/2, 218);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    if (self.freeItemViewModelArray.count > subIndex) {
        JFStagingTourlistBwItem *listFreeItem = self.freeItemViewModelArray[subIndex];
        if ([self.delegate respondsToSelector:@selector(clickCell:tag:userinfo:)]) {
            [self.delegate clickCell:self tag:JFTableCellClickTypefqGoodsDetails userinfo:listFreeItem.goodsUrl];
        }
    }
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.freeItemViewModelArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    JFstagingTourplayFreeTtemView *bannerView = (JFstagingTourplayFreeTtemView *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[[NSBundle mainBundle] loadNibNamed:@"JFstagingTourplayFreeTtemView" owner:nil options:nil] lastObject];
    }
    //在这里下载网络图片
    //  [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    //    bannerView.mainImageView.image = self.imageArray[index];
    JFStagingTourlistBwItem *listFreeItem = self.freeItemViewModelArray[index];
    
    bannerView.freeTtemFromCitylabel.text = [NSString stringWithFormat:@"%@出发",listFreeItem.fromcity];
    [bannerView.freeTtemLogoImageVIew sd_setImageWithURL:[NSURL URLWithString:listFreeItem.imageLogo]
                                        placeholderImage:nil];
    bannerView.freeTtemTitlelabel.text = listFreeItem.pushName;
    bannerView.freeTtemPriceLabel.text = [NSString stringWithFormat:@"￥%@",listFreeItem.price];
    bannerView.freeTtemInvestmentAmountLabel.text = [NSString stringWithFormat:@"投￥%@",listFreeItem.defAmount];
    bannerView.freeTtemClosedPeriodLabel.text = [NSString stringWithFormat:@"封闭期%@天",listFreeItem.productPeriod];
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

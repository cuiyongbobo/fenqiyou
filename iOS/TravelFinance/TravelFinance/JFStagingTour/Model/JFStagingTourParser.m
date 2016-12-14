//
//  JFStagingTourParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/31.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFStagingTourParser.h"

#import "JFStagingTourBannerItem.h"
#import "JFStagingTourfqGoodsItem.h"
#import "JFStagingTourfqGoodslistTagItem.h"
#import "JFStagingTourlistSubjectItem.h"
#import "JFStagingTourlistBwItem.h"
#import "JFStagingTourfqGoodslistTagItem.h"

@implementation JFStagingTourParser

+ (instancetype)sharedStagingTourParser {
    static JFStagingTourParser *stagingTourParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stagingTourParser = [[JFStagingTourParser alloc] init];
    });
    return stagingTourParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData{
    
    self.fqGoodsItem = [[JFStagingTourfqGoodsItem alloc] init];
    
    self.bannerItemArrayList = (NSMutableArray<JFStagingTourBannerItem *> *)[NSMutableArray array];
    
    self.subjectItemArrayList = (NSMutableArray<JFStagingTourlistSubjectItem *> *)[NSMutableArray array];
    
    self.bwItemArrayList = (NSMutableArray<JFStagingTourlistBwItem *> *)[NSMutableArray array];
    
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        
        //  解析data
        
        // 解析listBanner
        NSArray *listBanner = jsonData[@"listBanner"];
        [listBanner enumerateObjectsUsingBlock:^(NSDictionary   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JFStagingTourBannerItem *bannerTtem = [[JFStagingTourBannerItem alloc] init];
            bannerTtem.bannerId = obj[@"bannerId"];
            bannerTtem.title = obj[@"title"];
            bannerTtem.imgUrl = obj[@"imgUrl"];
            bannerTtem.linkUrl = obj[@"linkUrl"];
            bannerTtem.orders = obj[@"orders"];
            [_bannerItemArrayList addObject:bannerTtem];
        }];
        
        //解析 fqGoods
        NSDictionary *fqGoodsDict = jsonData[@"fqGoods"];
        self.fqGoodsItem.goodsId = fqGoodsDict[@"goodsId"];
        self.fqGoodsItem.pushName = fqGoodsDict[@"pushName"];
        self.fqGoodsItem.levelName = fqGoodsDict[@"levelName"];
        self.fqGoodsItem.imageLogo = fqGoodsDict[@"imageLogo"];
        self.fqGoodsItem.defAmount = fqGoodsDict[@"defAmount"];
        self.fqGoodsItem.defFqAmount = fqGoodsDict[@"defFqAmount"];
        self.fqGoodsItem.price = fqGoodsDict[@"price"];
        self.fqGoodsItem.fromcity = fqGoodsDict[@"fromcity"];
        self.fqGoodsItem.goodsCategoryId = fqGoodsDict[@"goodsCategoryId"];
        self.fqGoodsItem.isFree = fqGoodsDict[@"isFree"];
        self.fqGoodsItem.goodsUrl = fqGoodsDict[@"goodsUrl"];
        NSArray *tagArray = fqGoodsDict[@"listTag"];
        [tagArray enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JFStagingTourfqGoodslistTagItem *listTag = [[JFStagingTourfqGoodslistTagItem alloc] init];
            listTag.tagId = obj[@"tagId"];
            listTag.icon = obj[@"icon"];
            listTag.tagName = obj[@"tagName"];
            
            [self.fqGoodsItem.fqGoodslistTagListItem  addObject:listTag];
        }];
        
        // 解析 listSubject
        NSArray *listSubject = jsonData[@"listSubject"];
        [listSubject enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            JFStagingTourlistSubjectItem *listSubject = [[JFStagingTourlistSubjectItem alloc] init];
            listSubject.subjectId = obj[@"subjectId"];
            listSubject.name = obj[@"name"];
            listSubject.pushTitle = obj[@"pushTitle"];
            listSubject.orders = obj[@"orders"];
            listSubject.imgPath = obj[@"imgPath"];
            [self.subjectItemArrayList addObject:listSubject];
        }];
        
        // 解析 listBw
        NSArray *bwArray = jsonData[@"listBw"];
        [bwArray enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JFStagingTourlistBwItem *bwItem = [[JFStagingTourlistBwItem alloc] init];
            bwItem.goodsId = obj[@"goodsId"];
            bwItem.pushName = obj[@"pushName"];
            bwItem.levelName = obj[@"levelName"];
            bwItem.imageLogo = obj[@"imageLogo"];
            bwItem.defAmount = obj[@"defAmount"];
            bwItem.defFqAmount = obj[@"defFqAmount"];
            bwItem.price = obj[@"price"];
            bwItem.fromcity = obj[@"fromcity"];
            bwItem.goodsCategoryId = obj[@"goodsCategoryId"];
            bwItem.isFree = obj[@"isFree"];
            bwItem.goodsUrl = obj[@"goodsUrl"];
            bwItem.productPeriod = obj[@"productPeriod"];
            [self.bwItemArrayList addObject:bwItem];
        }];
    }
}


@end

//
//  JFStagingTourListParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/31.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFStagingTourListParser.h"

@implementation JFStagingTourListParser

+ (instancetype)sharedStagingTourListParser {
    static JFStagingTourListParser *stagingTourListParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stagingTourListParser = [[JFStagingTourListParser alloc] init];
    });
    return stagingTourListParser;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)parseData:(id)jsonData{
    
    self.stagingTourSelectItemArrayList = (NSMutableArray<JFStagingTourfqGoodsItem *> *)[NSMutableArray array];
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        
        self.numberTotal = jsonData[@"total"];
        self.pageSize = jsonData[@"pageSize"];
        //  解析data
        //解析 fqGoods
        NSArray *listBwArray = jsonData[@"list"];
        [listBwArray enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull fqGoodsDict, NSUInteger idx, BOOL * _Nonnull stop) {
            //JFStagingTourfqGoodsItem
            JFStagingTourfqGoodsItem *fqGoodsItem = [[JFStagingTourfqGoodsItem alloc] init];
            fqGoodsItem.goodsId = fqGoodsDict[@"goodsId"];
            fqGoodsItem.pushName = fqGoodsDict[@"pushName"];
            fqGoodsItem.levelName = fqGoodsDict[@"levelName"];
            fqGoodsItem.imageLogo = fqGoodsDict[@"imageLogo"];
            fqGoodsItem.defAmount = fqGoodsDict[@"defAmount"];
            fqGoodsItem.defFqAmount = fqGoodsDict[@"defFqAmount"];
            fqGoodsItem.price = fqGoodsDict[@"price"];
            fqGoodsItem.fromcity = fqGoodsDict[@"fromcity"];
            fqGoodsItem.goodsCategoryId = fqGoodsDict[@"goodsCategoryId"];
            fqGoodsItem.isFree = fqGoodsDict[@"isFree"];
            fqGoodsItem.productPeriod = fqGoodsDict[@"productPeriod"];
            fqGoodsItem.goodsUrl = fqGoodsDict[@"goodsUrl"];
            NSArray *tagArray = fqGoodsDict[@"listTag"];
            fqGoodsItem.fqGoodslistTagListItem = [[NSMutableArray alloc] init];
            if (tagArray.count >0) {
                [tagArray enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    JFStagingTourfqGoodslistTagItem *listTag = [[JFStagingTourfqGoodslistTagItem alloc] init];
                    listTag.tagId = obj[@"tagId"];
                    listTag.icon = obj[@"icon"];
                    listTag.tagName = obj[@"tagName"];
                    
                    [fqGoodsItem.fqGoodslistTagListItem  addObject:listTag];
                }];
            }
            [self.stagingTourSelectItemArrayList addObject:fqGoodsItem];
            
        }];
        
    }
}

@end

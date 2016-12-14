//
//  JFStagingTourParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/31.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

@class JFStagingTourBannerItem;
@class JFStagingTourlistSubjectItem;
@class JFStagingTourfqGoodsItem;
@class JFStagingTourlistBwItem;

@interface JFStagingTourParser : JFJsonParser

@property (nonatomic,strong) JFStagingTourfqGoodsItem *fqGoodsItem;
@property (nonatomic,strong) NSMutableArray<JFStagingTourBannerItem *> *bannerItemArrayList;
@property (nonatomic,strong) NSMutableArray<JFStagingTourlistSubjectItem *> *subjectItemArrayList;
@property (nonatomic,strong) NSMutableArray<JFStagingTourlistBwItem *> *bwItemArrayList;

+ (instancetype)sharedStagingTourParser;

@end

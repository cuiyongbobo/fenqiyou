//
//  JFStagingTourfqGoodsItem.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/31.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JFStagingTourfqGoodslistTagItem.h"

@interface JFStagingTourfqGoodsItem : NSObject

@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, strong) NSString *pushName;
@property (nonatomic, strong) NSString *levelName;
@property (nonatomic, strong) NSString *imageLogo;
@property (nonatomic, strong) NSString *defAmount;
@property (nonatomic, strong) NSString *defFqAmount;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *fromcity;
@property (nonatomic, strong) NSString *goodsCategoryId;
@property (nonatomic, strong) NSString *isFree;
@property (nonatomic, strong) NSString *productPeriod;
@property (nonatomic, strong) NSMutableArray<JFStagingTourfqGoodslistTagItem *> *fqGoodslistTagListItem;
@property (nonatomic, strong) NSString *goodsUrl;

@end

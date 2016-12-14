//
//  JFStagingTourListParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/31.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

#import "JFStagingTourfqGoodsItem.h"

@interface JFStagingTourListParser : JFJsonParser

@property (nonatomic,strong) NSMutableArray<JFStagingTourfqGoodsItem *> *stagingTourSelectItemArrayList;
@property (nonatomic,strong) NSString *numberTotal;
@property (nonatomic,strong) NSString *pageSize;


+ (instancetype)sharedStagingTourListParser;

@end

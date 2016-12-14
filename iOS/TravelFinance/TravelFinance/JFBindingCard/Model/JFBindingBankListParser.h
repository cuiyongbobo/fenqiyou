//
//  JFBindingBankListParser.h
//  TravelFinance
//
//  Created by cuiyong on 16/11/11.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFJsonParser.h"

#import "JFBankListModel.h"

@interface JFBindingBankListParser : JFJsonParser

@property (nonatomic, strong) NSMutableArray<JFBankListModel *> *BankModelArray;

+ (instancetype)sharedbankListParser;

@end

//
//  JFUpdateVersionParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/25.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFUpdateVersionParser.h"

@implementation JFUpdateVersionParser

+ (instancetype)sharedupdateVersionParser {
    static JFUpdateVersionParser *updateVersionParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        updateVersionParser = [[JFUpdateVersionParser alloc] init];
    });
    return updateVersionParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData {
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        self.updateVersionItem = [[JFUpdateVersionItem alloc] init];
        self.updateVersionItem.curVersion = jsonData[@"curVersion"];
        self.updateVersionItem.firstVersion = jsonData[@"firstVersion"];
        self.updateVersionItem.isUpdate = jsonData[@"isUpdate"];
        self.updateVersionItem.downUrl = jsonData[@"downUrl"];
        self.updateVersionItem.memo = jsonData[@"memo"];
    }
}


@end

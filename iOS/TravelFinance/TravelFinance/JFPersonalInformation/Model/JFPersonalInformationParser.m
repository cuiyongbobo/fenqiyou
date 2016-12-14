//
//  JFPersonalInformationParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/11/21.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFPersonalInformationParser.h"

@implementation JFPersonalInformationParser

+ (instancetype)sharedPersonInformationParser {
    static JFPersonalInformationParser *personInformationParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        personInformationParser = [[JFPersonalInformationParser alloc] init];
    });
    return personInformationParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData{
    
    self.personInformationItem = [[JFPersonalInformationItem alloc] init];
    self.personInformationItem.bankCardNumber = jsonData[@"bankCardNumber"];
    self.personInformationItem.idCardNo = jsonData[@"idCardNo"];
    self.personInformationItem.mobile = jsonData[@"mobile"];
    self.personInformationItem.realName = jsonData[@"realName"];
    self.personInformationItem.userPicurl = jsonData[@"userPicurl"];
    self.personInformationItem.userId = jsonData[@"userId"];
    self.personInformationItem.email = jsonData[@"email"];
    self.personInformationItem.htmlStr = jsonData[@"htmlStr"];
    self.personInformationItem.sex = jsonData[@"sex"];
}


@end

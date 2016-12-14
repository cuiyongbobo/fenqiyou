//
//  JFSendCodeParser.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/28.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFSendCodeParser.h"

@implementation JFSendCodeParser

+ (instancetype)sharedSendCodeParser {
    static JFSendCodeParser *sendCodeParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sendCodeParser = [[JFSendCodeParser alloc] init];
    });
    return sendCodeParser;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)parseData:(id)jsonData {
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        //  解析data
        NSLog(@"message = %@",self.message);
        
    }
}
@end

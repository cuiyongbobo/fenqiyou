//
//  JFString.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/23.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFString.h"

static NSNumberFormatter *sharedBankCardNumberFormatter = nil;
static NSNumberFormatter *sharedDoubleNumberFormatter = nil;

@implementation JFString

+ (NSString *)numberStrToWanWith:(NSString *)numberStr {
    NSString *wanStr = [NSString stringWithFormat:@"%.0f万元",[numberStr doubleValue]];
    
    return wanStr;
}

+ (NSString *)getCurrency:(double)numberValue {
    double resNumber = fabs(numberValue);;
    NSString *numberString = [NSString stringWithFormat:@"%0.2lf",resNumber];
    NSNumber *num = [NSNumber numberWithDouble:[numberString doubleValue]];
    
    if (nil == sharedDoubleNumberFormatter) {
        sharedDoubleNumberFormatter = [[NSNumberFormatter alloc ] init];
        [sharedDoubleNumberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
        [sharedDoubleNumberFormatter setCurrencySymbol: @""];
        [sharedDoubleNumberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    }
    
    if (numberValue >= 0) {
        return [sharedDoubleNumberFormatter stringFromNumber:num] ;
    }else {
        return [@"-" stringByAppendingString:[sharedDoubleNumberFormatter stringFromNumber:num]];
    }
}

+ (NSString *)chineseWithNumber:(double)number {
    if (number == 0) {
        return @"请输入金额";
    }
    else if (number < 1.0) {
        return @"每次支付最低1元，剩余资金将转入您的账户余额。";
    }
    
    NSString *str = [NSString stringWithFormat:@"最后%.2f元，全归您了！",number];
    
    return str;
}

+ (NSString *)chinestWithOne:(int)one {
    switch (one) {
        case 1:
            return @"一";
            break;
        case 2:
            return @"二";
            break;
        case 3:
            return @"三";
            break;
        case 4:
            return @"四";
            break;
        case 5:
            return @"五";
            break;
        case 6:
            return @"六";
            break;
        case 7:
            return @"七";
            break;
        case 8:
            return @"八";
            break;
        case 9:
            return @"九";
            break;
            
        default:
            return nil;
            break;
    }
}

+ (NSString *)formatPhoneNumber:(NSString *)phoneNumber {
    
    NSString *phoneNumberString = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSMutableString *formatPhoneNumberString = [NSMutableString stringWithString:phoneNumberString];
    
    if(phoneNumberString.length >= 3){
        [formatPhoneNumberString insertString:@" " atIndex:3];
        
        if (phoneNumberString.length >= 7) {
            [formatPhoneNumberString insertString:@" " atIndex:8];
        }
    }
    
    return formatPhoneNumberString;
}

+ (NSString *)formatBankCardNumber:(NSString *)bankCardNumber {
    
    if (0 == bankCardNumber.length) {
        return nil;
    }
    
    if (nil == sharedBankCardNumberFormatter) {
        sharedBankCardNumberFormatter = [NSNumberFormatter new];
        [sharedBankCardNumberFormatter setUsesGroupingSeparator:YES];
        [sharedBankCardNumberFormatter setGroupingSize:4];
        [sharedBankCardNumberFormatter setSecondaryGroupingSize:4];
        [sharedBankCardNumberFormatter setGroupingSeparator:@" "];
    }
    
    NSNumber *bankCardNumberString = @([bankCardNumber longLongValue]);
    
    return [sharedBankCardNumberFormatter stringFromNumber:bankCardNumberString];
}

+ (NSString *)intValueStringFromDouble:(double)number {
    
    if (number < 0) {
        number = -number;
    }
    
    NSNumber *doubleNumber =  [NSNumber numberWithDouble:number];
    NSString *numString = [NSString stringWithFormat:@"%ld",[doubleNumber integerValue]];
    
    if (numString.length < 3) {
        return numString;
    }
    
    NSMutableString *resString = [NSMutableString string];
    
    NSInteger delta = numString.length % 3;
    
    NSInteger remainLength = 0;
    
    if (delta >  0) {
        [resString appendString:[numString substringToIndex:delta]];
        remainLength = numString.length - delta;
    }
    else{
        [resString appendString:[numString substringToIndex:3]];
        remainLength = numString.length - 3;
        delta = 3;
    }
    
    while (remainLength > 0) {
        [resString appendFormat:@",%@",[numString substringWithRange:NSMakeRange(delta, 3)] ];
        remainLength -= 3;
        delta += 3;
    }
    
    return resString;
}

+ (NSString *)doubleValueStringFromDouble:(double)number {
    
    NSString *resString = nil;
    
    if (number < 0) {
        number = fabs(number);
        resString = @"-";
    }
    
    NSNumber *doubleNumber =  [NSNumber numberWithDouble:number];
    NSString *numString = [NSString stringWithFormat:@"%0.2lf",[doubleNumber doubleValue]];
    
    NSArray *numList =  [numString componentsSeparatedByString:@"."];
    
    if (numList.count != 2 ) {
        return nil;
    }
    
    NSString *intValue = [JFString intValueStringFromDouble:number];
    
    if (resString) {
        resString = [resString stringByAppendingFormat:@"%@.%@",intValue,numList[1]];
    }else{
        resString = [NSString stringWithFormat:@"%@.%@",intValue,numList[1]];
    }
    
    return resString;
}

//https://github.com/tujinqiu/KTAvoidingEmojiText
+ (BOOL)isContainEmoji:(NSString *)string {
    __block BOOL contain = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if ([self isEmoji:string]) {
            contain = YES;
            *stop = YES;
        }
    }];
    
    return contain;
}

+ (BOOL)isEmoji:(NSString *)string {
    if (string.length <= 0) {
        return NO;
    }
    unichar first = [string characterAtIndex:0];
    switch (string.length) {
        case 1: {
            if (first == 0xa9 || first == 0xae || first == 0x2122 ||
                first == 0x3030 || (first >= 0x25b6 && first <= 0x27bf) ||
                first == 0x2328 || (first >= 0x23e9 && first <= 0x23fa)) {
                return YES;
            }
        }
            break;
            
        case 2: {
            unichar c = [string characterAtIndex:1];
            if (c == 0xfe0f) {
                if (first >= 0x203c && first <= 0x3299) {
                    return YES;
                }
            }
            if (first >= 0xd83c && first <= 0xd83e) {
                return YES;
            }
        }
            break;
            
        case 3: {
            unichar c = [string characterAtIndex:1];
            if (c == 0xfe0f) {
                if (first >= 0x23 && first <= 0x39) {
                    return YES;
                }
            }
            else if (c == 0xd83c) {
                if (first == 0x26f9 || first == 0x261d || (first >= 0x270a && first <= 0x270d)) {
                    return YES;
                }
            }
            if (first == 0xd83c) {
                return YES;
            }
        }
            break;
            
        case 4: {
            unichar c = [string characterAtIndex:1];
            if (c == 0xd83c) {
                if (first == 0x261d || first == 0x270c) {
                    return YES;
                }
            }
            if (first >= 0xd83c && first <= 0xd83e) {
                return YES;
            }
        }
            break;
            
        case 5: {
            if (first == 0xd83d) {
                return YES;
            }
        }
            break;
            
        case 8:
        case 11: {
            if (first == 0xd83d) {
                return YES;
            }
        }
            break;
            
        default:
            break;
    }
    
    return NO;
}

+ (BOOL)judgeString:(NSString *)string {
    BOOL isresult=NO;
    if(string==nil)
    {
        isresult=YES;
    }
    //还有就是<null>，从网上找到了用法：
    if([string isEqual:[NSNull null]])
    {
        isresult=YES;
    }
    if ([NSString stringWithFormat:@"%@",string].length==0) {
        isresult=YES;
    }
    return  isresult;
}






@end

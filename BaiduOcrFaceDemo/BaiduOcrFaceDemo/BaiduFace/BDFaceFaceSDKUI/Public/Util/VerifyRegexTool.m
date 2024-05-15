//
//  VerifyRegexTool.m
//  IDLFaceSDKDemoOC
//
//  Created by v_shishuaifeng on 2020/9/10.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "VerifyRegexTool.h"

@implementation VerifyRegexTool

+ (BOOL) checkEmpty:(UITextField *) textField {
    return [VerifyRegexTool checkEmptyString:textField.text];
}

+ (BOOL) checkEmptyString:(NSString *) string {
    
    if (string == nil) return string == nil;
    
    NSString *newStr = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [newStr isEqualToString:@""];
}

// 姓名校验 2~8个中文字,不允许拼音,数字
+ (BOOL)checkRealName:(UITextField *)textField {
    return [VerifyRegexTool isVaildRealName:textField.text];
}

+ (BOOL)isVaildRealName:(NSString *)realName {
    if ([VerifyRegexTool checkEmptyString:realName]) return NO;
    
    NSRange range1 = [realName rangeOfString:@"●"];
    NSRange range2 = [realName rangeOfString:@"•"];
    NSRange range3 = [realName rangeOfString:@"▪"];
    NSRange range4 = [realName rangeOfString:@"·"];
    NSRange range5 = [realName rangeOfString:@"."];
    NSRange range6 = [realName rangeOfString:@"."];
    if(range1.location != NSNotFound ||   // 中文 ●
       range2.location != NSNotFound ||   // 中文 •
       range3.location != NSNotFound ||   // 中文 ▪
       range4.location != NSNotFound ||   // 英文 ·
       range5.location != NSNotFound ||   // 英文 .
       range6.location != NSNotFound)     // 英文 .
    {
        //一般中间带 `•`的名字长度不会超过15位，如果有那就设高一点
        if ([realName length] < 2 || [realName length] > 15)
        {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+[●•▪··.][\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:realName options:0 range:NSMakeRange(0, [realName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    }
    else
    {
        // 一般正常的名字长度不会少于2位并且不超过8位，如果有那就设高一点
        if ([realName length] < 2 || [realName length] > 8) {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:realName options:0 range:NSMakeRange(0, [realName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    }
}

// 身份证号码校验 （仅允许  数字 ||  Xx）
+ (BOOL)checkIDCardNum:(UITextField *)textField {
    return [VerifyRegexTool isVaildIDCardNo:textField.text];
}

// 身份证号码校验 （仅允许  数字 ||  Xx）
+ (BOOL)isVaildIDCardNo:(NSString *)idCardNo
{
    if ([VerifyRegexTool checkEmptyString:idCardNo]) return NO;
    
    // 首先第一步判断传入身份证号码长度是否为18位，如果不是直接返回NO
    
    if (idCardNo.length != 18) return NO;
    
    // 正则表达式判断基本 身份证号是否满足格式
    
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    
    // 如果通过该验证，说明身份证格式正确，但准确性还需计算
    
    if(![identityStringPredicate evaluateWithObject:idCardNo]) return NO;
        
    // 将前17位加权因子保存在数组里
    
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    // 这是除以11后，可能产生的11位余数、验证码，也保存成数组
    
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    // 用来保存前17位各自乖以加权因子后的总和
    
    NSInteger idCardWiSum = 0;
    
    for(int i = 0;i < 17;i++) {
        
        NSInteger subStrIndex = [[idCardNo substringWithRange:NSMakeRange(i, 1)] integerValue];
        
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        
        idCardWiSum+= subStrIndex * idCardWiIndex;
        
    }
    
    // 计算出校验码所在数组的位置
    
    NSInteger idCardMod=idCardWiSum%11;
    
    // 得到最后一位身份证号码
    
    NSString *idCardLast= [idCardNo substringWithRange:NSMakeRange(17, 1)];
    
    // 如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    
    if (idCardMod==2) {
        
        if (![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            
            return NO;
            
        }
        
    } else {
        
        // 用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        
        if (![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            
            return NO;
            
        }
        
    }
    
    return YES;
    
}

// 港澳台验证身份号码
+ (BOOL)isValidForGAT:(NSString *)strName {
    NSString *regular = @"^[H,M]\\d{10}|[H,M]\\d{8}|\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    BOOL isMatch = [pred evaluateWithObject:strName];
    return isMatch;
}

// 外国人永久居留证
+ (BOOL)isValidForForeignersPermit:(NSString *)strName {
    NSString *regular = @"[A-Z]{3}\\d{12}|[a-z]{3}\\d{12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    BOOL isMatch = [pred evaluateWithObject:strName];
    return isMatch;
}

// 定居国外的中国公民护照
+ (BOOL)isValidForCitizenPassport:(NSString *)strName {
    NSString *regular = @"^[E]\\d{8}|[E][A-Z]\\d{7}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    BOOL isMatch = [pred evaluateWithObject:strName];
    return isMatch;
}

+ (BOOL)isValidForGATCard:(NSString *)strName {
    NSString *regular = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    BOOL isMatch = [pred evaluateWithObject:strName];
    return isMatch;
}

@end

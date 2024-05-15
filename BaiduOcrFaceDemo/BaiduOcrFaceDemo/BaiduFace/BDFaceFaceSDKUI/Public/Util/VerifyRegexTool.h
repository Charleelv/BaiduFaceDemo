//
//  VerifyRegexTool.h
//  IDLFaceSDKDemoOC
//
//  Created by v_shishuaifeng on 2020/9/10.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VerifyRegexTool : NSObject

/**
 判断`UITextField`里面的字符串是否为空
 @param textField 文本输入框
 @return 返回结果同下面的`checkEmptyString`方法
 */
+ (BOOL) checkEmpty:(UITextField *)textField;

/**
 判断字符串是否为空
 @param string 字符串
 @return 如果为空返回`YES`  不为空返回`NO`    若果传入这些字符(nil @"" @" "  @"   ")，结果为`YES`
 */
+ (BOOL) checkEmptyString:(NSString *)string;

/**
 判断输入框内的文本是否是有效的身份证号码
 @param textField 文本输入框
 @return 返回结果同下面的`isVaildIDCardNo`方法
 */
+ (BOOL)checkIDCardNum:(UITextField *)textField;


/**
 判断是否是有效的身份证号码
 @param idCardNo 身份证号字符串
 @return 如果是有效的身份证号，返回`YES`, 否则返回`NO`
 
 仅允许  数字 && 最后一位是{数字 || Xx}）
 */
+ (BOOL)isVaildIDCardNo:(NSString *)idCardNo;

/**
 判断输入框内的人名是否是有效的中文名
 @param textField 文本输入框
 @return 返回结果同下面的`isVaildUserRealName`方法
 */
+ (BOOL)checkRealName:(UITextField *)textField;

/**
 判断是否是有效的中文名
 
 @param realName 名字
 @return 如果是在如下规则下符合的中文名则返回`YES`，否则返回`NO`
 限制规则：
    1. 首先是名字要大于两个汉字
    2. 如果是中间带`{•|·}`的名字，则限制长度15位（新疆人的名字有15位左右的），如果有更长的，请自行修改长度限制
    3. 如果是不带小点的正常名字，限制长度为8位，若果觉得不适，请自行修改位数限制
 *PS: `•`或`·`具体是那个点具体处理需要注意*
 */
+ (BOOL)isVaildRealName:(NSString *)realName;

/**
 港澳台来往内陆通行证
 @param strName 验证的字符串
 */
+ (BOOL)isValidForGAT:(NSString *)strName;

/**
 外国人永久居留证
 @param strName 验证字符串
 */
+ (BOOL)isValidForForeignersPermit:(NSString *)strName;

/**
 定居国外中国公民护照
 @param strName 验证字符串
 */
+ (BOOL)isValidForCitizenPassport:(NSString *)strName;

/**
 定居港澳居民身份
 @param strName 验证字符串
 */
+ (BOOL)isValidForGATCard:(NSString *)strName;

@end

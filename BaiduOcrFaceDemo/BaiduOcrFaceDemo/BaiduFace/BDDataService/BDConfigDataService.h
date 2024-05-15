//
//  BDConfigDataService.h
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/9/27.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BDFaceBaseKit/BDFaceBaseKit.h>
@class BDFaceAdjustParams;

NS_ASSUME_NONNULL_BEGIN

/// 用来设置打开关闭OCR的key, value是NSNumber，如果打开设置为@(YES)，关闭设置为@(NO)，调用下面的+ (void)setConfigValue:(NSObject *)object forKey:(NSString *)key 来设置
extern NSString *BDConfigDataServiceKeyForSettingOcr;
/// 用来设置打开关闭支持多种证件的key, value是NSNumber，，如果打开设置为@(YES)，关闭设置为@(NO)，调用下面的+ (void)setConfigValue:(NSObject *)object forKey:(NSString *)key 来设置
extern NSString *BDConfigDataServiceKeyForSettingMultiCard;

/**
 * 数据交换层
 */
@interface BDConfigDataService : NSObject

/**
 * 用于外部设置内部的值
 */
+ (void)setConfigValue:(NSObject *)object forKey:(NSString *)key;
/**
 * 配置身份证识别是否使用OCR来识别
 * // 1 OCR扫描    0  手动输入  2代码传入
 */
+ (int)useOCR;

/**
 * 支持多种证件类型，YES，支持多种类型，NO，只支持身份证
 */
+ (BOOL)supportMultiCard;

/**
 * 设置离线活体检测阀值
 */
+ (float)faceVerifyThreshold;

/**
 * 设置离线活体检测阀值
 */
+ (float)livenessVerifyThreadHold;

/**
 * 设置在线活体本地检测阀值
 */
+ (float)onlineVerifyLocalCheckThreadHold;

/**
 * 设置的风控阀值
 */
+ (float)riskScore;

/**
 * 在线质量控制
 */
+ (NSString *)onlineImageQuality;

/**
 * 在线活体控制
 */
+ (NSString *)onlineLivenessQuality;

/**
 * 获取方案id
 */
+ (nullable NSString *)planId;

/**
 * 检测质量参数
 */
+ (BDFaceAdjustParams *)faceImageParams;

/**
 * 人脸检测的类型
 */
+ (BDFaceLiveSelectType)faceRecognizeType;

/**
 * 动作数量, 只是在动作活体的时候才生效
 */
+ (int)actionNums;

/**
 * 所有支持的动作
 */
+ (NSArray<NSNumber *> *)actionArray;


@end

NS_ASSUME_NONNULL_END

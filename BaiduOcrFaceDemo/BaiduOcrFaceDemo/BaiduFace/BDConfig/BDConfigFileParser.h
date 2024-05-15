//
//  BDConfigFileParser.h
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/9/27.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDFaceAdjustParams.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDConfigFileParser : NSObject

/**
 * 在线质量控制
 */
@property(nonatomic, assign) NSString *onlineImageQuality;

/**
 * 在线活体控制
 */
@property(nonatomic, assign) NSString *onlineLivenessQuality;

/**
 * 是否加密，都写死了。加密 (目前没有用到,都是加密)
 */
@property(nonatomic, assign) int secType;

/**
 * 动作活体的时候，动作的数量
 */
@property(nonatomic, assign) int actionNum;

/**
 * 5 炫彩活体，6 动作活体 7 静默活体，默认5 服务端，只会下发0 1 2
 */
@property(nonatomic, assign) int faceRecognizeType;


/**
 * 风控阈值
 */
@property(nonatomic, assign) float riskScore;
/**
 *  身份证获取方式   1 OCR扫描    0  手动输入  2代码传入
 */
@property(nonatomic, assign) int useOCR;

/**
 * 用户选择的方案id
 */
@property(nonatomic, copy) NSString *planId;

/**
 * 检测质量参数
 */
@property(nonatomic, copy) BDFaceAdjustParams *faceImageParams;

/**
 * 设置离线活体检测阀值
 */
@property(nonatomic, assign) float faceVerifyActionThreshold;

/**
 * 设置在线活体检测阀值
 */
@property(nonatomic, assign) float livenessVerifyThreadHold;


/**
 * 动作Array
 */
@property(nonatomic, strong) NSArray *actionArray;

/**
 * 获取单例
 */
+ (instancetype)sharedInstance;

/**
 * 解析custom.conf文件，初始化预置的一些变量
 */
- (void)loadConfigFile;


@end

NS_ASSUME_NONNULL_END

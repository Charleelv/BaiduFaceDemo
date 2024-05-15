//
//  BDConfigFileParser.m
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/9/27.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "BDConfigFileParser.h"
#import "BDFaceSDKObjectChecker.h"

// 配置参数文件名和后缀
#define BDCONFIG_FILE_NAME    @"custom"
#define BDCONFIG_FILE_SUFFIX  @"conf"

static NSString *const BDFaceParamsConfigLooseKey = @"loose";
static NSString *const BDFaceParamsConfigNormalKey = @"normal";
static NSString *const BDFaceParamsConfigStrictKey = @"strict";

@implementation BDConfigFileParser

- (void)loadConfigFile {
    // 空实现，调用单例就会解析和加载数据
}

+ (instancetype)sharedInstance {
    static BDConfigFileParser *parser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parser = [[BDConfigFileParser alloc] init];
        [parser parseConfigFile];
    });
    return parser;
}

- (void)parseConfigFile {
    // 读取配置参数
    NSString *confPath = [[NSBundle mainBundle] pathForResource:BDCONFIG_FILE_NAME ofType:BDCONFIG_FILE_SUFFIX];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:confPath], @"confPath文件路径不对，请仔细查看文档");
    NSData *data = [NSData dataWithContentsOfFile:confPath];
    NSDictionary *config = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSAssert(config != nil, @"conf文件读取错误，请检查文件内容和格式");
    
    [self parseAndSetProperties:config];
}

- (void)parseAndSetProperties:(NSDictionary *)config {
#ifdef DEBUG
    NSString * versionStr = config[@"version"];
    if (![versionStr isEqualToString:@"3.0.0"]) {
        NSException *exception = [[NSException alloc] initWithName:@"BDFace:custom.config file is wrong." reason:@"The version in custom.config is wrong, try to download the file from ai.baidu again." userInfo:nil];
        @throw exception;
    }
#endif
    // 在线质量控制
    self.onlineImageQuality = config[@"onlineImageQuality"];
    // 在线活体控制
    self.onlineLivenessQuality = config[@"onlineLivenessQuality"];
    // 金融版本，都加密
    self.secType = 1;
    // 风控阈值, 在线活体检测，要求人脸比对的最低分数
    self.riskScore = [config[@"policeThreshold"] floatValue];
    // 身份证获取方式   1 OCR扫描    0  手动输入  2代码传入
    self.useOCR = [config[@"collection"] intValue];
    // 离线活体检测阀值
    self.livenessVerifyThreadHold = [config[@"livenessThreshold"] floatValue];
    
    // 动作数量默认 3个动作
    self.actionNum = config[@"faceActionNum"] ? [config[@"faceActionNum"] intValue] : 3;
    // 识别类型，默认炫彩
    self.faceRecognizeType = config[@"faceLivenessType"] ? [config[@"faceLivenessType"] intValue] : 5;
    
     //设置人脸阈值
    self.faceVerifyActionThreshold = [config[@"faceVerifyActionThreshold"] floatValue];
    
    // 动作actionArray
    self.actionArray = config[@"faceVerifyAction"];
    
    self.planId = config[@"planId"];
    
    /// 不一样的地方
    NSDictionary *localImageQuality = config[@"localImageQuality"];
    NSDictionary *configParams = nil;
    if ([BDFaceSDKObjectChecker dicIsNotNull:localImageQuality]) {
        NSDictionary *loose = localImageQuality[BDFaceParamsConfigLooseKey];
        NSDictionary *normal = localImageQuality[BDFaceParamsConfigNormalKey];
        NSDictionary *strict = localImageQuality[BDFaceParamsConfigStrictKey];
        if ([BDFaceSDKObjectChecker dicIsNotNull:loose]) {
            configParams = loose;
        } else if ([BDFaceSDKObjectChecker dicIsNotNull:normal]) {
            configParams = normal;
        } else if ([BDFaceSDKObjectChecker dicIsNotNull:strict]) {
            configParams = strict;
        }
    }
    
    if ([BDFaceSDKObjectChecker dicIsNotNull:configParams]) {
        self.faceImageParams = [[BDFaceAdjustParams alloc] initWithDic:configParams];
    }
}

@end

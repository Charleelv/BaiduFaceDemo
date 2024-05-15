//
//  BDConfigDataService.m
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/9/27.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "BDConfigDataService.h"
#import "BDConfigFileParser.h"

@interface BDConfigDataService ()

@property(nonatomic, strong) NSMutableDictionary *sharedDic;


@end

NSString *BDConfigDataServiceKeyForSettingOcr = @"BDConfigDataServiceKeyForSettingOcr";
NSString *BDConfigDataServiceKeyForSettingMultiCard = @"BDConfigDataServiceKeyForSettingMultiCard";

@implementation BDConfigDataService

+ (instancetype)sharedInstance {
    static BDConfigDataService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BDConfigDataService alloc] init];
        instance.sharedDic = [[NSMutableDictionary alloc] init];
    });
    return instance;
}

+ (void)setConfigValue:(NSObject *)object forKey:(NSString *)key {
    BDConfigDataService *service = [self sharedInstance];
    if (object
        && key
        && [key isKindOfClass:[NSString class]]) {
        [service.sharedDic setValue:object forKey:key];
    }
}

/**
 *  身份证获取方式   1 OCR扫描    0  手动输入  2代码传入
 */
+ (int)useOCR {
    BDConfigDataService *service = [self sharedInstance];
    NSNumber *value = service.sharedDic[BDConfigDataServiceKeyForSettingOcr];
    if (value) {
        return value.intValue;
    }
    return [[BDConfigFileParser sharedInstance] useOCR];
}

+ (BOOL)supportMultiCard {
    BDConfigDataService *service = [self sharedInstance];
    NSNumber *value = service.sharedDic[BDConfigDataServiceKeyForSettingMultiCard];
    if (value) {
        return value.boolValue;
    }
    // 默认 打开多种证件类型的识别
    return YES;
}

+ (float)faceVerifyThreshold {
    return [[BDConfigFileParser sharedInstance] faceVerifyActionThreshold];
}

+ (NSString *)onlineImageQuality {
    return [[BDConfigFileParser sharedInstance] onlineImageQuality];
}

+ (NSString *)onlineLivenessQuality {
    return [[BDConfigFileParser sharedInstance] onlineLivenessQuality];
}

+ (BDFaceAdjustParams *)faceImageParams {
    return [BDConfigFileParser sharedInstance].faceImageParams;
}

+ (float)riskScore {
    return [BDConfigFileParser sharedInstance].riskScore;
}

/**
 * 在线活体检测阀值
 */
+ (float)livenessVerifyThreadHold {
    return [BDConfigFileParser sharedInstance].livenessVerifyThreadHold;
}

+ (float)onlineVerifyLocalCheckThreadHold {
    // 默认0.8
    return 0.8;
}

/**
 活体的类型，服务端如果下发0：炫彩活体；1：动作活体；2，静默活体
 */
+ (BDFaceLiveSelectType)faceRecognizeType {
    int type = [BDConfigFileParser sharedInstance].faceRecognizeType;
    BDFaceLiveSelectType selectType = BDFaceColorType;
    switch (type) {
        case 0: {
            selectType = BDFaceColorType;
        }
            break;
        case 1: {
            selectType = BDFaceLivenessType;
        }
            break;
        case 2: {
            selectType = BDFaceDetectType;
        }
            break;
            
        default:
            break;
    }
    return selectType;
}


+ (int)actionNums {
    int value = (int)[BDConfigFileParser sharedInstance].actionNum;
    if (value <= [self actionArray].count) {
        return value;
    } else {
        return (int)([self actionArray].count);
    }
}

+ (NSArray<NSNumber *> *)actionArray {
    NSDictionary *dic = @{@"eye" : @(FaceLivenessActionTypeLiveEye),
                          @"mouth" : @(FaceLivenessActionTypeLiveMouth),
                          @"headRight" : @(FaceLivenessActionTypeLiveYawRight),
                          @"headLeft" : @(FaceLivenessActionTypeLiveYawLeft),
                          @"headUp" : @(FaceLivenessActionTypeLivePitchUp),
                          @"headDown" : @(FaceLivenessActionTypeLivePitchDown),
                          @"shakeHead":@(FaceLivenessActionTypeShakeHead),
                          @"noaction":@(FaceLivenessActionTypeNoAction),
    };
    NSMutableArray *desArray = [NSMutableArray array];
    NSArray *actionArray = [BDConfigFileParser sharedInstance].actionArray;
    for (NSString *eachKey in actionArray) {
        NSNumber *value = dic[eachKey];
        [desArray addObject:value];
    }
    
    
    if (desArray == nil) {
        return [[NSArray alloc] initWithObjects:@(FaceLivenessActionTypeLiveEye), @(FaceLivenessActionTypeLiveMouth), @(FaceLivenessActionTypeLiveYawRight), @(FaceLivenessActionTypeLiveYawLeft), @(FaceLivenessActionTypeLivePitchUp), @(FaceLivenessActionTypeLivePitchDown),@(FaceLivenessActionTypeShakeHead),@(FaceLivenessActionTypeNoAction), nil]; // 默认全部6个动作
    }
    return [NSArray arrayWithArray:desArray];
}

+ (nullable NSString *)planId {
    return [[BDConfigFileParser sharedInstance] planId];
}

@end

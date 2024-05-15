//
//  BDFaceAdjustParamsTool.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/8.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceAdjustParamsTool.h"
#import "BDFaceAdjustParamsFileManager.h"
#import "BDFaceAdjustParamsConstants.h"
#import <BDFaceBaseKit/BDFaceBaseKit.h>

@implementation BDFaceAdjustParamsTool

+ (void)setDefaultConfig {
    [[BDFaceAdjustParamsFileManager sharedInstance] saveUserSelection:BDFaceSelectTypeNormal];//默认第一次进入选择正常阈值其他不变

    BDFaceSelectType select = [BDFaceAdjustParamsFileManager readCacheSelect];
    
    [BDFaceAdjustParamsFileManager sharedInstance].selectType = select;
    BDFaceAdjustParams *params = [[BDFaceAdjustParamsFileManager sharedInstance] configBySelection:select];
    if (!params) {
        return;
    }
    [self changeConfig:params];
}

+ (void)changeConfig:(BDFaceAdjustParams *)params {
    [[FaceSDKManager sharedInstance] setMinIllumThreshold:params.minLightIntensity];
    [[FaceSDKManager sharedInstance] setMaxIllumThreshold:params.maxLightIntensity];
    [[FaceSDKManager sharedInstance] setBlurThreshold:params.ambiguity];
    
    [[FaceSDKManager sharedInstance] setOccluLeftEyeThreshold:params.leftEyeOcclusion];
    [[FaceSDKManager sharedInstance] setOccluRightEyeThreshold:params.rightEyeOcclusion];
    [[FaceSDKManager sharedInstance] setOccluNoseThreshold:params.noseOcclusion];
    [[FaceSDKManager sharedInstance] setOccluMouthThreshold:params.mouthOcclusion];
    [[FaceSDKManager sharedInstance] setOccluLeftCheekThreshold:params.leftFaceOcclusion];
    [[FaceSDKManager sharedInstance] setOccluRightCheekThreshold:params.rightFaceOcclusion];
    [[FaceSDKManager sharedInstance] setOccluChinThreshold:params.lowerJawOcclusion];
    [[FaceSDKManager sharedInstance] setEulurAngleThrPitch:params.upAndDownAngle yaw:params.leftAndRightAngle roll:params.spinAngle];
}

@end

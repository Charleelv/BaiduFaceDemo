//
//  BDFaceVerificationConstant.m
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/8/20.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "BDFaceVerificationConstant.h"

@implementation BDFaceVerificationConstant

+ (instancetype)sharedInstance {
    static BDFaceVerificationConstant *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BDFaceVerificationConstant alloc] init];
    });
    return instance;
}

@end

//
//  BDFaceVerificationConstant.h
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/8/20.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BDFaceVerificationIdCardAndImageVerification = 0, // 实名认证
    BDFaceVerificationDoubleImagesCompare = 1,// 人脸比对
    BDFaceVerificationLiveCheck = 2// 活体检测
} BDFaceVerificationType;


@interface BDFaceVerificationConstant : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign) BDFaceVerificationType verifyType;

@end

NS_ASSUME_NONNULL_END

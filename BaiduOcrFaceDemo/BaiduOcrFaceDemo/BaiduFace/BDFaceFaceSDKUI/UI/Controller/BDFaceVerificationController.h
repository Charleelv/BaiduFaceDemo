//
//  BDFaceVerificationController.h
//  IDLFaceSDKDemoOC
//
//  Created by v_shishuaifeng on 2020/8/27.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDFaceVerificationController : UIViewController

/// 成功回调
- (void)showBDFaceSuccess;
/// 失败回调
- (void)showBDFaceLiveFail:(NSString *)message;

/// 身份核验失败页面（核验失败）
- (void)showBDFaceFail;

/// 身份核验失败页面（公安网身份信息 覆盖不全）
- (void)showBDFaceFailGongan;

/// 服务端返回errorCode不为Nil的情况
- (void)showServerError:(int)code riskLevel:(int)riskLevel;

@end


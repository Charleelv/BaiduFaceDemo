//
//  ViewController+MainSteps.h
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/10/17.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "FaceViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaceViewController (Main_process)

//- (void)getAccessToken;

/**
 *初始化人脸和OCRSDK
 */
- (void)initFaceServiceAndInfoCollectService;

/**
 * 开始人证核验的主流程
 */
- (void)startCheck;


@end

NS_ASSUME_NONNULL_END

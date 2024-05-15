//
//  ViewController+FaceCollect.m
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by wuyunpeng01 on 2022/2/14.
//  Copyright © 2022 Baidu. All rights reserved.
//

#import "FaceViewController+FaceCollect.h"
#import "FaceViewController+MainSteps.h"
#import "BDIDInfoCollectController.h"
#import "BDIDInfoAutoCollectController.h"
#import <BDFaceBaseKit/BDFaceBaseKit.h>
#import "BDConfigDataService.h"
#import "BDFaceAdjustParamsTool.h"
#import <BDFaceLogicLayer/BDFaceLogicLayer.h>
#import "BDFaceVerificationController.h"

@implementation FaceViewController (FaceCollect)


- (void)startFaceCollect {
    NSDictionary *tokenDic = @{BDFaceLogicServiceTokenKey : self.accessToken ?: @""};
    __weak typeof(self) this = self;
    self.logicService.showLoadingAction = ^(void) {
//        [this showCheckLiveLoadingAction];
    };
    [self.logicService startFaceCollect:^(int resultCode, NSDictionary * _Nonnull resultDic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 0 表示成功
            if (resultCode == 0) {
                NSDictionary *responseDic = resultDic[@"data"];
                
                [self faceCheckEvent:resultDic];
//                [this showCheckLiveRequestSuccessResult:responseDic];
            } else {
                NSString *errorMessage = resultDic[BDFaceLogicServiceReturnKeyForResultMsg];
//                [self showCheckLiveFailResult:errorMessage];
            }
            
        });
    }];
}

-(void)faceCheckEvent:(NSDictionary*)dataDict{}

@end

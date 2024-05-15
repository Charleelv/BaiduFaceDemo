//
//  ViewController+LiveCheck.m
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/10/25.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "FaceViewController+LiveCheck.h"
#import "FaceViewController+MainSteps.h"
#import "BDIDInfoCollectController.h"
#import "BDIDInfoAutoCollectController.h"
#import <BDFaceBaseKit/BDFaceBaseKit.h>
#import "BDConfigDataService.h"
#import "BDFaceAdjustParamsTool.h"
#import <BDFaceLogicLayer/BDFaceLogicLayer.h>
#import "BDFaceVerificationController.h"


@implementation FaceViewController (LiveCheck)

- (void)startLiveCheck {
    NSDictionary *tokenDic = @{BDFaceLogicServiceTokenKey : self.accessToken ?: @""};
    __weak typeof(self) this = self;
    self.logicService.showLoadingAction = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [this showCheckLiveLoadingAction];
        });
    };
    //设置默认人脸参数
    [self.logicService startRecognizeToCheckLive:tokenDic callBack:^(int resultCode, NSDictionary * _Nonnull resultDic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 0 表示成功
            if (resultCode == 0) {
                NSDictionary *responseDic = resultDic[@"data"];
                [this showCheckLiveRequestSuccessResult:responseDic];
            } else {
                NSString *errorMessage = resultDic[BDFaceLogicServiceReturnKeyForResultMsg];
                [self showCheckLiveFailResult:errorMessage];
            }
            
        });
    }];
}

- (void)showCheckLiveLoadingAction {
    BDFaceVerificationController *avc = [[BDFaceVerificationController alloc] init];
    [self.navigationController pushViewController:avc animated:YES];
}

/**
 * 下面的decode_image是最终解密的照片
 */
- (void)showCheckLiveRequestSuccessResult:(NSDictionary *)responseDic {
        BDFaceVerificationController *verificationController = (BDFaceVerificationController *)self.navigationController.topViewController;
        NSDictionary *errorDic = responseDic[@"error_code"];
        int riskLevel = [responseDic[@"risk_level"] intValue];
        if (errorDic == nil) {
            NSString *base64Image = nil;
            NSArray *base64ImageArray = [responseDic objectForKey:@"dec_image"];
            if ([base64ImageArray isKindOfClass:[NSArray class]]) {
                NSArray *tempArray = (NSArray *)base64ImageArray;
                if (tempArray.count > 0) {
                    base64Image = tempArray[0];
                }
            }
            if (base64Image) {
                NSData* data = [[NSData alloc] initWithBase64EncodedString:base64Image options:NSDataBase64DecodingIgnoreUnknownCharacters];
                /// 这个是解密出来的最终的识别的图片
                UIImage *decode_image = [UIImage imageWithData:data];
                
            }
            if ([responseDic[@"result"][@"face_liveness"] floatValue] > [BDConfigDataService onlineVerifyLocalCheckThreadHold]) {
                if (riskLevel == 1 || riskLevel == 2) {
                    [verificationController showBDFaceLiveFail:@""];
                } else {
                    [verificationController showBDFaceSuccess];
                }
            } else {
                // 分数过低的时候，点击重新采集，可以执行重新采集行为
                [verificationController showBDFaceLiveFail:@"在线验证失败，分数过低"];
            }
        }else {
//            int code = [responseDic[@"error_code"] intValue];
//            BDFaceVerificationController *vc = (BDFaceVerificationController *)self.navigationController.topViewController;
//            [vc showServerError:code riskLevel:riskLevel];
        }
}


- (void)showCheckLiveFailResult:(NSString *)errorMessage {
    UIViewController *baseController = self.navigationController.viewControllers[0];
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [BDFaceToastView showToast:baseController.view text:errorMessage];
    });
}


@end

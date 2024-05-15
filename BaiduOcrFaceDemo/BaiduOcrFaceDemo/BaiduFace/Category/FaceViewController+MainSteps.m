//
//  ViewController+MainSteps.m
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/10/17.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "FaceViewController+MainSteps.h"
#import "BDIDInfoCollectController.h"
#import "BDIDInfoAutoCollectController.h"
#import <BDFaceBaseKit/BDFaceBaseKit.h>
#import "BDConfigDataService.h"
#import "BDFaceAdjustParamsTool.h"
#import "FaceParameterConfig.h"
#import <BDFaceLogicLayer/BDFaceLogicLayer.h>
#import "BDFaceVerificationController.h"
#import "config.h"

/** 为什么获取token的代码不能放到客户端，原因，放到客户端是可以的，但是如果放到客户端，会有安全风险，因此，建议用户将API_KEY，SECRET_KEY 等信息放到服务端，在您的服务端做一层转发，请求到之后，将数据还抛回来即可。
 */
static NSString *BDTokenGetRequestUrl = @"http://10.138.55.237:8765/";


/// 超时时间设置
static NSUInteger BDFaceRequestTokenMaxTime = 60;



@implementation FaceViewController (Main_process)

//- (void)getAccessToken {
//    __weak typeof(self) this = self;
//    NSURL *url = [NSURL URLWithString:BDTokenGetRequestUrl];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:BDFaceRequestTokenMaxTime];
//    [request setHTTPMethod:@"GET"];
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    configuration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
//    configuration.timeoutIntervalForRequest = BDFaceRequestTokenMaxTime;
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (data) {
//            NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData: data
//                                                                          options: NSJSONReadingMutableContainers
//                                                                            error: &error];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSString *tokenString = responseDic[@"access_token"];
//                this.accessToken = tokenString;
//            });
//            
//            NSLog(@"%@", responseDic);
//        }
//    }];
//    [task resume];
//    
//#warning developer 用户需要替换上面的变量 BDTokenGetRequestUrl，具体Url是什么，可以参考注释。 如果只是想调试，可以将token写死，如下面所示：设置self.accessToken=@"",如何获取token, 参考：https://ai.baidu.com/ai-doc/REFERENCE/Ck3dwjhhu
/////  如下代码，只是调试，正式代码需要从url中及时获取，需要再每次进行人脸实名认证的时候，即时获取。
////    self.accessToken = @"24.971426380c6b47a4e9021b02b4fe3c62.2592000.1715775792.282335-61575600";
//}

/**
 初始化人脸和OCR SDK
 */
- (void)initFaceServiceAndInfoCollectService {
    __weak typeof(self) this = self;
    /// 初始化 人脸识别Service
    self.logicService = [[BDFaceLogicService alloc] initWithController:self face:^{
        [this initFaceSDK];
    } ocr:^{
//        [this initOcrSDK];
    }];
}

/*
 初始化人脸SDK
 */
- (void)initFaceSDK {
    BDFaceBaseKitLivenessTipCustomConfigItem *tipCustomConfigItem = [[BDFaceBaseKitLivenessTipCustomConfigItem alloc] initWithLivenessTipConfig];
    [[BDFaceBaseKitManager sharedInstance] setFaceSdkCustomLivenessTipConfig:tipCustomConfigItem];
    //设置默认人脸参数
    BDFaceBaseKitParamsCustomConfigItem *paramsCustomConfigItem = [[BDFaceBaseKitParamsCustomConfigItem alloc] initWithParamsConfig];
    [[BDFaceBaseKitManager sharedInstance] setParamsCustomConfigItem:paramsCustomConfigItem];
    //设置默认UI参数
    BDFaceBaseKitUICustomConfigItem *uiCustomConfigItem = [[BDFaceBaseKitUICustomConfigItem alloc] initWithUIConfig];
    [[BDFaceBaseKitManager sharedInstance] setUiCustomConfigItem:uiCustomConfigItem];
    /// 采集SDK只回调结果，不显示后续页面UI
    [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.isIntoResultView = NO;
    paramsCustomConfigItem.actionLiveSelectNum = 2;
    paramsCustomConfigItem.outputImageType = 1;
    // 打开提示音
    [SSFaceProcessManager sharedInstance].enableSound = YES;
    // 设置本地活体阀值
    [FaceSDKManager sharedInstance].livenessThresholdValue = [BDConfigDataService livenessVerifyThreadHold];
    [FaceSDKManager sharedInstance].colorLiveThresholdValue = [BDConfigDataService livenessVerifyThreadHold];
    /// 设置licence_id 和license_name
    [[BDFaceBaseKitManager sharedInstance] initCollectWithLicenseID:FACE_LICENSE_ID andLocalLicenceName:FACE_LICENSE_NAME andExtradata:@{} callback:^(BDFaceInitRemindCode code, NSDictionary *extradata) {
        NSLog(@"人脸初始化结果：%ld", (long)code);
    }];
    // 设置图像阀值
    [BDFaceAdjustParamsTool changeConfig:[BDConfigDataService faceImageParams]];
}

/**
 * 设置随机动作数量
 */
- (void)setRandomAction:(BDFaceLiveSelectType)mode num:(int)number config:(BDFaceBaseKitParamsCustomConfigItem *)config{
    if (mode != BDFaceLivenessType) {
        return;
    }

    NSArray *actionArray = [BDConfigDataService actionArray];

    config.randomActionLiveActionArray = [NSMutableArray arrayWithArray:actionArray];
    config.numOfLiveness = 8;
//    config.colorSelectMode = number;
}


/*
 OCR SDK初始化
 */
- (void)initOcrSDK {
//    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:FACE_API_ORC_KEY ofType:FACE_SECRET_OCR_KEY];
//    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
//    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
//    NSLog(@"ocr sd version: %@", [AipOcrService ocrSdkVersion]);
}

- (void)checkFaceAction:(NSMutableDictionary *)parameters {
    __weak typeof(self) this = self;
    [self startCheckFace:parameters response:^(int code, NSDictionary *callBack) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 0 表示成功
            if (code == 0) {
                NSDictionary *responseDic = callBack[BDFaceLogicServiceReturnKeyForResultData];
                [this showRequestSuccessResult:responseDic];
            } else {
                NSString *errorMessage = callBack[BDFaceLogicServiceReturnKeyForResultMsg];
                [this showMainStepFailResult:errorMessage];
            }
            
        });
    }];
}

- (void)startCheck {
    NSDictionary *tokenDic = @{BDFaceLogicServiceTokenKey : self.accessToken ?: @""};
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:tokenDic];
    {
        /// 这两个值，可以不传递
        tempDict[BDFaceLogicServiceOnlineQualityControlKey] = [BDConfigDataService onlineImageQuality] ?: @"";
        tempDict[BDFaceLogicServiceLivenessQualityControlKey] = [BDConfigDataService onlineLivenessQuality] ?: @"";;
    }
    __weak typeof(self) this = self;
    self.logicService.showLoadingAction = ^(void) {
        [this showLoadingAction];
    };
    
    /// useOCR = 2 使用代码传入姓名和身份证的方式来，传入参数，直接打开采集页面，不适用OCR部分代码来采集身份证信息
    if ([BDConfigDataService useOCR] == 2) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:tempDict];
#warning developer 这里需要传入真实的姓名和身份证号，最后才能检测成功
        // 用户姓名
        NSString *userName = @"";
        // 用户身份证号
        NSString *userIdCarNumber = @"";
        /// 姓名，证件号（身份证号）和token是必传参数
        parameters[BDFaceLogicServiceNameKey]  = userName ?: @"";
        parameters[BDFaceLogicServiceCardNumberKey]  = userIdCarNumber ?: @"";
        parameters[BDFaceLogicServiceTokenKey] = @"";
        [self checkFaceAction:parameters];
    } else {
        [BDCardInfoService showCardCollectPage:self finish:^(NSDictionary * _Nonnull personInfoDic) {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:personInfoDic];
            NSString *planId = [BDConfigDataService planId];
            parameters[BDFaceLogicServicePlanIdKey] = planId ?: @"";
            [parameters addEntriesFromDictionary:tempDict];
            [this checkFaceAction:parameters];
        }];
    }
}

- (void)startCheckFace:(NSDictionary *)dic response:(void(^)(int code, NSDictionary *callBack))response {
    
    NSString *name = dic[BDIDInfoCollectControllerNameKey];
    NSString *cardNumber = dic[BDIDInfoCollectControllerIdNumberKey]; // dic[BDIDInfoCollectControllerIdNumberKey];
    NSNumber *cardType = dic[BDIDInfoCollectControllerCarTypeKey];
    NSString *tokenString = dic[BDFaceLogicServiceTokenKey];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    {
        // 删除从OCR传递过来的，保留其他值。
        [parameters removeObjectForKey:BDIDInfoCollectControllerNameKey];
        [parameters removeObjectForKey:BDIDInfoCollectControllerIdNumberKey];
        [parameters removeObjectForKey:BDIDInfoCollectControllerCarTypeKey];
        [parameters removeObjectForKey:BDFaceLogicServiceTokenKey];
    }
    parameters[BDFaceLogicServiceNameKey] = name ?: @"";
    parameters[BDFaceLogicServiceCardNumberKey] = cardNumber ?: @"";
    parameters[BDFaceLogicServiceTokenKey] = tokenString ?: @"";
    // 默认身份证识别
    parameters[BDFaceLogicServiceCardTypeKey] = cardType ?: @(0);
    
    [self.logicService startRecognize:parameters callBack:^(int resultCode, NSDictionary * _Nonnull resultDic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response) {
                response(resultCode, resultDic);
            }
        });
    }];
}

- (void)showLoadingAction {
    BDFaceVerificationController *avc = [[BDFaceVerificationController alloc] init];
    [self.navigationController pushViewController:avc animated:YES];
}

/**
 * 下面的decode_image是最终解密的照片
 */
- (void)showRequestSuccessResult:(NSDictionary *)responseDic {
        BDFaceVerificationController *verificationController = (BDFaceVerificationController *)self.navigationController.topViewController;
        NSDictionary *errorDic = responseDic[@"error_code"];
        int riskLevel = [responseDic[@"risk_level"] intValue];
        if (errorDic == nil) {
            NSString *base64Image = [responseDic objectForKey:@"dec_image"];
            if (base64Image) {
                NSData* data = [[NSData alloc] initWithBase64EncodedString:base64Image options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIImage *decode_image = [UIImage imageWithData:data];
                
            }
            if (responseDic[@"result"][@"verify_status"]) {
               
                if ([responseDic[@"result"][@"verify_status"] intValue] == 1) {
                    [verificationController showBDFaceFail];
                } else if ([responseDic[@"result"][@"verify_status"] intValue] == 2) {
                    [verificationController showBDFaceFailGongan];
                } else {
                    // 如果在线活体分数大于 最低的本地传的分数，那么通过
                    if ([responseDic[@"result"][@"score"] floatValue] > [BDConfigDataService riskScore]) {
                        if (riskLevel == 1 || riskLevel == 2) {
                            NSString *msg = [NSString stringWithFormat:@"risk_tag : %@",responseDic[@"risk_tag"][0]];
                            [verificationController showBDFaceLiveFail: @""];
                        } else {
                            [verificationController showBDFaceSuccess];
                        }
                    } else {
                        // 分数过低的时候，点击重新采集，可以执行重新采集行为
                        [verificationController showBDFaceLiveFail:@"在线验证失败，分数过低"];
                    }
                }
            }
        } else {
            int code = [responseDic[@"error_code"] intValue];
            BDFaceVerificationController *vc = (BDFaceVerificationController *)self.navigationController.topViewController;
            [vc showServerError:code riskLevel:riskLevel];
        }
}

- (void)showMainStepFailResult:(NSString *)errorMessage {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果topController是人脸检测loading界面，那么先退出
        if ([self.navigationController.topViewController isKindOfClass: BDFaceVerificationController.class]) {
            [self.navigationController popViewControllerAnimated:NO];
        }
        UIViewController *baseController = self.navigationController.topViewController;
        [BDFaceToastView showToast:baseController.view text:errorMessage];
    });
}


@end

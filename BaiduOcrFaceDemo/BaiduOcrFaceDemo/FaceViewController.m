//
//  FaceViewController.m
//  BaiduOcrFaceDemo
//
//  Created by CharlieLv on 2024/5/14.
//

#import "FaceViewController.h"
#import "BDFaceAgreementViewController.h"
#import "BDFaceLogoView.h"
#import <objc/runtime.h>
#import "JSToastDialogs.h"
#import "BDFacePoorNetworkController.h"
#import "BDFaceVerificationFailController.h"
#import "BDUIConstant.h"
#import "BDFaceVerificationConstant.h"
#import "BDConfigDataService.h"
#import "BDIDInfoAutoCollectController.h"
#import "BDIDInfoCollectController.h"
#import "FaceViewController+MainSteps.h"
#import "FaceViewController+LiveCheck.h"
#import "config.h"

#define WIDTH            ([[UIScreen mainScreen] bounds].size.width)
#define HEIGHT          ([[UIScreen mainScreen] bounds].size.height)

@interface FaceViewController ()

@end

@implementation FaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"人脸检测";
    
    [self createUI];
    [self initFaceServiceAndInfoCollectService];
}

-(void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(20, HEIGHT-100, WIDTH-40, 48);
    [startBtn setTitle:@"开始拍摄" forState:UIControlStateNormal];
    startBtn.layer.backgroundColor = [UIColor purpleColor].CGColor;
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    startBtn.layer.cornerRadius = 24;
    [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
}


-(void)startBtnClick{
    [BDFaceVerificationConstant sharedInstance].verifyType = BDFaceVerificationIdCardAndImageVerification;
    
    // 开始活体检测
    [self startFaceCollectEvent];
}

- (void)startFaceCollectEvent{
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
                [self faceCheckAuthEvent:resultDic];
            } else {
                NSString *errorMessage = resultDic[BDFaceLogicServiceReturnKeyForResultMsg];
//                [self showCheckLiveFailResult:errorMessage];
            }
            
        });
    }];
}

-(void)faceCheckAuthEvent:(NSDictionary*)dataDict{
    __block typeof(self) weakSelf = self;
    
    NSString *jsonString = dataDict[@"data"];

    NSError *error = nil;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSNumber * deviceID = dataDict[@"x-device-id"];
    NSString * deIDStr = [NSString stringWithFormat:@"%@",deviceID];
    
    NSDictionary * paramDict =  @{
                  @"custName":@"name",
                  @"idNo":@"idCardNum",
                  @"imageType":@"BASE64",
                  @"authorId":@"xxxx_face_verify",
                  @"qualityControl":@"NORMAL",
                  @"livenessControl":@"NORMAL",
                  @"spoofingControl":@"NORMAL",
                  @"getSpoofingScore":@"1",
                  @"getLivenessScore":@"1",
                  @"secLevel":@"lite",
                  @"did":deIDStr,
                  @"data":jsonDictionary[@"data"],
                  @"skey":dataDict[@"skey"],
                  @"app":@"ios"};
    
    //
    //[传后端校验]
}

@end

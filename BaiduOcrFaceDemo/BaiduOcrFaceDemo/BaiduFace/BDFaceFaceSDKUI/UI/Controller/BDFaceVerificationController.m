//
//  BDFaceVerificationController.m
//  IDLFaceSDKDemoOC
//
//  Created by v_shishuaifeng on 2020/8/27.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDFaceVerificationController.h"
#import "AppDelegate.h"
#import "BDFaceVerificationSuccessController.h"
#import "BDFaceVerificationFailController.h"
#import "BDFacePoorNetworkController.h"


#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface BDFaceVerificationController ()
@property double angle;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation BDFaceVerificationController {
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
    
}
-(void)viewDidLoad {
    [super viewDidLoad];
    if(@available(ios 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    self.view.backgroundColor = UIColor.whiteColor;
    // title bar
    [self statusBarView];
    // underVerification
    [self underVerificationView];
}

-(void) statusBarView {
    UILabel *titleView = [[UILabel alloc] init];
    if (IS_IPhoneXSeries) {
        titleView.frame = CGRectMake(0, 39.5, ScreenWidth, 44);
    } else {
        titleView.frame = CGRectMake(0, 19.5, ScreenWidth, 44);
    }
    titleView.backgroundColor =  [UIColor colorWithRed:253/255.0 green:253/255.0 blue:254/255.0 alpha:1/1.0];
    [self.view addSubview:titleView];
    
    UILabel *titeLabel = [[UILabel alloc] init];
    if (IS_IPhoneXSeries) {
        titeLabel.frame = CGRectMake(0, 49.5, ScreenWidth, 24);
    } else {
        titeLabel.frame = CGRectMake(0, 29.5, ScreenWidth, 24);
    }
    titeLabel.text = @"人脸身份核验";
    titeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:19];
    titeLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    titeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titeLabel];
    
    UIView *view = [[UIView alloc] init];
    if (IS_IPhoneXSeries) {
        view.frame = CGRectMake(0, 83.5, ScreenWidth, 0.5);
    } else {
        view.frame = CGRectMake(0, 63.5, ScreenWidth, 0.5);
    }
    view.backgroundColor = [UIColor colorWithRed:232/255.0 green:233/255.0 blue:235/255.0 alpha:1/1.0];
    [self.view addSubview:view];
}

// 核验显示页面
-(void) underVerificationView {
    _imageView = [[UIImageView alloc] init];
    if (IS_IPhoneXSeries) {
        _imageView.frame = CGRectMake(ScreenWidth / 2 - 40, 170, 80, 80);
    } else {
        _imageView.frame = CGRectMake(ScreenWidth / 2 - 40, 150, 80, 80);
    }
    
    _imageView.image = [UIImage imageNamed:@"loading.png"];
    [self.view addSubview:_imageView];

    //添加旋转动画
    CABasicAnimation *rotationAnimate;
    rotationAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimate.toValue = [NSNumber numberWithFloat:M_PI];
    rotationAnimate.duration = 1;
    rotationAnimate.cumulative = YES;
    rotationAnimate.removedOnCompletion = NO;
    rotationAnimate.repeatCount = MAXFLOAT;
    [self.imageView.layer addAnimation:rotationAnimate forKey:@"rotationAnimation"];
    
    UILabel *label = [[UILabel alloc] init];
    if (IS_IPhoneXSeries) {
        label.frame = CGRectMake(ScreenWidth / 2 - 41, 280, 81.5, 14);
    } else {
        label.frame = CGRectMake(ScreenWidth / 2 - 41, 260, 81.5, 14);
    }
    
    label.text = @"身份核验中...";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self.view addSubview:label];
    
}


- (void)showServerError:(int)code riskLevel:(int)riskLevel {
    if (code == 222350 || code == 222355) {
        [self showBDFaceFailGongan];
    } else if (code == 223120) {
        [self showBDFaceLiveFail:nil];
    } else if (code == 222361 || code == 282105) {
        [self showBDFaceNetWork];
    } else if (code == 222356) {
        [self BDFaceQualityFail];
    } else if (code == 222351 || code == 222354 || code == 222360) {
        [self showBDFaceFail];
    } else if (riskLevel == 1) {
        [self showBDFaceLiveFail:nil];
    } else {
        [self ParameterException];
    }
}

// 身份核验成功页面
- (void)showBDFaceSuccess {
    BDFaceVerificationSuccessController * successController = [[BDFaceVerificationSuccessController alloc] init];
    [self presentedViewControllerCustomized:successController complete:nil];
}

// 身份核验失败页面（活体检测失败）
- (void)showBDFaceLiveFail:(NSString *)message {
    BDFaceVerificationFailController * failController = [[BDFaceVerificationFailController alloc] init];
    failController.nameText = message;
    [self presentedViewControllerCustomized:failController complete:nil];
}

// 身份核验失败页面（核验失败）
-(void)showBDFaceFail {
    BDFaceVerificationFailController * failController = [[BDFaceVerificationFailController alloc] init];
    [self presentedViewControllerCustomized:failController complete:nil];
}

// 身份核验失败页面（质量检测失败）
-(void) BDFaceQualityFail {
    BDFaceVerificationFailController * failController = [[BDFaceVerificationFailController alloc] init];
    failController.name = @"未检测到人脸";
    failController.nameText = @"请确保正脸采集且清晰完整";
    [self presentedViewControllerCustomized:failController complete:nil];
}

// 无网络页面
- (void)showBDFaceNetWork {
    if ([self.presentedViewController.class isMemberOfClass:self.class]) {
        return;
    }
    BDFacePoorNetworkController * poorNetworkController = [[BDFacePoorNetworkController alloc] init];
    [self presentedViewControllerCustomized:poorNetworkController complete:nil];
}

// 身份核验失败页面（公安网身份信息 覆盖不全）
-(void)showBDFaceFailGongan {
    BDFaceVerificationFailController * failController = [[BDFaceVerificationFailController alloc] init];
    failController.btnText = @"关闭";
    failController.name = @"公安网图片不存在或质量低";
    failController.nameText = @"请到派出所更新身份证图片";
    failController.showRetry = NO;
    [self presentedViewControllerCustomized:failController complete:nil];
}

// 参数异常页面
-(void) ParameterException {
    BDFaceVerificationFailController * failController = [[BDFaceVerificationFailController alloc] init];
    failController.iconImage = [UIImage imageNamed:@"icon_parameter"];
    failController.btnText = @"关闭";
    failController.name = @"参数格式错误";
    failController.nameText = @"请参考API说明文档，修改参数";
    [self presentedViewControllerCustomized:failController complete:nil];
}

- (void)presentedViewControllerCustomized:(UIViewController *)controller complete:(void (^ __nullable)(void))completion
{
    UINavigationController *navi = self.navigationController;
    [navi popViewControllerAnimated:NO];
    [navi pushViewController:controller animated:NO];
}


@end


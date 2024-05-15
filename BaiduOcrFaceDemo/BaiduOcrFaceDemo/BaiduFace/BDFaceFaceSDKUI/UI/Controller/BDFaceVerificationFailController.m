//
//  BDFaceVerificationFailController.m
//  IDLFaceSDKDemoOC
//
//  Created by v_shishuaifeng on 2020/8/27.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDFaceVerificationFailController.h"
#import "BDFaceLogoView.h"
#import "BDFaceVerificationController.h"
#import <BDFaceBaseKit/BDFaceBaseKit.h>
#import "FaceViewController.h"
#import "BDUIConstant.h"
#import "UIViewController+BDPresentingAnimation.h"
#import "FaceViewController+MainSteps.h"
#import "BDIDInfoAutoCollectController.h"
#import "BDIDInfoCollectController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation BDFaceVerificationFailController {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        /// 默认显示重新采集按钮，只有在公安网图片不存在或者质量低的时候不显示重试按钮
        self.showRetry = YES;
    }
    return self;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF0F1F2);
    // title bar
    // 底部logo部分
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 221, ScreenWidth, 221);
    logoImageView.image = [UIImage imageNamed:@"image_guide_bottom"];
    [self.view addSubview:logoImageView];
    // 设置logo，底部的位置和大小，实例化显示
    BDFaceLogoView* logoView = [[BDFaceLogoView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-15-12), ScreenWidth, 12)];
    [self.view addSubview:logoView];
    
    [self statusBarView];
    [self verificationStatusView];
    [self verificationStatusBtnView];
}

-(void) statusBarView {
    UILabel *titleView = [[UILabel alloc] init];
    if (IS_IPhoneXSeries) {
        titleView.frame = CGRectMake(0, 39.5, ScreenWidth, 44);
    } else {
        titleView.frame = CGRectMake(0, 19.5, ScreenWidth, 44);
    }
    titleView.backgroundColor =  [UIColor clearColor];
    [self.view addSubview:titleView];
    
    UILabel *titeLabel = [[UILabel alloc] init];
    if (IS_IPhoneXSeries) {
        titeLabel.frame = CGRectMake(0, 49.5, ScreenWidth, 24);
    } else {
        titeLabel.frame = CGRectMake(0, 29.5, ScreenWidth, 24);
    }
    
    if (_titleText != nil) {
        titeLabel.text = _titleText;
    } else {
        titeLabel.text = @"人脸身份核验";
        
    }
    titeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:19];
    titeLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    titeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titeLabel];

}

-(void) verificationStatusView {
    // networkStatus image
    UIImageView *imageView = [[UIImageView alloc] init];
    if (IS_IPhoneXSeries) {
        imageView.frame = CGRectMake(ScreenWidth / 2 - 40, KScaleY(170), 80, 80);
    } else {
        imageView.frame = CGRectMake(ScreenWidth / 2 - 40, KScaleY(150), 80, 80);
    }
    
    if (_iconImage != nil){
        imageView.image = _iconImage;
    } else {
        imageView.image = [UIImage imageNamed:@"icon_fail.png"];
    }
    [self.view addSubview:imageView];
    
    // networkStatus text
    UILabel *networkStatusText = [[UILabel alloc] init];
    if (IS_IPhoneXSeries) {
        networkStatusText.frame = CGRectMake(0, KScaleY(281), ScreenWidth, 20);
    } else {
        networkStatusText.frame = CGRectMake(0, KScaleY(260), ScreenWidth, 20);
    }
    
    if (_name != nil) {
        networkStatusText.text = _name;
    } else {
        networkStatusText.text = @"身份核验失败";
        
    }
    networkStatusText.textAlignment = NSTextAlignmentCenter;
    networkStatusText.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    networkStatusText.textColor = UIColorFromRGB(0x171D24);
    [self.view addSubview:networkStatusText];
    
    // networkStatus text tips
    UILabel *networkStatusTextTips = [[UILabel alloc] init];
    if (IS_IPhoneXSeries) {
        networkStatusTextTips.frame = CGRectMake(0, KScaleY(313), ScreenWidth, 14);
    } else {
        networkStatusTextTips.frame = CGRectMake(0, KScaleY(293), ScreenWidth, 14);
    }
    
    if (_nameText != nil) {
        networkStatusTextTips.text = _nameText;
    } else {
        networkStatusTextTips.text = @"请重新尝试";
        
    }
    
    networkStatusTextTips.textAlignment = NSTextAlignmentCenter;
    networkStatusTextTips.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    networkStatusTextTips.textColor = UIColorFromRGB(0x77787A);
    [self.view addSubview:networkStatusTextTips];
    
}

-(void) verificationStatusBtnView {
    // networkStatus restart
    {
        UIButton *networkStatusRestartBtn  = [[UIButton alloc] init];
        if (IS_IPhoneXSeries) {
            networkStatusRestartBtn.frame = CGRectMake(ScreenWidth/2-130, KScaleY(499), 260, 52);
        } else {
            networkStatusRestartBtn.frame = CGRectMake(ScreenWidth/2-130, KScaleY(479), 260, 52);
        }
        
        [networkStatusRestartBtn setBackgroundColor:UIColorFromRGB(0x0080FF)];
        networkStatusRestartBtn.layer.cornerRadius = 26;
        networkStatusRestartBtn.layer.masksToBounds = YES;
        UILabel *networkStatusRestartBtnLabel = [[UILabel alloc] init];
        if (IS_IPhoneXSeries) {
            networkStatusRestartBtnLabel.frame = CGRectMake(0, KScaleY(513), ScreenWidth, 18);
        } else {
            networkStatusRestartBtnLabel.frame = CGRectMake(0, KScaleY(493), ScreenWidth, 18);
        }
        
        networkStatusRestartBtnLabel.text = @"重试";
        networkStatusRestartBtnLabel.textAlignment = NSTextAlignmentCenter;
        networkStatusRestartBtnLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        networkStatusRestartBtnLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:networkStatusRestartBtn];
        [self.view addSubview:networkStatusRestartBtnLabel];
        [networkStatusRestartBtn addTarget:self action:@selector(reRecognizeAgain) forControlEvents:UIControlEventTouchUpInside];
        if (!self.showRetry) {
            networkStatusRestartBtn.enabled = false;
            networkStatusRestartBtn.hidden = true;
            networkStatusRestartBtnLabel.hidden = true;
        }
    }
    // networkStatus exit
    // 退出核验的button
    
    UIButton * networkStatusExitBtn  = [[UIButton alloc] init];
    if (IS_IPhoneXSeries) {
        networkStatusExitBtn.frame = CGRectMake(ScreenWidth/2-130, KScaleY(563), 260, 52);
    } else {
        networkStatusExitBtn.frame = CGRectMake(ScreenWidth/2-130, KScaleY(543), 260, 52);
    }
    [networkStatusExitBtn setBackgroundColor:UIColorFromRGB(0xD9DFE6)];
    networkStatusExitBtn.layer.cornerRadius = 26;
    networkStatusExitBtn.layer.masksToBounds = YES;
    // 退出核验的label
    UILabel * networkStatusExitBtnLabel = [[UILabel alloc] init];
    if (IS_IPhoneXSeries) {
        networkStatusExitBtnLabel.frame = CGRectMake(0, KScaleY(577), ScreenWidth, 18);
    } else {
        networkStatusExitBtnLabel.frame = CGRectMake(0, KScaleY(557), ScreenWidth, 18);
    }
    
    if (_btnText != nil) {
        networkStatusExitBtnLabel.text = _btnText;
    } else {
        networkStatusExitBtnLabel.text = @"关闭";
    }
    networkStatusExitBtnLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    networkStatusExitBtnLabel.textAlignment = NSTextAlignmentCenter;
    networkStatusExitBtnLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    [self.view addSubview:networkStatusExitBtn];
    [self.view addSubview:networkStatusExitBtnLabel];
    [networkStatusExitBtn addTarget:self action:@selector(exitVerificationBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction) exitVerificationBtn: (UIButton *) sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)reRecognizeAgain {
    UINavigationController *navi = self.navigationController;
    [navi popViewControllerAnimated:YES];
}


@end

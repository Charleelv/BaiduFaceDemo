//
//  BDFacePoorNetworkController.m
//  IDLFaceSDKDemoOC
//
//  Created by v_shishuaifeng on 2020/8/27.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDFacePoorNetworkController.h"
#import "BDFaceLogoView.h"
#import "BDFaceVerificationController.h"
#import "FaceViewController.h"
#import "BDUIConstant.h"
#import "Reachability.h"
#import "FaceViewController+MainSteps.h"
#import "BDIDInfoAutoCollectController.h"
#import "BDIDInfoCollectController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface BDFacePoorNetworkController ()
@end

@implementation BDFacePoorNetworkController {
    
}

-(void) viewDidLoad {
    [super viewDidLoad];
    // 设置背景颜色
    self.view.backgroundColor = UIColorFromRGB(0xF0F1F2);

    // 底部logo部分
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 221, ScreenWidth, 221);
    logoImageView.image = [UIImage imageNamed:@"image_guide_bottom"];
    [self.view addSubview:logoImageView];
    // 设置logo，底部的位置和大小，实例化显示
    BDFaceLogoView* logoView = [[BDFaceLogoView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-15-12), ScreenWidth, 12)];
    [self.view addSubview:logoView];
    
    [self statusBarView];
    [self networkStatusView];
    [self networkStatusBtnView];
}

-(void) statusBarView {
    UILabel *titleView = [[UIView alloc] init];
    if (IS_IPhoneXSeries) {
        titleView.frame = CGRectMake(0, 39.5, ScreenWidth, 44);
    } else {
        titleView.frame = CGRectMake(0, 19.5, ScreenWidth, 44);
    }
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
    
}

-(void) networkStatusView {
    // networkStatus image
    UIImageView *imageView = [[UIImageView alloc] init];
    if (IS_IPhoneXSeries) {
        imageView.frame = CGRectMake(ScreenWidth / 2 - 44, KScaleY(189), 88, 88);
    } else {
        imageView.frame = CGRectMake(ScreenWidth / 2 - 44, KScaleY(169), 88, 88);
    }
    imageView.image = [UIImage imageNamed:@"icon_network.png"];
    [self.view addSubview:imageView];
    
    // networkStatus text
    UILabel *networkStatusText = [[UILabel alloc] init];
    if (IS_IPhoneXSeries) {
        networkStatusText.frame = CGRectMake(0, KScaleY(280), ScreenWidth, 20);
    } else {
        networkStatusText.frame = CGRectMake(0, KScaleY(260), ScreenWidth, 20);
    }
    networkStatusText.text = @"网络连接失败";
    networkStatusText.textAlignment = NSTextAlignmentCenter;
    networkStatusText.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    networkStatusText.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1/1.0];
    [self.view addSubview:networkStatusText];
    
    // networkStatus text tips
    UILabel *networkStatusTextTips = [[UILabel alloc] init];
    if (IS_IPhoneXSeries) {
        networkStatusTextTips.frame = CGRectMake(0, KScaleY(312), ScreenWidth, 14);
    } else {
        networkStatusTextTips.frame = CGRectMake(0, KScaleY(292), ScreenWidth, 14);
    }
    networkStatusTextTips.text = @"请检查网络";
    networkStatusTextTips.textAlignment = NSTextAlignmentCenter;
    networkStatusTextTips.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    networkStatusTextTips.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self.view addSubview:networkStatusTextTips];
    
}

-(void) networkStatusBtnView {
    // networkStatus restart
    UIButton *networkStatusRestartBtn  = [[UIButton alloc] init];
    if (IS_IPhoneXSeries) {
        networkStatusRestartBtn.frame = CGRectMake(ScreenWidth/2-130, KScaleY(499), 260, 52);
    } else {
        networkStatusRestartBtn.frame = CGRectMake(ScreenWidth/2-130, KScaleY(479), 260, 52);
    }
    [networkStatusRestartBtn setBackgroundColor:KColorFromRGB(0x0080FF)];
    networkStatusRestartBtn.layer.cornerRadius = 26;
    networkStatusRestartBtn.layer.masksToBounds = YES;
    UILabel *networkStatusRestartBtnLabel = [[UILabel alloc] init];
    if (IS_IPhoneXSeries) {
        networkStatusRestartBtnLabel.frame = CGRectMake(0, KScaleY(514), ScreenWidth, 18);
    } else {
        networkStatusRestartBtnLabel.frame = CGRectMake(0, KScaleY(494), ScreenWidth, 18);
    }
    networkStatusRestartBtnLabel.text = @"重试";
    networkStatusRestartBtnLabel.textAlignment = NSTextAlignmentCenter;
    networkStatusRestartBtnLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    networkStatusRestartBtnLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1 / 1.0];
    [self.view addSubview:networkStatusRestartBtn];
    [self.view addSubview:networkStatusRestartBtnLabel];
    [networkStatusRestartBtn addTarget:self action:@selector(restartLoadBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // networkStatus exit
    // 退出核验的button
    UIButton * networkStatusExitBtn  = [[UIButton alloc] init];
    if (IS_IPhoneXSeries) {
        networkStatusExitBtn.frame = CGRectMake(ScreenWidth/2-130, KScaleY(563), 260, 52);
    } else {
        networkStatusExitBtn.frame = CGRectMake(ScreenWidth/2-130, KScaleY(543), 260, 52);
    }
    [networkStatusExitBtn setBackgroundColor:KColorFromRGB(0xD9DFE6)];
    networkStatusExitBtn.layer.cornerRadius = 26;
    networkStatusExitBtn.layer.masksToBounds = YES;
    // 退出核验的label
    UILabel * networkStatusExitBtnLabel = [[UILabel alloc] init];
    if (IS_IPhoneXSeries) {
        networkStatusExitBtnLabel.frame = CGRectMake(0, KScaleY(578), ScreenWidth, 18);
    } else {
        networkStatusExitBtnLabel.frame = CGRectMake(0, KScaleY(558), ScreenWidth, 18);
    }
    networkStatusExitBtnLabel.text = @"退出核验";
    networkStatusExitBtnLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    networkStatusExitBtnLabel.textAlignment = NSTextAlignmentCenter;
    networkStatusExitBtnLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self.view addSubview:networkStatusExitBtn];
    [self.view addSubview:networkStatusExitBtnLabel];
    [networkStatusExitBtn addTarget:self action:@selector(exitVerificationBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction) restartLoadBtn: (UIButton *) sender {
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable) {
        [BDFaceToastView showToast:self.view text:@"请检查网络"];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) exitVerificationBtn: (UIButton *) sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

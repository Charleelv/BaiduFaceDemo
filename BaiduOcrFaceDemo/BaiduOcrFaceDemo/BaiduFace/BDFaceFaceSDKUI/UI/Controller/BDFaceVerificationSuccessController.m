//
//  BDFaceVerificationSuccessController.m
//  IDLFaceSDKDemoOC
//
//  Created by v_shishuaifeng on 2020/8/27.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDFaceVerificationSuccessController.h"
#import "BDFaceLogoView.h"
#import "FaceViewController.h"
#import "BDUIConstant.h"
#import "UIViewController+BDPresentingAnimation.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface BDFaceVerificationSuccessController ()

@end

@implementation BDFaceVerificationSuccessController {
    
}
-(void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF0F1F2);
    
    // 底部logo部分
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 221, ScreenWidth, 221);
    logoImageView.image = [UIImage imageNamed:@"image_guide_bottom"];
    [self.view addSubview:logoImageView];
    
    // 设置logo，底部的位置和大小，实例化显示
    BDFaceLogoView* logoView = [[BDFaceLogoView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-15-12), ScreenWidth, 12)];
    [self.view addSubview:logoView];
    // title bar
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
    
    titeLabel.text = @"人脸身份核验";
    titeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:19];
    titeLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    titeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titeLabel];
    
}

-(void) verificationStatusView {
    // networkStatus image
    UIImageView *imageView = [[UIImageView alloc] init];
    if (IS_IPhoneXSeries) {
        imageView.frame = CGRectMake(ScreenWidth / 2 - 40, 170*ScreenHeight/667, 80, 80);
    } else {
        imageView.frame = CGRectMake(ScreenWidth / 2 - 40, 150*ScreenHeight/667, 80, 80);
    }
    
    imageView.image = [UIImage imageNamed:@"icon_success.png"];
    [self.view addSubview:imageView];
    
    // networkStatus text
    UILabel *networkStatusText = [[UILabel alloc] init];
    if (IS_IPhoneXSeries) {
        networkStatusText.frame = CGRectMake(0, 280*ScreenHeight/667, ScreenWidth, 20);
    } else {
        networkStatusText.frame = CGRectMake(0, 260*ScreenHeight/667, ScreenWidth, 20);
    }
    
    networkStatusText.text = @"身份核验成功";
    networkStatusText.textAlignment = NSTextAlignmentCenter;
    networkStatusText.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    networkStatusText.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1/1.0];
    [self.view addSubview:networkStatusText];
    
}

-(void) verificationStatusBtnView {
    
    // 退出核验的button
    UIButton * networkStatusExitBtn  = [[UIButton alloc] init];
    if (IS_IPhoneXSeries) {
        networkStatusExitBtn.frame = CGRectMake(ScreenWidth/2-130, KScaleY(558), 260, 52);
    } else {
        networkStatusExitBtn.frame = CGRectMake(ScreenWidth/2-130, KScaleY(538), 260, 52);
    }
    
    [networkStatusExitBtn setBackgroundColor:UIColorFromRGB(0xD9DFE6)];
    networkStatusExitBtn.layer.cornerRadius = 26;
    networkStatusExitBtn.layer.masksToBounds = YES;
    // 退出核验的label
    UILabel * networkStatusExitBtnLabel = [[UILabel alloc] init];
    if (IS_IPhoneXSeries) {
        networkStatusExitBtnLabel.frame = CGRectMake(0, KScaleY(573), ScreenWidth, 18);
    } else {
        networkStatusExitBtnLabel.frame = CGRectMake(0, KScaleY(553), ScreenWidth, 18);
    }
    
    networkStatusExitBtnLabel.text = @"关闭";
    networkStatusExitBtnLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    networkStatusExitBtnLabel.textAlignment = NSTextAlignmentCenter;
    networkStatusExitBtnLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self.view addSubview:networkStatusExitBtn];
    [self.view addSubview:networkStatusExitBtnLabel];
    [networkStatusExitBtn addTarget:self action:@selector(exitVerificationBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction) exitVerificationBtn: (UIButton *) sender {
    UIViewController *vc = self;
        while (vc.presentingViewController) {
            vc = vc.presentingViewController;
        }
    [self.navigationController popToRootViewControllerAnimated:YES];
    return;
}

@end

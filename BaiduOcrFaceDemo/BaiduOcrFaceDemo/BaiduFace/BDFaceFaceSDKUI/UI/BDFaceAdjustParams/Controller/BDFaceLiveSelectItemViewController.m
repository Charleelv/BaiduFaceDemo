//
//  BDFaceLiveSelectItemViewController.m
//  FaceSDKSample_IOS
//
//  Created by 之哥 on 2021/8/20.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "BDFaceLiveSelectItemViewController.h"
#import "BDFaceLiveItemDetailsViewController.h"
#import <BDFaceBaseKit/BDFaceBaseKit.h>

static float const BDFaceAdjustParamsNavigationBarHeight = 44.0f;
static float const BDFaceAdjustParamsNavigationBarTitleLabelOriginX = 80.0f;
static float const BDFaceAdjustParamsNavigationBarBackButtonWidth = 60.0f;
static float const BDFaceAdjustConfigControllerTitleFontSize = 20.0f;



@interface BDFaceLiveSelectItemViewController ()
@property(nonatomic, strong) UIButton *goBackButton;
@property(nonatomic, strong, readonly) UILabel *titleLabel;
@property(nonatomic, strong) UIView *titleView;
@property(nonatomic, strong) UIButton *leftButton;
@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, assign) float actionValue;
@property(nonatomic, strong) UILabel *numLabel;
@property(nonatomic, strong) UIButton *leftButton1; //动作随机数量+按钮
@property(nonatomic, strong) UIButton *rightButton1; //动作随机数量-按钮
@property(nonatomic, assign) int numValue; //动作随机数量个数
@property(nonatomic, strong) UIButton *livenessNumBtnLabel;
@property (strong, nonatomic) UISwitch *switch1;


@end

@implementation BDFaceLiveSelectItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KColorFromRGBAlpha(0xF0F1F2, 1);
    if (self.selectType == BDFaceLivenessType) {
        self.numValue = [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.actionLiveSelectNum;
        self.actionValue = [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.LivenessThr;
    }
//    else if (self.selectType == BDFaceDetectType){
//        self.actionValue = [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.silentLiveThr;
//    } else if (self.selectType == BDFaceColorType){
////        self.numValue = [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.colorLiveSelectNum;
//        self.actionValue = [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.colorLiveThr;
//    }

    [self loadTitleView];
    [self setUIConfig];

}

-(void)viewWillAppear:(BOOL)animated{
    

    NSMutableArray * liveArray = BDFaceLivingConfigModel.sharedInstance.liveActionArray;
//    NSMutableArray * colorArray = BDFaceLivingConfigModel.sharedInstance.colorActionArray;

    if (self.selectType == BDFaceLivenessType) {
        [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.liveActionArray = liveArray;
    }
//    else if (self.selectType == BDFaceColorType){
//        [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.colorActionArray = liveArray;
//    }
    if (self.selectType == BDFaceLivenessType) {
        self.livenessNum = (int)[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.liveActionArray.count;
    }
//    else if (self.selectType == BDFaceColorType){
//        self.livenessNum = (int)[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.colorActionArray.count;
//    }
    
    [self.livenessNumBtnLabel setTitle:[NSString stringWithFormat:@"%d",self.livenessNum] forState:UIControlStateNormal];

    if (self.livenessNum == 1) {
        self.numValue = self.livenessNum;
        [self.rightButton1 setImage:[UIImage imageNamed:@"right_button_unable"] forState:UIControlStateNormal];
        [self.leftButton1 setImage:[UIImage imageNamed:@"left_button_unable"] forState:UIControlStateNormal];
        self.numLabel.text = [NSString stringWithFormat:@"%d", self.numValue];
    } else if (self.numValue >= self.livenessNum) {
        self.numValue = self.livenessNum;
        self.numLabel.text = [NSString stringWithFormat:@"%d",self.livenessNum];
        [self.leftButton1 setImage:[UIImage imageNamed:@"left_button_normal"] forState:UIControlStateNormal];
        [self.rightButton1 setImage:[UIImage imageNamed:@"right_button_unable"] forState:UIControlStateNormal];
    } else if (self.numValue == 1 ) {
        [self.leftButton1 setImage:[UIImage imageNamed:@"left_button_unable"] forState:UIControlStateNormal];
        [self.rightButton1 setImage:[UIImage imageNamed:@"right_button_normal"] forState:UIControlStateNormal];
    } else {
        [self.leftButton1 setImage:[UIImage imageNamed:@"left_button_normal"] forState:UIControlStateNormal];
        [self.rightButton1 setImage:[UIImage imageNamed:@"right_button_normal"] forState:UIControlStateNormal];
    }
    [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.numOfLiveness = self.livenessNum;
    if (self.selectType == BDFaceLivenessType) {
        [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.actionLiveSelectNum = self.numValue;
    }
//    else if (self.selectType == BDFaceColorType){
//        [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.colorLiveSelectNum = self.numValue;
//    }
    [[BDFaceBaseKitManager sharedInstance] setParamsCustomConfigItem:[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (self.selectType == BDFaceLivenessType) {
        [[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem setLivenessThr:self.actionValue];
        [[FaceSDKManager sharedInstance] setlivenessThresholdValue:self.actionValue];

    }
//    else if (self.selectType == BDFaceDetectType){
//        [[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem setSilentLiveThr:self.actionValue];
//        [[FaceSDKManager sharedInstance] setSilentLiveThresholdValue:self.actionValue];
//
//    } else if (self.selectType == BDFaceColorType){
//        [[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem setColorLiveThr:self.actionValue];
//        [[FaceSDKManager sharedInstance] setcolorliveThresholdValue:self.actionValue];
//    }
}

- (void)loadTitleView {
    CGFloat originY = [BDFaceCalculateTool safeTopMargin];
    if (originY == 0) {
        originY = 20.0f;
    }
    CGRect titleRect = CGRectMake(0, originY, ScreenWidth, BDFaceAdjustParamsNavigationBarHeight);
    self.titleView = [[UIView alloc] initWithFrame:titleRect];
    [self.view addSubview:self.titleView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(BDFaceAdjustParamsNavigationBarTitleLabelOriginX, 0, [BDFaceCalculateTool screenWidth] - BDFaceAdjustParamsNavigationBarTitleLabelOriginX * 2.0, BDFaceAdjustParamsNavigationBarHeight)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:_titleLabel];
    _titleLabel.font = [UIFont boldSystemFontOfSize:BDFaceAdjustConfigControllerTitleFontSize];
    self.goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goBackButton.frame = CGRectMake(0, 0, BDFaceAdjustParamsNavigationBarBackButtonWidth, CGRectGetHeight(self.titleView.frame));
    [self.titleView addSubview:self.goBackButton];
    [self.goBackButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.goBackButton setImage:[UIImage imageNamed:@"icon_titlebar_back"] forState:UIControlStateNormal];
    self.goBackButton.imageView.contentMode = UIViewContentModeCenter;
    
//    if (self.selectType == BDFaceDetectType) {
//        _titleLabel.text = @"静默活体方案配置";
//    } else
    if (self.selectType == BDFaceLivenessType) {
        _titleLabel.text = @"动作活体方案配置";
    }
//        else if (self.selectType == BDFaceColorType) {
//        _titleLabel.text = @"炫瞳活体方案配置";
//    }
}

-(void)setUIConfig{
    {
        //        if (self.selectType == BDFaceLivenessType || self.selectType == BDFaceColorType) {
        UIButton *btn1 = [[UIButton alloc] init];
        btn1.tag = 101;
        btn1.backgroundColor = [UIColor whiteColor];
        btn1.frame = CGRectMake(0, KBDNaviHeight+134-110, ScreenWidth, 52);
        [btn1 addTarget:self action:@selector(userDidChooseToAdjustParams:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn1];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.textColor = [UIColor blackColor];
        label1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        label1.frame = CGRectMake(16, 15, 100, 22);
        label1.textAlignment = NSTextAlignmentLeft;
        label1.text = @"动作选取";
        [btn1 addSubview:label1];
        
        UIButton *settingButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
        settingButton3.frame = CGRectMake(ScreenWidth-28-16-30, 4, 30, 45);
        [btn1 addSubview:settingButton3];
        [settingButton3 setTitle:[NSString stringWithFormat:@"%d", self.livenessNum] forState:UIControlStateNormal];
        settingButton3.titleLabel.textAlignment = NSTextAlignmentRight;
        [settingButton3 setTitleColor:KColorFromRGBAlpha(0x171D24, 1) forState:UIControlStateNormal];
        [settingButton3 addTarget:self action:@selector(userDidChooseToAdjustParams:) forControlEvents:UIControlEventTouchUpInside];
        settingButton3.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        self.livenessNumBtnLabel = settingButton3;
        
        UIButton *arrowButton3 = [[UIButton alloc] init];
        arrowButton3.frame = CGRectMake(ScreenWidth-28-16, 4, 28, 45);
        [btn1 addSubview:arrowButton3];
        [arrowButton3 setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        [arrowButton3 addTarget:self action:@selector(userDidChooseToAdjustParams:) forControlEvents:UIControlEventTouchUpInside];
        
        //动作数量
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, KBDNaviHeight+186-110, ScreenWidth, 52);
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];
        
        UILabel *thresholdLabel = [[UILabel alloc] init];
        thresholdLabel.frame = CGRectMake(16, 15, 120, 22);
        thresholdLabel.text = @"动作数量";
        thresholdLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        thresholdLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
        [imageView addSubview:thresholdLabel];
        
        
        self.leftButton1 = [[UIButton alloc] init];
        self.leftButton1.frame = CGRectMake(ScreenWidth-116-28, 12, 28, 28);
        [imageView addSubview:self.leftButton1];
        [self.leftButton1 addTarget:self action:@selector(minusNumber2) forControlEvents:UIControlEventTouchUpInside];
        
        [self.leftButton1 setImage:[UIImage imageNamed:@"left_button_normal"] forState:UIControlStateNormal];
        [self.leftButton1 setImage:[UIImage imageNamed:@"left_button_highlight"] forState:UIControlStateHighlighted];
        
        self.numLabel = [[UILabel alloc] init];
        [imageView addSubview:self.numLabel];
        self.numLabel.frame = CGRectMake(ScreenWidth-56-52, 14, 56, 24);
        self.numLabel.text = [NSString stringWithFormat:@"%d", self.numValue];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.textColor = [UIColor colorWithRed:23 / 255.0 green:29 / 255.0 blue:36 / 255.0 alpha:1 / 1.0];
        self.numLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        
        
        self.rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton1.frame = CGRectMake(ScreenWidth-28-16, 12, 28, 28);
        [imageView addSubview:self.rightButton1];
        [self.rightButton1 addTarget:self action:@selector(addNumber2) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton1 setImage:[UIImage imageNamed:@"right_button_normal"] forState:UIControlStateNormal];
        [self.rightButton1 setImage:[UIImage imageNamed:@"right_button_highlight"] forState:UIControlStateHighlighted];
        
        
        // 提示
        UILabel *noticeLabel2 = [[UILabel alloc] init];
        noticeLabel2.frame = CGRectMake(16, KBDNaviHeight+186+52+6-110, ScreenWidth-32, 28);
        noticeLabel2.text = @"将从您主动选取的N个动作中，随机抽选指定数量的动作进行验证";
        noticeLabel2.numberOfLines = 2;
        [noticeLabel2 sizeToFit];
        noticeLabel2.textAlignment = NSTextAlignmentLeft;
        noticeLabel2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        noticeLabel2.textColor = KColorFromRGB(0x91979E);
        [self.view addSubview:noticeLabel2];
        //        }
    }
    // 眨眼张嘴遮挡判断
    {
        UIImageView *imageView1 = [[UIImageView alloc] init];
        imageView1.frame = CGRectMake(0, KBDNaviHeight+186+52+6-110+40, ScreenWidth, 52);
        imageView1.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:imageView1];
                
        UILabel *voiceLabel = [[UILabel alloc] init];
        voiceLabel.frame = CGRectMake(16, KBDNaviHeight+186+52+6-110+40+18, 172, 18);
        voiceLabel.text = @"眨眼张嘴遮挡判断";
        voiceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        voiceLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
        
        // 眨眼张嘴遮挡开启开启/关闭
        self.switch1 = [[UISwitch alloc] init];
        // UISwitch 系统默认大小，fram 不起作用
        self.switch1.frame = CGRectMake(ScreenWidth-48-16, KBDNaviHeight+186+52+6-110+40+10, 48, 23);
        [self.switch1 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        self.switch1.on = [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.isStrict;
        [self.view addSubview:voiceLabel];
        [self.view addSubview:self.switch1];
        [self changeSwitchColor:self.switch1];
    }
    
   

}
/*
 质量分数-按钮
 */
- (void)minusNumber1{
    self.actionValue -= 0.05;
    if (self.actionValue<=0) {
        self.actionValue=0;
        [self.leftButton setImage:[UIImage imageNamed:@"left_button_unable"] forState:UIControlStateNormal];
    } else {
        [self.leftButton setImage:[UIImage imageNamed:@"left_button_normal"] forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:@"right_button_normal"] forState:UIControlStateNormal];
    }
    [[FaceSDKManager sharedInstance] setSilentLiveThresholdValue:self.actionValue];
    self.textLabel.text = [NSString stringWithFormat:@"%.2f",self.actionValue];
}
/*
 质量分数+按钮
 */
- (void)addNumber1{
    self.actionValue += 0.05;
    if (self.actionValue>=0.95) {
        self.actionValue=0.95;
        [self.rightButton setImage:[UIImage imageNamed:@"right_button_unable"] forState:UIControlStateNormal];
    } else {
        [self.leftButton setImage:[UIImage imageNamed:@"left_button_normal"] forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:@"right_button_normal"] forState:UIControlStateNormal];
    }
    
    [[FaceSDKManager sharedInstance] setSilentLiveThresholdValue:self.actionValue];
    self.textLabel.text = [NSString stringWithFormat:@"%.2f",self.actionValue];
}

/*
 随机动作-按钮
 */
- (void)minusNumber2{
    self.numValue -= 1;
    if (self.livenessNum == 1) {
        self.numValue=self.livenessNum;
        [self.rightButton1 setImage:[UIImage imageNamed:@"right_button_unable"] forState:UIControlStateNormal];
        [self.leftButton1 setImage:[UIImage imageNamed:@"left_button_unable"] forState:UIControlStateNormal];
    } else if (self.numValue<=1) {
        self.numValue=1;
        [self.leftButton1 setImage:[UIImage imageNamed:@"left_button_unable"] forState:UIControlStateNormal];
        [self.rightButton1 setImage:[UIImage imageNamed:@"right_button_normal"] forState:UIControlStateNormal];
    } else {
        [self.leftButton1 setImage:[UIImage imageNamed:@"left_button_normal"] forState:UIControlStateNormal];
        [self.rightButton1 setImage:[UIImage imageNamed:@"right_button_normal"] forState:UIControlStateNormal];
    }
    [[FaceSDKManager sharedInstance] setSilentLiveThresholdValue:self.actionValue];
    self.numLabel.text = [NSString stringWithFormat:@"%d",self.numValue];
    if (self.selectType == BDFaceLivenessType) {
        [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.actionLiveSelectNum = self.numValue;
    }
//    else if (self.selectType == BDFaceColorType){
//        [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.colorLiveSelectNum = self.numValue;
//    }
    [[BDFaceBaseKitManager sharedInstance] setParamsCustomConfigItem:[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem];

}
/*
 随机动作+按钮
 */
- (void)addNumber2{
    self.numValue += 1;
    if (self.livenessNum == 1) {
        self.numValue=self.livenessNum;
        [self.rightButton1 setImage:[UIImage imageNamed:@"right_button_unable"] forState:UIControlStateNormal];
        [self.leftButton1 setImage:[UIImage imageNamed:@"left_button_unable"] forState:UIControlStateNormal];
    } else if (self.numValue>=self.livenessNum) {
        self.numValue=self.livenessNum;
        [self.rightButton1 setImage:[UIImage imageNamed:@"right_button_unable"] forState:UIControlStateNormal];
        [self.leftButton1 setImage:[UIImage imageNamed:@"left_button_normal"] forState:UIControlStateNormal];
        
    } else {
        [self.leftButton1 setImage:[UIImage imageNamed:@"left_button_normal"] forState:UIControlStateNormal];
        [self.rightButton1 setImage:[UIImage imageNamed:@"right_button_normal"] forState:UIControlStateNormal];
    }
    
    [[FaceSDKManager sharedInstance] setSilentLiveThresholdValue:self.actionValue];
    self.numLabel.text = [NSString stringWithFormat:@"%d",self.numValue];
    if (self.selectType == BDFaceLivenessType) {
        [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.actionLiveSelectNum = self.numValue;
    }
//    else if (self.selectType == BDFaceColorType){
////        [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.colorLiveSelectNum = self.numValue;
//    }
    [[BDFaceBaseKitManager sharedInstance] setParamsCustomConfigItem:[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem];
}

-(void)userDidChooseToAdjustParams:(UIButton *)btn{
    BDFaceLiveItemDetailsViewController * lvc = [[BDFaceLiveItemDetailsViewController alloc]init];
    lvc.livenessNum = self.livenessNum;
    lvc.selectType = self.selectType;
    [self.navigationController pushViewController:lvc animated:YES];
}


- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeSwitchColor:(UISwitch *)view {
    view.onTintColor = [UIColor face_colorWithRGBHex:0x0080FF];
    view.layer.cornerRadius = CGRectGetHeight(view.frame) / 2.0f;
}

- (IBAction)switchAction:(UISwitch *)sender {
    if (sender.isOn) {
        NSLog(@"眨眼张嘴遮挡开启");
        [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.isStrict = true;
        [[FaceSDKManager sharedInstance] setIsStrict:true];
        [[BDFaceBaseKitManager sharedInstance] setParamsCustomConfigItem:[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem];
    } else {
        NSLog(@"眨眼张嘴遮挡关闭");
        [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.isStrict = false;
        [[FaceSDKManager sharedInstance] setIsStrict:false];
        [[BDFaceBaseKitManager sharedInstance] setParamsCustomConfigItem:[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem];
    }
}
@end

//
//  BDFaceLiveSelectViewController.m
//  FaceSDKSample_IOS
//
//  Created by 之哥 on 2021/8/19.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "BDFaceLiveSelectViewController.h"
#import <BDFaceBaseKit/BDFaceBaseKit.h>
#import "BDFaceSelectRadio.h"
#import "BDFaceLiveSelectItemViewController.h"

static float const BDFaceAdjustParamsNavigationBarHeight = 44.0f;
static float const BDFaceAdjustParamsNavigationBarTitleLabelOriginX = 80.0f;
static float const BDFaceAdjustParamsNavigationBarBackButtonWidth = 60.0f;
static float const BDFaceAdjustConfigControllerTitleFontSize = 20.0f;
static float const BDFaceAdjustConfigContentTitleFontSize = 16.0f;
static UInt32 const BDFaceAdjustConfigTipTextColor = 0x171D24;
static NSString *const BDFaceSelectConfigTip = @"方案配置";
static NSString *const BDFaceSelectRightArrowImage = @"right_arrow";

@interface BDFaceLiveSelectViewController ()
@property(nonatomic, strong) UIButton *goBackButton;
@property(nonatomic, strong, readonly) UILabel *titleLabel;
@property(nonatomic, strong) UIView *titleView;

@property(nonatomic, strong) UIButton * settingButton3;
@property(nonatomic, strong) UIButton * arrowButton3;
@property(nonatomic, strong) UIButton * btn1;
@property(nonatomic, strong) UIButton * btn2;
@property(nonatomic, strong) UIButton * btn3;
@property (strong, nonatomic) UISwitch *switch1;
@property (strong, nonatomic) UISwitch *switch2;

@end

@implementation BDFaceLiveSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KColorFromRGBAlpha(0xF0F1F2, 1);
    [self loadTitleView];
    [self setUIConfig];

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
    _titleLabel.text = @"活体方案设置";
    [self.titleView addSubview:_titleLabel];
    _titleLabel.font = [UIFont boldSystemFontOfSize:BDFaceAdjustConfigControllerTitleFontSize];
    self.goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goBackButton.frame = CGRectMake(0, 0, BDFaceAdjustParamsNavigationBarBackButtonWidth, CGRectGetHeight(self.titleView.frame));
    [self.titleView addSubview:self.goBackButton];
    [self.goBackButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.goBackButton setImage:[UIImage imageNamed:@"icon_titlebar_back"] forState:UIControlStateNormal];
    self.goBackButton.imageView.contentMode = UIViewContentModeCenter;
}
-(void)setUIConfig{
    self.btn2 = [[UIButton alloc]init];
    self.btn2.tag = 102;
    self.btn2.backgroundColor = [UIColor whiteColor];
    self.btn2.frame = CGRectMake(16, KBDNaviHeight+24, ScreenWidth-32, 92);
    [self.btn2 yz_setRoundedWithCorners:UIRectCornerAllCorners cornerRadious:8];
//    [self.btn2 addTarget:self action:@selector(btn2Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn2];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:BDFaceAdjustConfigContentTitleFontSize];
    label2.frame = CGRectMake(16, 15, 100, 22);
    label2.textAlignment = NSTextAlignmentLeft;
    label2.text = @"动作活体";
    [self.btn2 addSubview:label2];
    
    // 眨眼张嘴遮挡开启开启/关闭
    self.switch1 = [[UISwitch alloc] init];
    // UISwitch 系统默认大小，fram 不起作用
    self.switch1.frame = CGRectMake(ScreenWidth-58-16-16, 10, 48, 23);
    [self.switch1 addTarget:self action:@selector(switchAction1:) forControlEvents:UIControlEventValueChanged];
    [self.btn2 addSubview:self.switch1];
    [self changeSwitchColor:self.switch1];
    
    self.btn3 = [[UIButton alloc]init];
    self.btn3.tag = 103;
    self.btn3.backgroundColor = [UIColor whiteColor];
    self.btn3.frame = CGRectMake(16, KBDNaviHeight+24+60+48, ScreenWidth-32, 52);
    [self.btn3 yz_setRoundedWithCorners:UIRectCornerAllCorners cornerRadious:8];
//    [self.btn3 addTarget:self action:@selector(btn3Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn3];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.textColor = [UIColor blackColor];
    label3.font = [UIFont systemFontOfSize:BDFaceAdjustConfigContentTitleFontSize];
    label3.frame = CGRectMake(16, 15, 100, 22);
    label3.textAlignment = NSTextAlignmentLeft;
    label3.text = @"炫瞳活体";
    [self.btn3 addSubview:label3];
    
    // 眨眼张嘴遮挡开启开启/关闭
    self.switch2 = [[UISwitch alloc] init];
    // UISwitch 系统默认大小，fram 不起作用
    self.switch2.frame = CGRectMake(ScreenWidth-58-16-16, 10, 48, 23);
    [self.switch2 addTarget:self action:@selector(switchAction2:) forControlEvents:UIControlEventValueChanged];
    [self.btn3 addSubview:self.switch2];
    [self changeSwitchColor:self.switch2];

    self.settingButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingButton3.frame = CGRectMake(ScreenWidth-32-28-16-75, 4+40, 75, 45);
    [self.btn2 addSubview:self.settingButton3];
    [self.settingButton3 setTitle:BDFaceSelectConfigTip forState:UIControlStateNormal];
    self.settingButton3.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.settingButton3 setTitleColor:[UIColor face_colorWithRGBHex:BDFaceAdjustConfigTipTextColor] forState:UIControlStateNormal];
    [self.settingButton3 addTarget:self action:@selector(userDidChooseToAdjustParams:) forControlEvents:UIControlEventTouchUpInside];
    self.settingButton3.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    
    self.arrowButton3 = [[UIButton alloc] init];
    self.arrowButton3.frame = CGRectMake(ScreenWidth-32-28-16, 4+40, 28, 45);
    [self.btn2 addSubview:self.arrowButton3];
    [self.arrowButton3 setImage:[UIImage imageNamed:BDFaceSelectRightArrowImage] forState:UIControlStateNormal];
    [self.arrowButton3 addTarget:self action:@selector(userDidChooseToAdjustParams:) forControlEvents:UIControlEventTouchUpInside];
    //活体方案传入
    self.switch1.on = [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.isLivenessType;
    self.switch2.on = [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.isColorType;
}

-(void)userDidChooseToAdjustParams:(UIButton*)btn{
    
    BDFaceLiveSelectItemViewController * lvc = [[BDFaceLiveSelectItemViewController alloc]init];
    switch (btn.superview.tag) {
//        case 101:
//            lvc.livenessNum = 0;
//            lvc.selectType = BDFaceDetectType;
//            break;
        case 102:
            lvc.livenessNum = 8;
            lvc.selectType = BDFaceLivenessType;
            [self.navigationController pushViewController:lvc animated:YES];
            break;
        case 103:
            lvc.livenessNum = 8;
            lvc.selectType = BDFaceColorType;
            [self.navigationController pushViewController:lvc animated:YES];
            break;
        default:
            break;
    }
}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeSwitchColor:(UISwitch *)view {
    view.onTintColor = [UIColor face_colorWithRGBHex:0x0080FF];
    view.layer.cornerRadius = CGRectGetHeight(view.frame) / 2.0f;
}

- (IBAction)switchAction1:(UISwitch *)sender {

    if (sender.isOn) {
        NSLog(@"开启动作活体");
        if (self.switch2.on) {
            [[NSUserDefaults standardUserDefaults] setInteger:BDFaceColorType forKey:@"LiveSelectMode"];
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"LiveMode"];
            NSLog(@"炫瞳+动作");
        } else {
            [[NSUserDefaults standardUserDefaults] setInteger:BDFaceLivenessType forKey:@"LiveSelectMode"];
            NSLog(@"动作");
        }
    } else {
        NSLog(@"关闭动作活体");
        if (self.switch2.on) {
            [[NSUserDefaults standardUserDefaults] setInteger:BDFaceColorType forKey:@"LiveSelectMode"];
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"LiveMode"];
            NSLog(@"炫瞳");
        } else {
            [[NSUserDefaults standardUserDefaults] setInteger:BDFaceDetectType forKey:@"LiveSelectMode"];
            NSLog(@"静默");
        }
    }
    [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.isLivenessType = sender.isOn;
    [[BDFaceBaseKitManager sharedInstance] setParamsCustomConfigItem:[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem];
}
- (IBAction)switchAction2:(UISwitch *)sender {
    if (sender.isOn) {
        NSLog(@"开启炫瞳活体");
        if (self.switch1.on) {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"LiveMode"];
            NSLog(@"炫瞳+动作");
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"LiveMode"];
            NSLog(@"炫瞳");
        }
        [[BDFaceBaseKitManager sharedInstance] setParamsCustomConfigItem:[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem];
        [[NSUserDefaults standardUserDefaults] setInteger:BDFaceColorType forKey:@"LiveSelectMode"];
    } else {
        NSLog(@"关闭炫瞳活体");
        if (self.switch1.on) {
            [[NSUserDefaults standardUserDefaults] setInteger:BDFaceLivenessType forKey:@"LiveSelectMode"];
            NSLog(@"动作");
        } else {
            [[NSUserDefaults standardUserDefaults] setInteger:BDFaceDetectType forKey:@"LiveSelectMode"];
            NSLog(@"静默");
        }
        [[BDFaceBaseKitManager sharedInstance] setParamsCustomConfigItem:[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem];
    }
    [BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.isColorType = sender.isOn;
    [[BDFaceBaseKitManager sharedInstance] setParamsCustomConfigItem:[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem];
}
@end

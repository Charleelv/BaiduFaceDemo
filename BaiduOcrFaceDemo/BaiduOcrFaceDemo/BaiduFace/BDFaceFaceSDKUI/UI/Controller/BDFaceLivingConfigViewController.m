//
//  LivingConfigViewController.m
//  FaceSDKSample_IOS
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "BDFaceLivingConfigViewController.h"
#import <BDFaceBaseKit/BDFaceBaseKit.h>
#import "BDFaceSelectConfigController.h"
#import "BDFaceAdjustParamsFileManager.h"
#import "BDFaceInterfaceSelectViewController.h"
#import "BDFaceLiveSelectViewController.h"

#define SoundSwitch @"SoundMode"
#define ByOrder @"ByOrder"


@interface BDFaceLivingConfigViewController ()
@property (strong, nonatomic) UISwitch *voiceSwitch;
@property (strong, nonatomic) UIImageView *warningView;
@property (strong, nonatomic) UILabel *waringLabel;
@property (strong, nonatomic) UIView *liveView;
@property (assign, nonatomic) NSInteger totalSelected;
@property (assign, nonatomic) NSInteger currentSelectedCount;
@property (strong, nonatomic) UILabel *stateLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UILabel *liveSelectLabel;
@property (nonatomic, strong) UILabel *colorSelectModeLabel;

@end

@implementation BDFaceLivingConfigViewController{
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.totalSelected = 6;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KColorFromRGB(0xF0F1F2);

    // 顶部
    UILabel *titeLabel = [[UILabel alloc] init];
    titeLabel.frame = CGRectMake(0, 10+KBDXStatusHeight, ScreenWidth, 20);
    titeLabel.text = @"设置";
    titeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    titeLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    titeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titeLabel];
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(16, 8+KBDXStatusHeight, 28, 28);
    [backButton setImage:[UIImage imageNamed:@"icon_titlebar_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // 提示
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.frame = CGRectMake(16, 16+KBDNaviHeight, 302.7, 14);
    noticeLabel.text = @"提示: 正式使用时，开发者可将前端设置功能隐藏";
    noticeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [noticeLabel setTextAlignment:NSTextAlignmentLeft];
    noticeLabel.textColor = KColorFromRGB(0x91979E);
    [self.view addSubview:noticeLabel];
    
    
    // 语音播报部分
    {
        UIImageView *imageView1 = [[UIImageView alloc] init];
        imageView1.frame = CGRectMake(0, 42+KBDNaviHeight, ScreenWidth, 52);
        imageView1.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:imageView1];
        
        
        UIImageView *img1 = [[UIImageView alloc] init];
        img1.frame = CGRectMake(16, 42+KBDNaviHeight+11, 30, 30);
        img1.image = [UIImage imageNamed:@"living_config1"];
        [self.view addSubview:img1];
        
        
        UILabel *voiceLabel = [[UILabel alloc] init];
        voiceLabel.frame = CGRectMake(58, 60+KBDNaviHeight, 72, 18);
        voiceLabel.text = @"语音播报";
        voiceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        voiceLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
        
        // 音量开启/关闭的switch button
        self.voiceSwitch = [[UISwitch alloc] init];
        // UISwitch 系统默认大小，fram 不起作用
        self.voiceSwitch.frame = CGRectMake(ScreenWidth-48-16, 49+KBDNaviHeight+3, 48, 23);
        [self.voiceSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        NSNumber *soundeMode = [[NSUserDefaults standardUserDefaults] objectForKey:SoundSwitch];
        self.voiceSwitch.on = soundeMode.boolValue;
        [self.view addSubview:voiceLabel];
        [self.view addSubview:self.voiceSwitch];
        [self changeSwitchColor:self.voiceSwitch];
    }
    
    // 质量控制部分
    {
        UIButton *qualityButton = [[UIButton alloc] init];
        qualityButton.frame = CGRectMake(0, KBDNaviHeight+110, ScreenWidth, 52);
        [qualityButton setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:qualityButton];
        [qualityButton addTarget:self action:@selector(toSettingPage) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *img2 = [[UIImageView alloc] init];
        img2.frame = CGRectMake(16, 110+KBDNaviHeight+11, 30, 30);
        img2.image = [UIImage imageNamed:@"living_config2"];
        [self.view addSubview:img2];
        
        UILabel *qualityLabel = [[UILabel alloc] init];
        qualityLabel.frame = CGRectMake(58, KBDNaviHeight+128, 72, 18);
        qualityLabel.text = @"质量控制";
        qualityLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        qualityLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
        [self.view addSubview:qualityLabel];
        UIImageView *rightArrow = [[UIImageView alloc] init];
        rightArrow.frame = CGRectMake(ScreenWidth-30-16, KBDNaviHeight+120, 30, 30);
        rightArrow.image = [UIImage imageNamed:@"right_arrow"];
        [rightArrow setContentMode:UIViewContentModeCenter];
        [self.view addSubview:rightArrow];
        
        CGRect stateLabelRect = rightArrow.frame;
        CGFloat stateLabelWidth = 60.0f;
        stateLabelRect.origin.x = CGRectGetMinX(rightArrow.frame) - stateLabelWidth;
        stateLabelRect.size.width = stateLabelWidth;
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:stateLabelRect];
        [self.view addSubview:stateLabel];
        stateLabel.textAlignment = NSTextAlignmentRight;
        stateLabel.textColor =  [UIColor colorWithRed:23 / 255.0 green:29 / 255.0 blue:36 / 255.0 alpha:1 / 1.0];
        stateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        self.stateLabel = stateLabel;
        
    }

    // 动作活体检测部分
    {
        UIButton *liveButton = [[UIButton alloc] init];
        liveButton.frame = CGRectMake(0, KBDNaviHeight+178, ScreenWidth, 52);
        [liveButton setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:liveButton];
        [liveButton addTarget:self action:@selector(toLiveSettingPage) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *img2 = [[UIImageView alloc] init];
        img2.frame = CGRectMake(16, 178+KBDNaviHeight+11, 30, 30);
        img2.image = [UIImage imageNamed:@"living_config3"];
        [self.view addSubview:img2];
        
        UILabel *qualityLabel = [[UILabel alloc] init];
        qualityLabel.frame = CGRectMake(58, KBDNaviHeight+196, 120, 18);
        qualityLabel.text = @"活体方案";
        qualityLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        qualityLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
        [self.view addSubview:qualityLabel];
        UIImageView *rightArrow = [[UIImageView alloc] init];
        rightArrow.frame = CGRectMake(ScreenWidth-30-16, KBDNaviHeight+188, 30, 30);
        rightArrow.image = [UIImage imageNamed:@"right_arrow"];
        [rightArrow setContentMode:UIViewContentModeCenter];
        [self.view addSubview:rightArrow];
        
        CGRect stateLabelRect = rightArrow.frame;
        CGFloat stateLabelWidth = 160.0f;
        stateLabelRect.origin.x = CGRectGetMinX(rightArrow.frame) - stateLabelWidth;
        stateLabelRect.size.width = stateLabelWidth;
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:stateLabelRect];
        [self.view addSubview:stateLabel];
        stateLabel.textAlignment = NSTextAlignmentRight;
        stateLabel.textColor =  [UIColor colorWithRed:23 / 255.0 green:29 / 255.0 blue:36 / 255.0 alpha:1 / 1.0];
        stateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        
        NSInteger i = [[NSUserDefaults standardUserDefaults] integerForKey:@"LiveSelectMode"];
        if (i == 0) {
            stateLabel.text = @"静默活体";
        } else if (i == 1){
            stateLabel.text = @"动作活体";
        } else if (i == 2){
            stateLabel.text = @"炫彩活体";
        }
        self.liveSelectLabel = stateLabel;
        self.liveSelectLabel.hidden = YES;
    }
    
    // 界面外观部分
    {
        UIButton *interfaceButton = [[UIButton alloc] init];
        interfaceButton.frame = CGRectMake(0, KBDNaviHeight+178+68, ScreenWidth, 52);
        [interfaceButton setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:interfaceButton];
        [interfaceButton addTarget:self action:@selector(toInterfaceSettingPage) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *img2 = [[UIImageView alloc] init];
        img2.frame = CGRectMake(16, 178+KBDNaviHeight+11+68, 30, 30);
        img2.image = [UIImage imageNamed:@"living_config4"];
        [self.view addSubview:img2];
        
        UILabel *qualityLabel = [[UILabel alloc] init];
        qualityLabel.frame = CGRectMake(58, KBDNaviHeight+196+68, 120, 18);
        qualityLabel.text = @"界面外观";
        qualityLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        qualityLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
        [self.view addSubview:qualityLabel];
        UIImageView *rightArrow = [[UIImageView alloc] init];
        rightArrow.frame = CGRectMake(ScreenWidth-30-16, KBDNaviHeight+188+68, 30, 30);
        rightArrow.image = [UIImage imageNamed:@"right_arrow"];
        [rightArrow setContentMode:UIViewContentModeCenter];
        [self.view addSubview:rightArrow];
        
        CGRect stateLabelRect = rightArrow.frame;
        CGFloat stateLabelWidth = 60.0f;
        stateLabelRect.origin.x = CGRectGetMinX(rightArrow.frame) - stateLabelWidth;
        stateLabelRect.size.width = stateLabelWidth;
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:stateLabelRect];
        [self.view addSubview:stateLabel];
        stateLabel.textAlignment = NSTextAlignmentRight;
        stateLabel.textColor =  [UIColor colorWithRed:23 / 255.0 green:29 / 255.0 blue:36 / 255.0 alpha:1 / 1.0];
        stateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        stateLabel.text = @"白色";
        NSInteger i = [[NSUserDefaults standardUserDefaults] integerForKey:@"ColorSelectMode"];
        if (i == 0) {
            stateLabel.text = @"白色";
        } else if (i == 1){
            stateLabel.text = @"黑色";
        }
        self.colorSelectModeLabel = stateLabel;
        
    } 
}
- (void)viewWillAppear:(BOOL)animated {
    self.stateLabel.text = [BDFaceAdjustParamsFileManager currentSelectionText];
    NSInteger i = [[NSUserDefaults standardUserDefaults] integerForKey:@"LiveSelectMode"];
    if (i == 0) {
        self.liveSelectLabel.text = @"静默活体";
    } else if (i == 1){
        self.liveSelectLabel.text = @"动作活体";
    } else if (i == 2){
        self.liveSelectLabel.text = @"炫彩活体";
    }
    [[BDFaceBaseKitManager sharedInstance] setParamsCustomConfigItem:[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem];

    NSInteger j = [[NSUserDefaults standardUserDefaults] integerForKey:@"ColorSelectMode"];
    if (j == 0) {
        self.colorSelectModeLabel.text = @"白色";
        BDFaceBaseKitUICustomConfigItem * uiCustomConfigItem = [[BDFaceBaseKitUICustomConfigItem alloc]initWithUIConfig];
        [[BDFaceBaseKitManager sharedInstance] setUiCustomConfigItem:uiCustomConfigItem];
    } else if (j == 1){
        self.colorSelectModeLabel.text = @"黑色";
        BDFaceBaseKitUICustomConfigItem * uiCustomConfigItem = [[BDFaceBaseKitUICustomConfigItem alloc]initWithBlackUIConfig];
        [[BDFaceBaseKitManager sharedInstance] setUiCustomConfigItem:uiCustomConfigItem];
    }
}

- (void)toSettingPage {
    BDFaceSelectConfigController *lvc = [[BDFaceSelectConfigController alloc] init];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (void)toLiveSettingPage {
    BDFaceLiveSelectViewController *lvc = [[BDFaceLiveSelectViewController alloc] init];
    lvc.selectType = [[NSUserDefaults standardUserDefaults] integerForKey:@"LiveSelectMode"];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (void)toInterfaceSettingPage {
    BDFaceInterfaceSelectViewController *lvc = [[BDFaceInterfaceSelectViewController alloc] init];
    lvc.selectType = [[NSUserDefaults standardUserDefaults] integerForKey:@"ColorSelectMode"];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeSwitchColor:(UISwitch *)view {
    view.onTintColor = [UIColor face_colorWithRGBHex:0x0080FF];
    view.layer.cornerRadius = CGRectGetHeight(view.frame) / 2.0f;
}
# pragma mark - switch button部分

- (IBAction)switchAction:(UISwitch *)sender {
    if (sender.isOn) {
        [SSFaceProcessManager sharedInstance].enableSound = YES;
        // warning 本地存储是为了Demo呈现Switch开关状态, 实际上SDK声音开关运用跟本地存储无关
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:SoundSwitch];
        NSLog(@"打开了声音");
    } else {
//        // 活体声音
        [SSFaceProcessManager sharedInstance].enableSound = NO;
        // warning 本地存储是为了Demo呈现Switch开关状态, 实际上SDK声音开关运用跟本地存储无关
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:SoundSwitch];
        NSLog(@"关闭了声音");
    }
}


@end

//
//  CDFaceLiveItemDetailsViewController.m
//  FaceSDKSample_IOS
//
//  Created by 之哥 on 2021/8/20.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "BDFaceLiveItemDetailsViewController.h"
#import <BDFaceBaseKit/BDFaceBaseKit.h>
#import "BDFaceSelectRadio.h"

static float const BDFaceAdjustParamsNavigationBarHeight = 44.0f;
static float const BDFaceAdjustParamsNavigationBarTitleLabelOriginX = 80.0f;
static float const BDFaceAdjustParamsNavigationBarBackButtonWidth = 60.0f;
static float const BDFaceAdjustConfigControllerTitleFontSize = 20.0f;
static float const BDFaceAdjustConfigContentTitleFontSize = 16.0f;

@interface BDFaceLiveItemDetailsViewController ()

@property(nonatomic, strong) UIButton *goBackButton;
@property(nonatomic, strong, readonly) UILabel *titleLabel;
@property(nonatomic, strong) UIView *titleView;
@property (assign, nonatomic) NSInteger totalSelected;
@property (strong, nonatomic) UIView *liveView;

@end

@implementation BDFaceLiveItemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.totalSelected = self.livenessNum;
    self.view.backgroundColor = KColorFromRGBAlpha(0xF0F1F2, 1);
    [self loadTitleView];
    [self setUIConfig];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.selectType == BDFaceLivenessType) {
        NSMutableArray * array = [NSMutableArray arrayWithArray:[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.liveActionArray];
        BDFaceLivingConfigModel.sharedInstance.liveActionArray = array;
    } else if (self.selectType == BDFaceColorType){
//        NSMutableArray * array = [NSMutableArray arrayWithArray:[BDFaceBaseKitManager sharedInstance].paramsCustomConfigItem.colorActionArray];
//        BDFaceLivingConfigModel.sharedInstance.colorActionArray = array;
    }
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
    _titleLabel.text = @"动作选取";
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
    {
        self.liveView = [[UIView alloc] init];
        self.liveView.frame = CGRectMake(16, KBDNaviHeight+24, ScreenWidth-32, 60*8);
        self.liveView.backgroundColor = KColorFromRGBAlpha(0xF0F1F2, 1);
        [self.view addSubview:self.liveView];
        // 循环创建控件，相应的为动作选择，根据tag来确定点击的是哪个控件
        for (int i = 0; i < 8; i++){
            int y = i * 60;
            UIView *strName = [[UIView alloc] init];
            strName.frame = CGRectMake(0, y + 4, ScreenWidth-32, 52);
            strName.backgroundColor = [UIColor whiteColor];
            [self.liveView addSubview:strName];
            [strName yz_setRoundedWithCorners:UIRectCornerAllCorners cornerRadious:8];
            
            UIButton *buttonView = [[UIButton alloc] init];
            buttonView.frame = CGRectMake(0, y + 4, ScreenWidth-32, 52);
            buttonView.imageEdgeInsets = UIEdgeInsetsMake(8, KScaleX(-295), 8, 12);
            buttonView.tag = i;
            buttonView.highlighted = NO;
            [buttonView addTarget:self action:@selector(buttonTagClick:) forControlEvents:UIControlEventTouchUpInside];

            if (self.selectType == BDFaceLivenessType) {
                // 判断数组中是否有上次选择结果，如果有，继续选择
                if([BDFaceLivingConfigModel.sharedInstance.liveActionArray containsObject:@(i)]){
                    buttonView.selected = YES;
                    [buttonView setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
                } else {
                    buttonView.selected = NO;
                    [buttonView setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
                }
                [self.liveView  addSubview:buttonView];
            }
//            else if (self.selectType == BDFaceColorType){
//                // 判断数组中是否有上次选择结果，如果有，继续选择
//                if([BDFaceLivingConfigModel.sharedInstance.colorActionArray containsObject:@(i)]){
//                    buttonView.selected = YES;
//                    [buttonView setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
//                } else {
//                    buttonView.selected = NO;
//                    [buttonView setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
//                }
//                [self.liveView  addSubview:buttonView];
//            }
            
            
            // 相应的label
            UILabel *actionLabel = [[UILabel alloc] init];
            actionLabel.frame = CGRectMake(44, y + 18, 192, 22);
            actionLabel.text = [self getLiveName:i];
            actionLabel.font = [UIFont systemFontOfSize:BDFaceAdjustConfigContentTitleFontSize];
            actionLabel.textColor = KColorFromRGB(0x171D24);
            [self.liveView  addSubview:actionLabel];
        }

        
    }
}
- (NSString *)getLiveName:(int) k{
    switch (k) {
        case 0:
            return @"眨眨眼";
            break;
        case 1:
            return @"张张嘴";
            break;
        case 2:
            return @"向右摇头";
            break;
        case 3:
            return @"向左摇头";
            break;
        case 4:
            return @"向上抬头";
            break;
        case 5:
            return @"向下低头";
            break;
        case 6:
            return @"上下点头";
            break;
        case 7:
            return @"左右摇头";
            break;
        default:
            break;
    }
    return @"";
}

- (IBAction)buttonTagClick:(UIButton *)sender{
    BOOL desState = sender.selected;
    desState = !desState;
    NSInteger temp = self.totalSelected;
    if (desState) {
        self.totalSelected++;
    } else {
        self.totalSelected--;
    }
    if (self.totalSelected == 0) {
        self.totalSelected = temp;
        [BDFaceToastView showToast:self.view text:@"至少选择一项活体动作"];
        return;;
    }
    
    switch (sender.tag) {
        case 0:
            [self liveEyeAction:sender];
            break;
        case 1:
            [self liveMouthAction:sender];
            break;
        case 2:
            [self liveHeadRightAction:sender];
            break;
        case 3:
            [self liveHeadLeftAction:sender];
            break;
        case 4:
            [self liveHeadUpAction:sender];
            break;
        case 5:
            [self liveHeadDownAction:sender];
            break;
        case 6:
            [self liveHeadUpDownAction:sender];
            break;
        case 7:
            [self liveHeadYawAction:sender];
            break;
            
            
        default:
            break;
    }
    if (sender.selected){
        // 如果选择按照顺序，对活体动作按设置页面顺序排序
        NSNumber *orderMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"ByOrder"];
        if (orderMode.boolValue){
            if (self.selectType == BDFaceLivenessType) {
                [BDFaceLivingConfigModel.sharedInstance.liveActionArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    return [obj1 intValue] > [obj2 intValue];
                }];
            }
//            else if (self.selectType == BDFaceColorType){
//                [BDFaceLivingConfigModel.sharedInstance.colorActionArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//                    return [obj1 intValue] > [obj2 intValue];
//                }];
//            }
            
        }
    }
}

# pragma mark - 动作活体button相应的部分

- (IBAction)liveEyeAction:(UIButton *)sender {
    sender.selected ^= 1;
    if (self.selectType == BDFaceLivenessType) {
        if (sender.selected) {
            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveEye)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
        } else {
            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray removeObject:@(FaceLivenessActionTypeLiveEye)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
        }
    }
//    else if (self.selectType == BDFaceColorType){
//        if (sender.selected) {
//            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray addObject:@(FaceLivenessActionTypeLiveEye)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
//        } else {
//            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray removeObject:@(FaceLivenessActionTypeLiveEye)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
//        }
//    }
    
}

- (IBAction)liveMouthAction:(UIButton *)sender {
    sender.selected ^= 1;
    if (self.selectType == BDFaceLivenessType) {
        if (sender.selected) {
            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveMouth)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
        } else {
            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray removeObject:@(FaceLivenessActionTypeLiveMouth)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
        }
    }
//    else if (self.selectType == BDFaceColorType){
//        if (sender.selected) {
//            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray addObject:@(FaceLivenessActionTypeLiveMouth)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
//        } else {
//            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray removeObject:@(FaceLivenessActionTypeLiveMouth)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
//        }
//    }
    
}

- (IBAction)liveHeadRightAction:(UIButton *)sender {
    sender.selected ^= 1;
    if (self.selectType == BDFaceLivenessType) {
        if (sender.selected) {
            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveYawRight)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
        } else {
            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray removeObject:@(FaceLivenessActionTypeLiveYawRight)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
        }
    }
//    else if (self.selectType == BDFaceColorType){
//        if (sender.selected) {
//            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray addObject:@(FaceLivenessActionTypeLiveYawRight)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
//        } else {
//            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray removeObject:@(FaceLivenessActionTypeLiveYawRight)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
//        }
//    }
    
}

- (IBAction)liveHeadLeftAction:(UIButton *)sender {
    sender.selected ^= 1;
    if (self.selectType == BDFaceLivenessType) {
        if (sender.selected) {
            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveYawLeft)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
        } else {
            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray removeObject:@(FaceLivenessActionTypeLiveYawLeft)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
        }
    }
//    else if (self.selectType == BDFaceColorType){
//        if (sender.selected) {
//            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray addObject:@(FaceLivenessActionTypeLiveYawLeft)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
//        } else {
//            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray removeObject:@(FaceLivenessActionTypeLiveYawLeft)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
//        }
//    }
    
}

- (IBAction)liveHeadUpAction:(UIButton *)sender {
    sender.selected ^= 1;
    if (self.selectType == BDFaceLivenessType) {
        if (sender.selected) {
            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLivePitchUp)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
        } else {
            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray removeObject:@(FaceLivenessActionTypeLivePitchUp)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
        }
    }
//    else if (self.selectType == BDFaceColorType){
//        if (sender.selected) {
//            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray addObject:@(FaceLivenessActionTypeLivePitchUp)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
//        } else {
//            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray removeObject:@(FaceLivenessActionTypeLivePitchUp)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
//        }
//    }
    
}

- (IBAction)liveHeadDownAction:(UIButton *)sender {
    sender.selected ^= 1;
    if (self.selectType == BDFaceLivenessType) {
        if (sender.selected) {
            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLivePitchDown)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
        } else {
            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray removeObject:@(FaceLivenessActionTypeLivePitchDown)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
        }
    }
//    else if (self.selectType == BDFaceColorType){
//        if (sender.selected) {
//            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray addObject:@(FaceLivenessActionTypeLivePitchDown)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
//        } else {
//            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray removeObject:@(FaceLivenessActionTypeLivePitchDown)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
//        }
//    }
    
}

- (IBAction)liveHeadUpDownAction:(UIButton *)sender {
    sender.selected ^= 1;
    if (self.selectType == BDFaceLivenessType) {
        if (sender.selected) {
            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveUpDown)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
        } else {
            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray removeObject:@(FaceLivenessActionTypeLiveUpDown)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
        }
    }
//    else if (self.selectType == BDFaceColorType){
//        if (sender.selected) {
//            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray addObject:@(FaceLivenessActionTypeLiveUpDown)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
//        } else {
//            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray removeObject:@(FaceLivenessActionTypeLiveUpDown)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
//        }
//    }
    
}

- (IBAction)liveHeadYawAction:(UIButton *)sender {
    sender.selected ^= 1;
    if (self.selectType == BDFaceLivenessType) {
        if (sender.selected) {
            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeShakeHead)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
        } else {
            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray removeObject:@(FaceLivenessActionTypeShakeHead)];
            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
        }
    }
//    else if (self.selectType == BDFaceColorType){
//        if (sender.selected) {
//            [sender setImage:[UIImage imageNamed:@"icon_guide_s"] forState:UIControlStateSelected];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray addObject:@(FaceLivenessActionTypeShakeHead)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
//        } else {
//            [sender setImage:[UIImage imageNamed:@"icon_guide"] forState:UIControlStateNormal];
//            [BDFaceLivingConfigModel.sharedInstance.colorActionArray removeObject:@(FaceLivenessActionTypeShakeHead)];
//            BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
//        }
//    }
    
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

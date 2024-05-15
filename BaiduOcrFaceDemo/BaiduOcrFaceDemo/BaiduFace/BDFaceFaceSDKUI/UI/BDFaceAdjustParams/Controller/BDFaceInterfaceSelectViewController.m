//
//  BDFaceInterfaceSelectViewController.m
//  FaceSDKSample_IOS
//
//  Created by 之哥 on 2021/8/19.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "BDFaceInterfaceSelectViewController.h"
#import <BDFaceBaseKit/BDFaceBaseKit.h>
#import "BDFaceSelectRadio.h"

static float const BDFaceAdjustParamsNavigationBarHeight = 44.0f;
static float const BDFaceAdjustParamsNavigationBarTitleLabelOriginX = 80.0f;
static float const BDFaceAdjustParamsNavigationBarBackButtonWidth = 60.0f;
static float const BDFaceAdjustConfigControllerTitleFontSize = 20.0f;
static float const BDFaceAdjustConfigContentTitleFontSize = 16.0f;

@interface BDFaceInterfaceSelectViewController ()
@property(nonatomic, strong) UIButton *goBackButton;
@property(nonatomic, strong, readonly) UILabel *titleLabel;
@property(nonatomic, strong) UIView *titleView;

@property(nonatomic, strong) BDFaceSelectRadio *radio1;
@property(nonatomic, strong) BDFaceSelectRadio *radio2;

@end

@implementation BDFaceInterfaceSelectViewController

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
    _titleLabel.text = @"界面外观设置";
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
    UIButton * btn1 = [[UIButton alloc]init];
    btn1.backgroundColor = [UIColor whiteColor];
    btn1.frame = CGRectMake(16, KBDNaviHeight+24, ScreenWidth-32, 52);
    [btn1 yz_setRoundedWithCorners:UIRectCornerAllCorners cornerRadious:8];
    [btn1 addTarget:self action:@selector(btn1Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    self.radio1 = [BDFaceSelectRadio buttonWithType:UIButtonTypeCustom selected:NO];
    self.radio1.frame = CGRectMake(8, 6, 40, 40);
    [self.radio1 changeRadioState:YES];
    [btn1 addSubview:self.radio1];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:BDFaceAdjustConfigContentTitleFontSize];
    label1.frame = CGRectMake(44, 15, 100, 22);
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = @"白色";
    [btn1 addSubview:label1];
    
    
    UIButton * btn2 = [[UIButton alloc]init];
    btn2.backgroundColor = [UIColor whiteColor];
    btn2.frame = CGRectMake(16, KBDNaviHeight+24+60, ScreenWidth-32, 52);
    [btn2 yz_setRoundedWithCorners:UIRectCornerAllCorners cornerRadious:8];
    [btn2 addTarget:self action:@selector(btn2Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    self.radio2 = [BDFaceSelectRadio buttonWithType:UIButtonTypeCustom selected:NO];
    self.radio2.frame = CGRectMake(8, 6, 40, 40);
    [btn2 addSubview:self.radio2];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:BDFaceAdjustConfigContentTitleFontSize];
    label2.frame = CGRectMake(44, 15, 100, 22);
    label2.textAlignment = NSTextAlignmentLeft;
    label2.text = @"黑色";
    [btn2 addSubview:label2];
    
    if (self.selectType == 0) {
        [self btn1Action];
    }else if (self.selectType == 1){
        [self btn2Action];
    }
}

-(void)btn1Action{
    [self.radio1 changeRadioState:YES];
    [[NSUserDefaults standardUserDefaults] setInteger:BDFaceWhiteType forKey:@"ColorSelectMode"];
}

-(void)btn2Action{
    [self.radio2 changeRadioState:YES];
    [[NSUserDefaults standardUserDefaults] setInteger:BDFaceBlackType forKey:@"ColorSelectMode"];
}


- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

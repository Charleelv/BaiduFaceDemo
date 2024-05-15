//
//  BDFaceVerificationFailController.h
//  IDLFaceSDKDemoOC
//
//  Created by v_shishuaifeng on 2020/8/27.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDFaceVerificationFailController : UIViewController
@property(nonatomic, strong)NSString *titleText;
@property(nonatomic, strong)UIImage *iconImage;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *nameText;
@property(nonatomic, strong)NSString *btnText;
/// 默认显示重试按钮
@property (nonatomic, assign) BOOL showRetry;
@property(nonatomic, strong)NSString *idCardName;
@property(nonatomic, strong)NSString *idCardNumber;
@end

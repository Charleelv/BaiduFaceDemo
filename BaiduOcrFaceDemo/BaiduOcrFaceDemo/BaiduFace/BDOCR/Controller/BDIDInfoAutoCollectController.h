//
//  BDIDInfoAutoCollectController.h
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/9/27.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDIDInfoCollectConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDIDInfoAutoCollectController : UIViewController

@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *nameId;
@property(nonatomic, strong)UIImage *uiImage;
@property(nonatomic, assign) BOOL noInforPage; // 无个人信息的错误页
@property(nonatomic, copy) NSString *errorMessage; // 无个人信息的错误页

/**
 * 获取到了身份信息，点击下一次的block回调
 */
@property(nonatomic, copy) NextStepButtonClicked action;

@end 

NS_ASSUME_NONNULL_END

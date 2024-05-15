//
//  BDIDInfoCollectController.h
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/9/24.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDIDInfoCollectConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDIDInfoCollectController : UIViewController

/**
 * 获取到了身份信息，点击下一次的block回调
 */
@property(nonatomic, copy) NextStepButtonClicked action;

@end

NS_ASSUME_NONNULL_END

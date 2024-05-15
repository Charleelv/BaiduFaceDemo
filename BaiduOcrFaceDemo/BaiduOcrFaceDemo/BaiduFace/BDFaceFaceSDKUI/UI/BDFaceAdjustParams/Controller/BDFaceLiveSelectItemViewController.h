//
//  BDFaceLiveSelectItemViewController.h
//  FaceSDKSample_IOS
//
//  Created by 之哥 on 2021/8/20.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BDFaceBaseKit/BDFaceBaseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDFaceLiveSelectItemViewController : UIViewController

@property(nonatomic, assign) int livenessNum; //动作列表内动作个数

@property(nonatomic, assign) BDFaceLiveSelectType selectType; //方案类型

@end

NS_ASSUME_NONNULL_END

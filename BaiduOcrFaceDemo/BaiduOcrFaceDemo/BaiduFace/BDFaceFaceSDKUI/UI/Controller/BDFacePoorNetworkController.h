//
//  BDFacePoorNetworkController .h
//  IDLFaceSDKDemoOC
//
//  Created by v_shishuaifeng on 2020/8/27.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BDFaceBaseKit/BDFaceBaseKit.h>

@interface BDFacePoorNetworkController  : UIViewController
@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString *idCardName;
@property (nonatomic, copy) NSString *idCardNumber;
@property (nonatomic, strong) FaceCropImageInfo *imageArr;
@property (nonatomic, copy) NSString *originalImageEncryptStr;
@property (nonatomic, copy) NSString *cropImageWithBlackEncryptStr;
@end

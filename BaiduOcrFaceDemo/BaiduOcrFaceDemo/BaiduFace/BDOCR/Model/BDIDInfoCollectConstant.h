//
//  BDIDInfoCollectConstant.h
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/10/17.
//  Copyright © 2021 Baidu. All rights reserved.
//

#ifndef BDIDInfoCollectConstant_h
#define BDIDInfoCollectConstant_h

/// 获取到的身份信息的身份Numberkey
static NSString * _Nonnull BDIDInfoCollectControllerIdNumberKey = @"id_card_number";
/// 获取到的身份信息的身份姓名Key
static NSString * _Nonnull BDIDInfoCollectControllerNameKey = @"name";
/// 身份证类型，为NSNumber型
static NSString * _Nonnull BDIDInfoCollectControllerCarTypeKey = @"verify_type";

/// 用户点击了下一步，并成功获取到了用户信息, 参数dic里面装了姓名和身份信息
typedef void(^NextStepButtonClicked)(NSDictionary * _Nonnull dic);

#endif /* BDIDInfoCollectConstant_h */

//
//  BDCardInfoService.h
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/10/21.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDCardInfoService : NSObject


+ (void)showCardCollectPage:(UIViewController *)controller finish:(void(^)(NSDictionary *dic))completion;

@end

NS_ASSUME_NONNULL_END

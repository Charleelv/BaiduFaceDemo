//
//  BDCardInfoService.m
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/10/21.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "BDCardInfoService.h"
#import "BDConfigDataService.h"
#import "BDIDInfoAutoCollectController.h"
#import "BDIDInfoCollectController.h"
#import <BDFaceLogicLayer/BDFaceLogicLayer.h>
#import <BDFaceBaseKit/BDFaceBaseKit.h>

@interface BDCardInfoService ()


@end

@implementation BDCardInfoService

+ (void)showCardCollectPage:(UIViewController *)controller finish:(void(^)(NSDictionary *dic))completion {
    if ([BDConfigDataService useOCR] == 1) {
        // OCR 身份证识别页
        [self showOcrAutoInputController:controller finish:completion];
    } else if ([BDConfigDataService useOCR] == 0) {
        // 手动输入页面
        [self showManualInputController:controller finish:completion];
    }
}


/// 显示手动输入页面
+ (void)showManualInputController:(UIViewController *)topController finish:(void(^)(NSDictionary *dic))completion {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CollectInfo" bundle:[NSBundle mainBundle]];
    BDIDInfoCollectController *controller = [sb instantiateViewControllerWithIdentifier:@"BDIDInfoCollectController"];
    __weak UIViewController *weakTop = topController;
    [weakTop.navigationController pushViewController:controller animated:YES];
    controller.action = ^(NSDictionary * _Nonnull dic) {
        NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:dic];
        if (completion) {
            completion(parameters);
        }
    };
}

/// 显示OCR输入页面
+ (void)showOcrAutoInputController:(UIViewController *)topController finish:(void(^)(NSDictionary *dic))completion {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CollectInfo" bundle:[NSBundle mainBundle]];
    BDIDInfoAutoCollectController *controller = [sb instantiateViewControllerWithIdentifier:@"BDIDInfoAutoCollectController"];
    __weak UIViewController *weakTop = topController;
    [topController.navigationController pushViewController:controller animated:YES];
    controller.action = ^(NSDictionary * _Nonnull dic) {
        NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:dic];
        if (completion) {
            completion(parameters);
        }
    };
}


@end

//
//  FaceViewController.h
//  BaiduOcrFaceDemo
//
//  Created by CharlieLv on 2024/5/14.
//

#import <UIKit/UIKit.h>
#import <BDFaceLogicLayer/BDFaceLogicLayer.h>
#import "BDCardInfoService.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaceViewController : UIViewController
@property (strong, nonatomic) BDFaceLogicService *logicService;
@property (copy, nonatomic) NSString * accessToken;

@end

NS_ASSUME_NONNULL_END

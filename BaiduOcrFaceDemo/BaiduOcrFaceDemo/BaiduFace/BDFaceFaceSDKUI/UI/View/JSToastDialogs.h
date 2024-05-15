//
//  JSToastDialogs.h
//  IDLFaceSDKDemoOC
//
//  Created by v_shishuaifeng on 2020/9/15.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 声明定义一个DialogsLabel对象
@interface DialogsLabel : UILabel
- (void)setMessageText:(NSString *)text;
@end

@interface JSToastDialogs : NSObject {
    DialogsLabel *dialogsLabel;
    NSTimer *countTimer;
}
// 创建声明单例方法
+ (instancetype)shareInstance;

- (void)makeToast:(NSString *)message duration:(CGFloat)duration;
@end

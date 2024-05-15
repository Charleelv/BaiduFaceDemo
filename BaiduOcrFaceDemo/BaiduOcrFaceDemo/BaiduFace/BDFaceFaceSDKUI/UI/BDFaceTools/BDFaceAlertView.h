//
//  BDFaceAlertView.h
//  baiduTBDemo
//
//  Created by v_bihongvwei on 2021/10/12.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BDFaceAlertViewShowPositionStyle) {
    BDFaceAlertViewShowPositionStyleCenter,     //显示在中间
    BDFaceAlertViewShowPositionStyleTop,        //显示在顶端
    BDFaceAlertViewShowPositionStyleBottom      //显示在底部
};
NS_ASSUME_NONNULL_BEGIN

@interface BDFaceAlertView : UIView


+ (void)showView:(UIView *)showView position:(BDFaceAlertViewShowPositionStyle)positionStyle;

/**
  dismiss 当前弹出的视图
 */
+ (void)dismiss;


@end

NS_ASSUME_NONNULL_END

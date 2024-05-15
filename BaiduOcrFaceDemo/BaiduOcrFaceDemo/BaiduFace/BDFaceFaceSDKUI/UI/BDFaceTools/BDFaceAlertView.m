//
//  BDFaceAlertView.m
//  baiduTBDemo
//
//  Created by v_bihongvwei on 2021/10/12.
//

#import "BDFaceAlertView.h"

#define MainScreen [UIScreen mainScreen].bounds

@interface BDFaceAlertView ()<CAAnimationDelegate>

@property (nonatomic, weak)UIView *showView;

/** 动画时间 */
@property (nonatomic, assign)NSTimeInterval duration;

/** 是否启用点击空白 dimiss 视图 */
@property (nonatomic, assign)BOOL touchOtherDimiss;

/** 控制器 */
@property (nonatomic, strong)UIViewController *showVC;

/** 显示方式 */
@property (nonatomic, assign)BDFaceAlertViewShowPositionStyle positionStyle;

@end

@implementation BDFaceAlertView

+ (instancetype)shareSelectView{
    
    static BDFaceAlertView *shareView;
    if (shareView) {
        return shareView;
    }
    shareView = [[BDFaceAlertView alloc] init];
    shareView.frame = MainScreen;
    shareView.duration = 0.15;
    shareView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    shareView.touchOtherDimiss = YES;
    return shareView;
}

#pragma mark -类方法

+ (void)dismiss{
    
    [[self shareSelectView] dismiss];
    
}

+ (void)showView:(UIView *)showView position:(BDFaceAlertViewShowPositionStyle)positionStyle{
    [[self shareSelectView] showView:showView position:positionStyle];
}

#pragma mark - 方法实现
/**
 * 显示弹窗画面
 */
- (void)showView:(UIView *)showView position:(BDFaceAlertViewShowPositionStyle)positionStyle{
    _showView = showView;
    _positionStyle = positionStyle;
    [self addSubview: showView];
    if (self.positionStyle == BDFaceAlertViewShowPositionStyleCenter) {
        self.alpha = 0.0f;
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 1.0f;
        }];
        
        CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//        keyFrameAnimation.values = @[
//                                     [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01, 0.01, 1.0)],
//                                     [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.03, 1.03, 1.0)],
//                                     [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.97, 0.97, 1.0)],
//                                     [NSValue valueWithCATransform3D:CATransform3DIdentity]
//                                     ];
//        keyFrameAnimation.keyTimes = @[@(0.2f), @(0.5f), @(0.75f), @(1.0f)];
        keyFrameAnimation.timingFunctions = @[
                                              [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                              [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                              [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                              [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
                                              ];
        keyFrameAnimation.duration = 0.1f;
        [self.showView.layer addAnimation:keyFrameAnimation forKey:nil];
        self.showView.center = self.center;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        return;
    }
    self.alpha = 0.0f;
    [UIView animateWithDuration:self.duration animations:^{
        self.alpha = 1.0f;
    }];
    if (self.positionStyle == BDFaceAlertViewShowPositionStyleTop) {
        
        CGRect realFrame = CGRectMake(0, 0, MainScreen.size.width, showView.frame.size.height);
        
        showView.frame = CGRectMake(0, - showView.frame.size.height, MainScreen.size.width, showView.frame.size.height);
        
        [UIView animateWithDuration:self.duration animations:^{
            showView.frame = realFrame;
        }];
    }
    if (self.positionStyle == BDFaceAlertViewShowPositionStyleBottom) {
        
        CGRect realFrame = CGRectMake(0, MainScreen.size.height - showView.frame.size.height, MainScreen.size.width, showView.frame.size.height);
        
        showView.frame = CGRectMake(0, MainScreen.size.height + showView.frame.size.height, MainScreen.size.width, showView.frame.size.height);
        
        [UIView animateWithDuration:self.duration animations:^{
            showView.frame = realFrame;
        }];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

/**
 * 关闭当前画面
 */
- (void)dismiss{
    
    if (self.positionStyle == BDFaceAlertViewShowPositionStyleCenter) {
        
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 0.0f;
        }];
        CAKeyframeAnimation *outAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        outAnimation.values = @[
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.03f, 1.03f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)]
                                ];
        outAnimation.keyTimes = @[@(0.15f), @(0.35f), @(0.65f)];
        outAnimation.timingFunctions = @[
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
                                         ];
        outAnimation.delegate = self;
        
        outAnimation.duration = 0.1;
        
        [self.showView.layer addAnimation:outAnimation forKey:nil];
        return;
    }
    
    [UIView animateWithDuration:self.duration * 0.1f animations:^{
        self.alpha = 0.0f;
        [self removeAllView];
    }];
    
    if (self.positionStyle == BDFaceAlertViewShowPositionStyleTop) {
        CGRect lastFrame = CGRectMake(0, - _showView.frame.size.height, MainScreen.size.width, _showView.frame.size.height);

        [UIView animateWithDuration:self.duration animations:^{
            self.showView.frame = lastFrame;
        } completion:^(BOOL finished) {
            [self removeAllView];
        }];
    }

    if (self.positionStyle == BDFaceAlertViewShowPositionStyleBottom) {
        CGRect lastFrame = CGRectMake(0, MainScreen.size.height + _showView.frame.size.height, MainScreen.size.width, _showView.frame.size.height);
        [UIView animateWithDuration:self.duration animations:^{
            self->_showView.frame = lastFrame;
        } completion:^(BOOL finished) {

            [self removeAllView];
        }];
    }
    
}

/**
 移除所有视图
 */
- (void)removeAllView{
    
    [self.showView removeFromSuperview];
    self.showVC = nil;
    [[[self class] shareSelectView] removeFromSuperview];
    self.alpha = 1.0f;
}
@end

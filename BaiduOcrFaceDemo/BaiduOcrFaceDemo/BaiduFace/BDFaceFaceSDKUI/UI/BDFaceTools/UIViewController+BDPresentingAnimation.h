//
//  UIViewController+BDPresentingAnimation.h
//  controllerManagerPresent
//
//  Created by Zhang,Jian(MBD) on 2021/5/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (BDPresentingAnimation)

- (void)bdpresent_saveControllerImage;

- (void)bdpresent_presentViewController:(UIViewController *)controller
                           bgController:(nullable Class)bgControllerClass
                               animated:(BOOL)flag
                             completion:(nullable void (^)(void))completion;

- (void)bdpresent_dismissViewControllerAnimated:(BOOL)flag
                                   bgController:(nullable Class)bgControllerClass
                                     completion:(nullable void (^)(void))completion;

- (void)bdpresent_dismissToViewController:(nullable Class)desControllerClass
                                 animated:(BOOL)flag
                             bgController:(nullable Class)bgControllerClass
                               completion:(nullable void (^)(void))completion;

- (void)bdpresent_popAndPush:(nullable Class)popToControllerClass
              pushController:(UIViewController *)controller
                    animated:(BOOL)flag
                bgController:(nullable Class)bgControllerClass
                  completion:(nullable void (^)(void))completion;

- (void)bdpresent_popToLastAndPushController:(UIViewController *)controller
                                    animated:(BOOL)flag
                                  completion:(nullable void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END

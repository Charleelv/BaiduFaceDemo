//
//  UIViewController+BDPresentingAnimation.m
//  controllerManagerPresent
//
//  Created by Zhang,Jian(MBD) on 2021/5/7.
//

#import "UIViewController+BDPresentingAnimation.h"
#import <QuartzCore/QuartzCore.h>

@interface BDPresentingManger : NSObject

@property(nonatomic, strong) NSMutableDictionary *dic;

+ (instancetype)sharedInstance;

@end

@implementation BDPresentingManger

+ (instancetype)sharedInstance {
    static BDPresentingManger *manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[BDPresentingManger alloc] init];
    });
    return manger;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end

@implementation UIViewController (BDPresentingAnimation)

- (UIImage *)currentScreenShot {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

- (void)bdpresent_saveControllerImage {
    if (self.view) {
        NSString *key = NSStringFromClass(self.class);
        UIImage *image = [self currentScreenShot];
        if (image
            && key
            && [key isKindOfClass:[NSString class]]) {
            [[BDPresentingManger sharedInstance].dic setObject:image
                                                        forKey:key];
        }
    }
}

- (void)bdpresent_presentViewController:(UIViewController *)controller
                           bgController:(nullable Class)bgControllerClass
                               animated:(BOOL)flag
                             completion:(nullable void (^)(void))completion {
    [self bdpresent_saveControllerImage];
    UIImage *image = [[BDPresentingManger sharedInstance].dic objectForKey:NSStringFromClass(bgControllerClass)];
    if (image) {
        __block UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.image = image;
        [self.view addSubview:imageView];
        [self presentViewController:controller animated:flag completion:^{
            if (completion) {
                completion();
            }
            [imageView removeFromSuperview];
            imageView = nil;
        }];
    } else {
        [self presentViewController:controller animated:flag completion:completion];
    }
    
}

- (void)bdpresent_dismissViewControllerAnimated:(BOOL)flag
                                   bgController:(nullable Class)bgControllerClass
                                     completion:(nullable void (^)(void))completion {
    [self bdpresent_saveControllerImage];
    UIImage *image = [[BDPresentingManger sharedInstance].dic objectForKey:NSStringFromClass(bgControllerClass)];
    if (image) {
        __block UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.image = image;
        [self.presentedViewController.view addSubview:imageView];
        [self dismissViewControllerAnimated:flag completion:^{
            if (completion) {
                completion();
            }
            [imageView removeFromSuperview];
            imageView = nil;
        }];
    } else {
        [self dismissViewControllerAnimated:flag completion:completion];
    }
    
}

- (void)bdpresent_dismissToViewController:(nullable Class)desControllerClass
                                 animated:(BOOL)flag
                             bgController:(nullable Class)bgControllerClass
                               completion:(nullable void (^)(void))completion {
    [self bdpresent_saveControllerImage];
    if (desControllerClass == self.class) {
        // 是当前的controller
        [self bdpresent_dismissViewControllerAnimated:flag bgController:bgControllerClass completion:completion];
        return;
    } else {
        // 不是当前controller
        BOOL find = NO;
        UIViewController *current = self;
        while (current.presentingViewController) {
            current = current.presentingViewController;
            if (current.class == desControllerClass) {
                find = YES;
                break;
            }
        }
        if (find) {
            [current bdpresent_dismissToViewController:desControllerClass animated:flag bgController:bgControllerClass completion:completion];
        }
    }
}

- (void)bdpresent_popAndPush:(nullable Class)popToControllerClass
              pushController:(UIViewController *)controller
                    animated:(BOOL)flag
                bgController:(nullable Class)bgControllerClass
                  completion:(nullable void (^)(void))completion {
    [self bdpresent_saveControllerImage];
    UIViewController *current = nil;
    if (popToControllerClass == self.class) {
        current = self;
    } else {
        BOOL find = NO;
        current = self;
        while (current.presentingViewController) {
            current = current.presentingViewController;
            if (current.class == popToControllerClass) {
                find = YES;
                break;
            }
        }
        if (!find) {
            current = nil;
        }
    }
    if (!current) {
        return;
    }
    UIImage *image = [[BDPresentingManger sharedInstance].dic objectForKey:NSStringFromClass(bgControllerClass)];
    if (image) {
        __block UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.image = image;
        [current.view addSubview:imageView];
        [current dismissViewControllerAnimated:NO completion:^{
            [current presentViewController:controller animated:flag completion:^{
                if (completion) {
                    completion();
                }
                [imageView removeFromSuperview];
                imageView = nil;
            }];
        }];
        
        
    } else {
        [current dismissViewControllerAnimated:NO completion:^{
            [current presentViewController:controller animated:flag completion:completion];
        }];
    }
    
}

- (void)bdpresent_popToLastAndPushController:(UIViewController *)controller
                                    animated:(BOOL)flag
                                  completion:(nullable void (^)(void))completion {
    [self bdpresent_saveControllerImage];
    UIViewController *last = self.presentingViewController;
    UIImage *image = [[BDPresentingManger sharedInstance].dic objectForKey:NSStringFromClass(self.class)];
    if (image) {
        __block UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.image = image;
        [last.view addSubview:imageView];
        [last dismissViewControllerAnimated:NO completion:^{
            [last presentViewController:controller animated:flag completion:^{
                if (completion) {
                    completion();
                }
                [imageView removeFromSuperview];
                imageView = nil;
            }];
        }];
    } else {
        [last dismissViewControllerAnimated:NO completion:^{
            [last presentViewController:controller animated:flag completion:completion];
        }];
    }
}

@end

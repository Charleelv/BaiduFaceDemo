//
//  AppDelegate.m
//  BaiduOcrFaceDemo
//
//  Created by CharlieLv on 2024/5/14.
//

#import "AppDelegate.h"
#import "FaceViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FaceViewController * faceVC = [[FaceViewController alloc]init];
    self.window.rootViewController = faceVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}



@end

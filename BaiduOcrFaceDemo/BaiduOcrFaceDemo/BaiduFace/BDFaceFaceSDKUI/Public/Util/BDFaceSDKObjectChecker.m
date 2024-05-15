//
//  BDFaceSDKObjectChecker.m
//  IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/1/12.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "BDFaceSDKObjectChecker.h"

@implementation BDFaceSDKObjectChecker

+ (BOOL)dicIsNotNull:(NSDictionary *)dic {
    if ([dic isKindOfClass:[NSDictionary class]]
        && dic.allKeys.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

@end

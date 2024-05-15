//
//  BDShootingRequireView.h
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by v_bihongvwei on 2021/10/13.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BDAlertViewDelegate <NSObject>

-(void)closeCurrentPage;

@end

@interface BDShootingRequireView : UIView

@property(nonatomic, weak)id<BDAlertViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

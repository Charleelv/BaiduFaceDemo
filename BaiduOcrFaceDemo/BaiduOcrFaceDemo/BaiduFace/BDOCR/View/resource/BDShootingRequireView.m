//
//  BDShootingRequireView.m
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by v_bihongvwei on 2021/10/13.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "BDShootingRequireView.h"

@implementation BDShootingRequireView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *v = [[[NSBundle mainBundle] loadNibNamed:@"ShootingRequireView" owner:self options:0] lastObject];
        v.frame = frame;
        [self addSubview:v];
    }
    return self;
}

- (IBAction)sureButtonAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeCurrentPage)]) {
        
        [self.delegate closeCurrentPage];
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

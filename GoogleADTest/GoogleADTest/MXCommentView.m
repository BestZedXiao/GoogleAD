//
//  MXCommentView.m
//  GoogleADTest
//
//  Created by rbt-Macmini on 2018/1/5.
//  Copyright © 2018年 Mr.Xiao. All rights reserved.
//
#define WIDTH [UIScreen mainScreen].bounds.size.width/2
#define HEIGHT 200

#import "MXCommentView.h"

@implementation MXCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
}
@end

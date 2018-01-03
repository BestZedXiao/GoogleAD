//
//  MXGoogleADController.h
//  GoogleAD
//
//  Created by rbt-Macmini on 2018/1/3.
//  Copyright © 2018年 Mr.Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXGoogleADController : UIViewController

//展示全屏广告
- (void)showInterstitial;

//重写此方法 可调整banner广告距屏幕下端的高度  默认为0  在最下端 
- (CGFloat)adjustHeightWithBannerDistanceBoom;

@end

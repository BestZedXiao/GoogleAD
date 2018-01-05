//
//  MXGoogleADController.h
//  GoogleAD
//
//  Created by Mr.Xiao on 2018/1/3.
//  Copyright © 2018年 Mr.Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 <1>. 推荐使用cocoapods 导入 pod 'Firebase/AdMob'
 
 <2>.使用此广告 请将 四个文件拖入项目中  需要的地方继承 MXGoogleADController
 
 EG:
 @interface DemoController : MXGoogleADController
 
 <3>.在AppDelegate.m 中重写 下面方法  并添加相关的  广告单元的adUnit
 此例中的广告单元为测试广告单元 仅作为测试使用  实际使用请去  https://apps.admob.com  申请
 上架之前请务必替换成真实广告单元 测试过程中 请勿使用真实的广告单元 在未上架的情况 多次点击(会产品广告费用-->>>当然钱 到你的账户下面) 会导致谷歌封号 也可自行判断 不再累述
 
 EG:
 + (void)initialize{
 
 #ifdef DEBUG
 //测试广告单元
 [MXGoogleManager shareInstance].adUnitIBanner = @"ca-app-pub-3940256099942544/2934735716";
 [MXGoogleManager shareInstance].adUnitIDInterstitial = @"ca-app-pub-3940256099942544/4411468910";
 
 #else
 //真实广告单元
 [MXGoogleManager shareInstance].adUnitIBanner = @"ca-app-pub-3940256099942544/2934735716";
 [MXGoogleManager shareInstance].adUnitIDInterstitial = @"ca-app-pub-3940256099942544/4411468910";
 
 #endif
 
 //应用APPID
 [MXGoogleManager shareInstance].appleID = @"393765873";
 //界面切换次数 弹出全屏广告广告
 [MXGoogleManager shareInstance].switchCount = 8;
 
 
 }
 
 本人  QQ 1012063644  欢迎共同探讨相关的技术和知识
 
 */

@interface MXGoogleADController : UIViewController

//===================  banner 横幅广告  ===================

//重写此方法 自定义是否显示banner广告 (默认显示广告)
- (BOOL)isShowBanner;

//重写此方法 可调整banner广告距屏幕下端的高度  默认为0  在最下端
- (CGFloat)adjustHeightWithBannerDistanceBoom;


//=================  interstitial 全屏广告  ==================

//重写此方法 自定义是否显示interstital广告 (默认显示广告)
- (BOOL)isShowInsterstitial;

//展示全屏广告
- (void)showInterstitial;

//跳到appStore评论页
- (void)skipToAppStoreComment;

//跳到appStore 应用详情页
- (void)skipToAppStoreDetail;


@end

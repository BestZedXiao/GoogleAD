//
//  MXGoogleADController.m
//  GoogleAD
//
//  Created by Mr.Xiao on 2018/1/3.
//  Copyright © 2018年 Mr.Xiao. All rights reserved.
//

#define iOS11_0Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)

#define KEY_SWITCH_COUNT_AD @"keyAD"
#define KEY_SWITCH_COUNT_COMMENT @"keyComment"

#import "MXGoogleADController.h"
#import "MXGoogleManager.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "AppDelegate.h"
#import "MXCommentView.h"

@interface MXGoogleADController ()<GADInterstitialDelegate>

@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, strong) GADRequest *requset;

@property (nonatomic, assign) NSInteger switchCount;

/**
 测试设备ID号 如广告未展示出来 请在一下数组添加 设备号会在log窗有打印 请找到 粘贴进来
 真机需要添加 模拟器请无视
 */
@property (nonatomic, strong) NSArray *testDevices;

@end

@implementation MXGoogleADController


-(GADBannerView *)bannerView{
    if (_bannerView == nil) {
        if ([self isRootControllerWithTabbarController] == YES) {
            _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0,[UIScreen mainScreen].bounds.size.height- [self getSizeFromBannerGADSize] -[self adjustHeightWithBannerDistanceBoom]- 49)];
        }else{
            _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0,[UIScreen mainScreen].bounds.size.height- [self getSizeFromBannerGADSize] -[self adjustHeightWithBannerDistanceBoom])];
        }
        _bannerView.adUnitID = [MXGoogleManager shareInstance].adUnitIBanner;
        _bannerView.rootViewController = self;
        [_bannerView loadRequest:self.requset];
    }
    return _bannerView;
}

- (GADInterstitial *)creatNewInterstitial{
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:[MXGoogleManager shareInstance].adUnitIDInterstitial];
    interstitial.delegate = self;
    [interstitial loadRequest:self.requset];
    return interstitial;
}

-(GADRequest *)requset{
    if (_requset == nil) {
        _requset = [GADRequest request];
        _requset.testDevices = self.testDevices;
    }
    return _requset;
}

#pragma mark --------->>>>>>>>>> (来这里添加测试设备号，模拟器请无视)
//测试设备ID号 如广告未展示出来 请在一下数组添加 设备号会在log窗有打印 请找到 粘贴进来
//真机需要添加 模拟器请无视
- (NSArray *)testDevices{
    return @[kGADSimulatorID,@"00922d2eb7811f0b4fbfd06e5788c8a6"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _switchCount = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_SWITCH_COUNT_AD];
    _switchCount++;
//    NSLog(@"%ld",(long)_switchCount);

    if (_switchCount%[MXGoogleManager shareInstance].switchVCShowAD == 0) {
        [self showInterstitial];
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSUserDefaults standardUserDefaults] setInteger:_switchCount forKey:KEY_SWITCH_COUNT_AD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self isShowBanner] == YES) {
        [self.view addSubview:self.bannerView];
    }

    if ([self isShowInsterstitial] == YES) {
        self.interstitial = [self creatNewInterstitial];
    }
}

#pragma mark ===================  banner 横幅广告  ===================


//重写此方法 自定义是否显示banner广告 (默认显示广告)
- (BOOL)isShowBanner{
    return YES;
}

//此处可选择 banner展示的高度 (默认 手机50X 平板90X 正常情况无需改变)
- (CGFloat)getSizeFromBannerGADSize{
    return CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height;
}

//重写此方法 可调整banner广告距屏幕下端的高度  默认为0  在最下端
- (CGFloat)adjustHeightWithBannerDistanceBoom{
    return 0;
}

#pragma mark =================  interstitial 全屏广告  ==================

//重写此方法 自定义是否显示interstital广告 (默认显示广告)
- (BOOL)isShowInsterstitial{
    return YES;
}

//展示全屏广告
- (void)showInterstitial{
    if (self.interstitial.isReady) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [self.interstitial presentFromRootViewController:delegate.window.rootViewController];
    }
}

//判断根视图是否 有tabbar 防止tabbar 遮挡banner广告
- (BOOL)isRootControllerWithTabbarController{
    
    return [(UITabBarController *)self.tabBarController isKindOfClass:[UITabBarController class]];
}

#pragma mark -- 全屏广告代理方法
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    NSLog(@"广告已经接受到了");
    
}

-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"广告接受失败");
}

-(void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    NSLog(@"广告将要弹出来了");
}

-(void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad{
    NSLog(@"广告弹出失败");
}

-(void)interstitialWillDismissScreen:(GADInterstitial *)ad{
    NSLog(@"广告将要消失");
}

-(void)interstitialDidDismissScreen:(GADInterstitial *)ad{
//    _switchCount = 0;
    NSLog(@"广告已经消失了");
    if (self.interstitial.hasBeenUsed && [self isShowInsterstitial]) {
        self.interstitial = [self creatNewInterstitial];
    }
}

-(void)interstitialWillLeaveApplication:(GADInterstitial *)ad{
    NSLog(@"广告将要离开应用");
}


#pragma mark --------->>>>>>>>>> 评论系统
//跳到appStore评论页
- (void)skipToAppStoreComment{
    if (iOS11_0Later) {
        NSString *itunesurl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8&action=write-review",[MXGoogleManager shareInstance].appleID];
//        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly
//                                  :@(YES)};
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl] options:nil completionHandler:^(BOOL success) {
            NSLog(@"将要进入 App Store 页面了");
        }];
    }else{
        
        NSString *itunesurl = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",[MXGoogleManager shareInstance].appleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
    }
}

//跳到appStore 应用详情页
- (void)skipToAppStoreDetail{
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", [MXGoogleManager shareInstance].appleID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}
@end

//
//  MXGoogleADController.m
//  GoogleAD
//
//  Created by rbt-Macmini on 2018/1/3.
//  Copyright © 2018年 Mr.Xiao. All rights reserved.
//

#import "MXGoogleADController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface MXGoogleADController ()<GADInterstitialDelegate>

@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, strong) GADRequest *requset;

@end

@implementation MXGoogleADController

-(GADBannerView *)bannerView{
    if (_bannerView == nil) {
        _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0, [self adjustHeightWithBannerDistanceBoom])];
        _bannerView.adUnitID = @"ca-app-pub-8621793235050362/7333894931";
        _bannerView.rootViewController = self;
    }
    return _bannerView;
}

- (GADInterstitial *)creatNewInterstitial{
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-8621793235050362/7333894931"];
    interstitial.delegate = self;
    [interstitial loadRequest:self.requset];
    return interstitial;
}

-(GADRequest *)requset{
    if (_requset == nil) {
        _requset = [GADRequest request];
        _requset.testDevices = @[@"00922d2eb7811f0b4fbfd06e5788c8a6"];
    }
    return _requset;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.bannerView];
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[@"00922d2eb7811f0b4fbfd06e5788c8a6",kGADSimulatorID];
    [self.bannerView loadRequest:request];
    
    self.interstitial = [self creatNewInterstitial];
    
}

//重写此方法 可调整banner广告距屏幕下端的高度  默认为0  在最下端
- (CGFloat)adjustHeightWithBannerDistanceBoom{
    return 0;
}

//展示全屏广告
- (void)showInterstitial{
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    }
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
    NSLog(@"广告已经消失了");
    if (self.interstitial.hasBeenUsed) {
        self.interstitial = [self creatNewInterstitial];
    }
}

-(void)interstitialWillLeaveApplication:(GADInterstitial *)ad{
    NSLog(@"广告将要离开应用");
}

@end

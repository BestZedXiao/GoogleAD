//
//  ViewController.m
//  GoogleAD
//
//  Created by rbt-Macmini on 2017/12/28.
//  Copyright © 2017年 Mr.Xiao. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController ()<GADInterstitialDelegate>

@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, strong) GADRequest *requset;
@end

@implementation ViewController

- (GADInterstitial *)creatNewInterstital{
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
//    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0, 300)];
//    self.bannerView.adUnitID = @"ca-app-pub-8621793235050362/7333894931";
//    self.bannerView.rootViewController = self;
//    [self.view addSubview:self.bannerView];
//
//    GADRequest *request = [GADRequest request];
//    request.testDevices = @[@"00922d2eb7811f0b4fbfd06e5788c8a6"];
//    [self.bannerView loadRequest:request];
    
    self.interstitial = [self creatNewInterstital];
}

- (IBAction)showAD:(UIButton *)sender {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    }
}


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
       self.interstitial = [self creatNewInterstital];
    }
}

-(void)interstitialWillLeaveApplication:(GADInterstitial *)ad{
    NSLog(@"广告将要离开应用");
}




@end

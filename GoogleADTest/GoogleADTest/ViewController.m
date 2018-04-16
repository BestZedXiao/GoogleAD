//
//  ViewController.m
//  GoogleADTest
//
//  Created by Mr.Xiao on 2018/1/3.
//  Copyright © 2018年 Mr.Xiao. All rights reserved.
//

#import "ViewController.h"
#import <SafariServices/SafariServices.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}



- (IBAction)click:(UIButton *)sender {
    [self showInterstitial];
}

- (IBAction)clickToAppleStore:(UIButton *)sender {
//    [self skipToAppStoreComment];
//    NSURL *url = [NSURL URLWithString:@"text123://"];
//    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//        [[UIApplication sharedApplication] openURL:url];
//    };
    NSURL *url = [NSURL URLWithString:@"https://www.invasivecode.com"];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
    [self showViewController:safariVC sender:nil];
}

- (IBAction)detail:(UIButton *)sender {
    [self skipToAppStoreDetail];
}


-(CGFloat)adjustHeightWithBannerDistanceBoom{
    return 0;
}

@end

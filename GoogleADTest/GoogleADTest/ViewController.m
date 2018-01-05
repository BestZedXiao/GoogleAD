//
//  ViewController.m
//  GoogleADTest
//
//  Created by Mr.Xiao on 2018/1/3.
//  Copyright © 2018年 Mr.Xiao. All rights reserved.
//

#import "ViewController.h"

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
    [self skipToAppStoreComment];
}

- (IBAction)detail:(UIButton *)sender {
    [self skipToAppStoreDetail];
}


-(CGFloat)adjustHeightWithBannerDistanceBoom{
    return 0;
}

@end

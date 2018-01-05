//
//  AppDelegate.m
//  GoogleADTest
//
//  Created by Mr.Xiao on 2018/1/3.
//  Copyright © 2018年 Mr.Xiao. All rights reserved.
//

#import "AppDelegate.h"
#import "MXGoogleManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)initialize{
    
    //banner广告单元
    [MXGoogleManager shareInstance].adUnitIBanner = @"ca-app-pub-3940256099942544/2934735716";
    //全屏广告单元
    [MXGoogleManager shareInstance].adUnitIDInterstitial = @"ca-app-pub-3940256099942544/4411468910";
    //应用APPID
    [MXGoogleManager shareInstance].appleID = @"393765873";
    //界面切换次数 弹出全屏广告(默认8次 重写此方法可修改次数)
    [MXGoogleManager shareInstance].switchVCShowAD = 5;
    //界面切换次数 弹出去评论窗口(默认10次 重写此方法可修改次数)
    [MXGoogleManager shareInstance].switchVCShowComment = 10;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

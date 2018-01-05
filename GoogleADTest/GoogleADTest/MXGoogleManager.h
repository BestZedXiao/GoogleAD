//
//  MXGoogleManager.h
//  GoogleAD
//
//  Created by Mr.Xiao on 2018/1/2.
//  Copyright © 2018年 Mr.Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXGoogleManager : NSObject

@property (nonatomic, copy) NSString *adUnitIBanner;

@property (nonatomic, copy) NSString *adUnitIDInterstitial;

@property (nonatomic, copy) NSString *appleID;

@property (nonatomic, assign) NSInteger switchVCShowAD;

@property (nonatomic, assign) NSInteger switchVCShowComment;


+ (instancetype) shareInstance;

@end

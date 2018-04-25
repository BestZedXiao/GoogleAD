//
//  MXGoogleADController.m
//  GoogleAD
//
//  Created by Mr.Xiao on 2018/1/3.
//  Copyright © 2018年 Mr.Xiao. All rights reserved.
//

#define iOS11_0Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)
#define IPHONEX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))


#define KEY_SWITCH_COUNT_AD @"keyAD"
#define KEY_SWITCH_COUNT_COMMENT @"keyComment"

#import "MXGoogleADController.h"
#import "MXGoogleManager.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <StoreKit/StoreKit.h>
#import "AppDelegate.h"
#import "MXCommentView.h"

@interface MXGoogleADController ()<GADInterstitialDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate>

@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, strong) GADRequest *requset;

@property (nonatomic, assign) NSInteger switchCount;

@property (nonatomic, copy) NSString *productID;

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
            _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0,[UIScreen mainScreen].bounds.size.height- [self getSizeFromBannerGADSize] -[self adjustHeightWithBannerDistanceBoom]- [self getTabbarHeight])];
        }else{
            _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0,[UIScreen mainScreen].bounds.size.height- [self getSizeFromBannerGADSize] -[self adjustHeightWithBannerDistanceBoom])];
        }
        _bannerView.adUnitID = [MXGoogleManager shareInstance].adUnitIBanner;
        _bannerView.rootViewController = self;
        [_bannerView loadRequest:[self requset]];
    }
    return _bannerView;
}

/*当成功调用了一下GADInterstitial的presentFromRootViewController展示插屏广告之后。下次如果这个对象只调用loadRequest来请求新的广告，在下次显示广告时，日志会提示：
    Request Error: Will not send request because interstitial object has been used.
 
解决方法：重新再实例化一个新的GADInterstital对象，然后发送请求。具体初始化代码可以参考上面
 
 找了半天问题  解决方法是 重复初始化GADRequest  之前确实是初始化了interstittal 但是发现request没有初始化 所以广告弹出依然有问题
 */
- (GADInterstitial *)creatNewInterstitial{
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:[MXGoogleManager shareInstance].adUnitIDInterstitial];
    interstitial.delegate = self;
    [interstitial loadRequest:[self requset]];
    return interstitial;
}

-(GADRequest *)requset{
    GADRequest *request = [GADRequest request];
    request.testDevices = self.testDevices;
    return request;
}

//获取tabbar的高度 适配下iPhone X的高度
- (CGFloat)getTabbarHeight{
    if (IPHONEX) {
        return 49.0f+34.0f;
    }else{
        return 49.0f;
    }
}

#pragma mark --------->>>>>>>>>> (来这里添加测试设备号，模拟器请无视)
//测试设备ID号 如广告未展示出来 请在以下数组中添加 设备号会在log窗有打印 请找到 粘贴进来
//真机需要添加 模拟器请无视
- (NSArray *)testDevices{
    return @[kGADSimulatorID,@"00922d2eb7811f0b4fbfd06e5788c8a6"];
}

#pragma mark -VIEWLOAD
- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
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
    
    // app从后台进入前台都会调用这个方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 添加检测app进入后台的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    
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
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [self.interstitial presentFromRootViewController:window.rootViewController];
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
    if (self.interstitial.hasBeenUsed && [self isShowInsterstitial]) {
        self.interstitial = [self creatNewInterstitial];
    }
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

#pragma mark --------->>>>>>>>>> 监听系统前后台切换
//应用进入后台
- (void)applicationEnterBackground{
    NSLog(@"应用进入后台");
}

//应用来到前台
- (void)applicationBecomeActive{
    if (self.isShowInsterstitial) {
        [self showInterstitial];
    }
    NSLog(@"应用进入前台，可以展示广告了");
}

#pragma mark ===================  内购去广告  ===================

#pragma mark - 内购
//内购ID
- (NSString *)productID{
    if (_productID == nil) {
        _productID = [MXGoogleManager shareInstance].productID;
    }
    return _productID;
}

- (void)clickPhures{
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"花费6元购买去广告" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([SKPaymentQueue canMakePayments]){
            [self requestProductData:self.productID];
        }else{
            NSLog(@"不允许程序内付费");
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"已购买直接去广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息----------------");
    NSArray *product = [[NSArray alloc] initWithObjects:type,nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"描述信息：%@", [pro description]);
        NSLog(@"产品标题：%@", [pro localizedTitle]);
        NSLog(@"产品描述信息：%@", [pro localizedDescription]);
        NSLog(@"价格：%@", [pro price]);
        NSLog(@"内购ID：%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:self.productID]){
            p = pro;
        }
    }
    
    if (p != nil) {
        SKPayment *payment = [SKPayment paymentWithProduct:p];
        
        NSLog(@"发送购买请求");
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
}
//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 *
 */
-(void)verifyPurchaseWithPaymentTransaction{
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];

    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串

    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];


    //创建请求到苹果官方进行购买验证
    NSURL *url=[NSURL URLWithString:SANDBOX];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody = bodyData;
    requestM.HTTPMethod = @"POST";
    //创建连接并发送同步请求
    NSError *error=nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",dic);
    if([dic[@"status"] intValue]==0){
        NSLog(@"购买成功！");

        NSDictionary *dicReceipt= dic[@"receipt"];
        NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
        NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
        //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        if ([productIdentifier isEqualToString:self.productID]) {
            [defaults setBool:YES forKey:productIdentifier];
        }else{
            NSInteger purchasedCount = [defaults integerForKey:productIdentifier];//已购买数量
            [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
        }
        //在此处对购买记录进行存储，可以存储到开发商的服务器端
    }else{
        NSLog(@"购买失败，未通过验证！");
    }
}
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    
    
    for(SKPaymentTransaction *tran in transaction){
        NSLog(@"打印购买错误日志---%@",tran.error.description);
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                NSLog(@"交易完成");
                [self verifyPurchaseWithPaymentTransaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
            }
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:{
                NSLog(@"已经购买过商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            }
                break;
            case SKPaymentTransactionStateFailed:{
                NSLog(@"交易失败");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            }
            case SKPaymentTransactionStateDeferred:{
                NSLog(@"交易还在队列里面，但最终状态还没有决定");
                break;
            }
            default:
                break;
        }
    }
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


@end

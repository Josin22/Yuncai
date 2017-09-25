//
//  AppDelegate.m
//  YBL365
//
//  Created by 乔同新 on 2016/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "AppDelegate.h"
#import "YBLTabBarViewController.h"
#import "YBLAPPViewModel.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLStoreViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "YBLFoundTabBarViewController.h"
#import "YBLPurchaseGoodsDetailVC.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLStoreViewController.h"
#import "YBLPurchaseOutPriceRecordsVC.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "YBLOrderDetailViewController.h"
#import "YBLSignalHandler.h"
#import "YBLStoreFollowViewController.h"
#if DEBUG
//#import <FBMemoryProfiler/FBMemoryProfiler.h>
#endif

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>

#if DEBUG
//@property (nonatomic , strong) FBMemoryProfiler * memoryProfiler;
#endif

@end

@implementation AppDelegate

//当用户通过点击通知消息进入应用时
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#if DEBUG
    id overlayClass = NSClassFromString(@"UIDebuggingInformationOverlay");
    [overlayClass performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
#endif
    /* APP Start ViewModel */
    YBLAPPViewModel *appViewModel = [YBLAPPViewModel shareApp];
    //设置
    [appViewModel finishLaunchOption:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.layer.cornerRadius = 5;
    self.window.layer.masksToBounds = YES;
    YBLTabBarViewController *tabBarVC = [[YBLTabBarViewController alloc] init];
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    
    BOOL isProduction = NO;
#ifdef DEBUG
    isProduction = NO;
//    self.memoryProfiler = [[FBMemoryProfiler new] initWithPlugins:nil retainCycleDetectorConfiguration:nil];
//    [self.memoryProfiler enable];
#else
    isProduction = YES;
#endif

    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
//    NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    // Required
    [JPUSHService setupWithOption:launchOptions
                           appKey:Jiguang_Key
                          channel:@"App Store"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //Signal handle
//    [YBLSignalHandler RegisterSignalHandler];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [self cleanNotNum];
}

- (void)cleanNotNum{
    [JPUSHService resetBadge];
    [YBLMethodTools cleanNotificationNumber];
}

#pragma mark Notification
//应用在后台运行
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}
/**
 *  推送
 */
#pragma mark- JPUSHRegisterDelegate // 2.1.9版新增JPUSHRegisterDelegate,需实现以下两个方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center  willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else {
        // 本地通知
    }
//    [self handlePushApsDict:userInfo];
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler: (void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else {
        // 本地通知
    }
    [self handlePushApsDict:userInfo];
    completionHandler();  // 系统要求执行这个方法
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
/**
 *  处理推送
 *
 *  @param userInfo aps
 */
- (void)handlePushApsDict:(NSDictionary *)userInfo{
    
    // 取得 APNs 标准信息内容
    NSLog(@"推送userInfo:%@",userInfo);
    [self cleanNotNum];
    
    NSString *type = userInfo[@"type"];
    NSDictionary *vc_dict = @{@"order":@"YBLOrderDetailViewController",
                              @"purchase_order":@"YBLPurchaseGoodsDetailVC",
                              @"follow_shop_pay":@"YBLStoreViewController",
                              @"follow_shop":@"YBLStoreFollowViewController",
                              @"follow_options":@"YBLStoreViewController",
                              @"comment":@"YBLGoodsDetailViewController",
                              @"follow_product":@"YBLGoodsDetailViewController",
                              @"cart":@"YBLGoodsDetailViewController",};
    NSString *class_name = vc_dict[type];
    Class vc_class = NSClassFromString(class_name);
    UINavigationController *navVc = [[YBLAPPViewModel shareApp] getNavigationCWithWindow:self.window];
    if ([navVc.visibleViewController isKindOfClass:vc_class]) {
        return;
    }
    if ([type isEqualToString:@"order"]) {
        NSString *orderID = userInfo[@"data"][@"order_id"];
        YBLOrderItemModel *orderModel = [YBLOrderItemModel new];
        orderModel.order_id = orderID;
        YBLOrderDetailViewModel *detailVM = [YBLOrderDetailViewModel new];
        detailVM.itemDetailModel = orderModel;
        detailVM.orderSource = OrderSourceSeller;
        YBLOrderDetailViewController *detailVC = [YBLOrderDetailViewController new];
        detailVC.viewModel = detailVM;
        [navVc pushViewController:detailVC animated:YES];
    } else if ([type isEqualToString:@"purchase_order"]) {
        NSString *purchaseOrderID = userInfo[@"data"][@"purchase_order_id"];
        YBLPurchaseGoodDetailViewModel *viewModel = [YBLPurchaseGoodDetailViewModel new];
        YBLPurchaseOrderModel *purchseModel = [YBLPurchaseOrderModel new];
        purchseModel._id = purchaseOrderID;
        viewModel.purchaseDetailModel = purchseModel;
        YBLPurchaseGoodsDetailVC *detailVC = [[YBLPurchaseGoodsDetailVC alloc] init];
        detailVC.viewModel = viewModel;
        [navVc pushViewController:detailVC animated:YES];
    } else if ([type isEqualToString:@"follow_shop_pay"]||[type isEqualToString:@"follow_options"]){
        NSString *shop_id = userInfo[@"data"][@"shop_id"];
        YBLStoreViewModel *viewModel = [YBLStoreViewModel new];
        viewModel.shopid = shop_id;
        YBLStoreViewController * storeVC = [[YBLStoreViewController alloc]init];
        storeVC.viewModel = viewModel;
        [navVc pushViewController:storeVC animated:YES];
    } else if ([type isEqualToString:@"follow_shop"]){
        YBLStoreFollowViewController *myVC = [YBLStoreFollowViewController new];
        [navVc pushViewController:myVC animated:YES];
    } else if ([type isEqualToString:@"comment"]||[type isEqualToString:@"follow_product"]||[type isEqualToString:@"cart"]){
        NSString *url_id = userInfo[@"data"][@"product_id"];
        YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
        viewModel.goodID = url_id;
        YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
        goodDetailVC.viewModel = viewModel;
        [navVc pushViewController:goodDetailVC animated:YES];
    }
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    NSLog(@"deviceToken:%@",deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        [[NSUserDefaults standardUserDefaults]setObject:registrationID forKey:@"registrationID"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }];

}

#pragma mark - handle url
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(nullable NSString *)sourceApplication
         annotation:(id)annotation{
    return [self handleURL:url];
}

//iOS 9 after
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [self handleURL:url];
}
//iOS 9 later
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options
{
    BOOL result = [WXApi handleOpenURL:url delegate:self];
    if (result == NO) {
        return [self handleURL:url];
    }
    return result;

}

- (BOOL)handleURL:(NSURL *)url {
    
//    NSString *host = [url host];
//    NSString *scheme = [url scheme];
//    NSString *absoluteString = [url absoluteString];
    if(!url){
        return NO;
    }
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([WXApi handleOpenURL:url delegate:self]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

#pragma mark 微信结果回调

- (void)onResp:(BaseResp *)resp{
    
    if([resp isKindOfClass:[PayResp class]]){
        BOOL result = NO;
        switch (resp.errCode) {
            case WXSuccess:{
                result = YES;
            }
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:WX_PAY_NOTIFICATION_NAME object:nil userInfo:@{@"result":@(result)}];
    }
    
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    NSLog(@"activityType  is %@",userActivity.activityType);
    NSLog(@"title  is %@",userActivity.title);
    NSLog(@"userInfo  is %@",userActivity.userInfo);
    NSLog(@"webpageURL  is %@",userActivity.webpageURL);
    NSLog(@"keywords  is %@",userActivity.keywords);
//    NSLog(@"contentAttributeSet is %@",userActivity.contentAttributeSet.title);
//    NSLog(@"contentAttributeSet is %@",userActivity.contentAttributeSet.subject);
//    NSLog(@"contentAttributeSet is %@",userActivity.contentAttributeSet.theme);
    
    if([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]){
        // 跳转 app 方式
        NSURL *webUrl = userActivity.webpageURL;
        if ([webUrl.host isEqualToString:@"kuaiyiyuncai.cn"]||[webUrl.host isEqualToString:@"www.kuaiyiyuncai.cn"]) {
            //判断域名 打开对应页面
            NSArray *componeArray = [webUrl.absoluteString componentsSeparatedByString:@"@"];
            NSLog(@"componeArray:%@",componeArray);
            NSString *url_type = componeArray[1];
            NSString *url_id   = componeArray[2];
            NSDictionary *vc_dict = @{@"all":@"YBLFoundTabBarViewController",@"cg":@"YBLPurchaseGoodsDetailVC",@"sp":@"YBLGoodsDetailViewController",@"dp":@"YBLStoreViewController"};
            NSString *class_name = vc_dict[url_type];
            Class vc_class = NSClassFromString(class_name);
            UINavigationController *navVc = [[YBLAPPViewModel shareApp] getNavigationCWithWindow:self.window];
            if ([navVc.visibleViewController isKindOfClass:vc_class]) {
                return YES;
            }
            if (![YBLUserManageCenter shareInstance].isLoginStatus||[url_type isEqualToString:@"cg"]) {
                
                YBLFoundTabBarViewController *foundVC = [YBLFoundTabBarViewController new];
                [navVc pushViewController:foundVC animated:YES];
                
                return YES;
            }
            if ([url_type isEqualToString:@"all"]) {
                //采购首页
                YBLFoundTabBarViewController *foundVC = [YBLFoundTabBarViewController new];
                [navVc pushViewController:foundVC animated:YES];
                
            } else if ([url_type isEqualToString:@"cg"]) {
                //采购商品
                YBLPurchaseGoodDetailViewModel *viewModel = [YBLPurchaseGoodDetailViewModel new];
                YBLPurchaseOrderModel *purchseModel = [YBLPurchaseOrderModel new];
                purchseModel._id = url_id;
                viewModel.purchaseDetailModel = purchseModel;
                YBLPurchaseGoodsDetailVC *detailVC = [[YBLPurchaseGoodsDetailVC alloc] init];
                detailVC.viewModel = viewModel;
                [navVc pushViewController:detailVC animated:YES];
                
            } else if ([url_type isEqualToString:@"sp"]) {
                //商品详情
                YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
                viewModel.goodID = url_id;
                YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
                goodDetailVC.viewModel = viewModel;
                [navVc pushViewController:goodDetailVC animated:YES];
                
            } else if ([url_type isEqualToString:@"dp"]) {
                //店铺
                YBLStoreViewModel *viewModel = [YBLStoreViewModel new];
                viewModel.shopid = url_id;
                YBLStoreViewController * storeVC = [[YBLStoreViewController alloc]init];
                storeVC.viewModel = viewModel;
                [navVc pushViewController:storeVC animated:YES];
            } else if ([url_type isEqualToString:@"bidding"]){
                //竞标
                YBLPurchaseOrderModel *orderModel = [YBLPurchaseOrderModel new];
                orderModel._id = url_id;
                YBLPurchaseOutPriceRecordsViewModel *viewModel = [[YBLPurchaseOutPriceRecordsViewModel alloc] init];
                viewModel.purchaseDetailModel = orderModel;
                YBLPurchaseOutPriceRecordsVC *recordsVC= [[YBLPurchaseOutPriceRecordsVC alloc] init];
                recordsVC.viewModel = viewModel;
                [navVc pushViewController:recordsVC animated:YES];
            }


        }else{
            //不能识别 safrai 打开
            [[UIApplication sharedApplication] openURL:webUrl];
        }
        
    }else if ([userActivity.activityType isEqualToString:@"com.apple.corespotlightitem"]){
        // spotLight 方式
        
//        NSString *userinfo=userActivity.userInfo[@"kCSSearchableItemActivityIdentifier"];
        // 根据 userInfo 实现相应操作
        
    }
    
    return YES;
}

@end

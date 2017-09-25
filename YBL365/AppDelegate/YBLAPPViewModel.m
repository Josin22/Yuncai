//
//  XNAPPViewModel.m
//  51XiaoNiu
//
//  Created by 乔同新 on 16/5/24.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLAPPViewModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
#import "APOpenAPI.h"
#import <Bugtags/Bugtags.h>
#import "IQKeyboardManager.h"
#import <CoreLocation/CLLocationManager.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
//#import "RealReachability.h"
#import "YBLUpdateVersionView.h"
#import "YBLGuideView.h"
#import "YBLNetWorkHudBar.h"
#import "TalkingData.h"
#import <Bugly/Bugly.h>

@interface YBLAPPViewModel()<BMKGeneralDelegate>

@end

static YBLAPPViewModel *appView = nil;

static CLLocationManager *_locationManager = nil;

BMKMapManager* _mapManager;

@implementation YBLAPPViewModel

+(YBLAPPViewModel *)shareApp{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appView = [[YBLAPPViewModel alloc] init];
    });
    return appView;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (void)finishLaunchOption:(NSDictionary *)option
{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
    /* BM */
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BMK_DISTRIBUTION_KEY generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    /* Location */
    //定位服务是否可用
    BOOL enable = [CLLocationManager locationServicesEnabled];
    //是否具有定位权限
    int status = [CLLocationManager authorizationStatus];
    if(!enable || status<3){
        //请求权限
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8){
            //由于IOS8中定位的授权机制改变 需要进行手动授权
            _locationManager = [[CLLocationManager alloc] init];
            //获取授权认证
            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
        }
        
    }
    
    /*Bugly*/
    [Bugly startWithAppId:Bugly_Key];
    
    /*Bugtags*/
#ifdef DEBUG
    [Bugtags startWithAppKey:Bug_Tags_Develop_Key invocationEvent:BTGInvocationEventBubble];
#else
    [Bugtags startWithAppKey:Bug_Tags_Release_Key invocationEvent:BTGInvocationEventShake];
#endif

    /* talk data */
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData setSignalReportEnabled:YES];
    [TalkingData sessionStarted:TalkData_Key withChannelId:@"App Store"];

    /*WX*/
    [WXApi registerApp:WX_Key withDescription:@"yuncai_wxpay"];
    
    /* Share SDK */
    [ShareSDK registerApp:ShareSDK_Key
          activePlatforms:@[
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeAliPaySocial),
                            @(SSDKPlatformTypeAliPaySocialTimeline),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeQQFriend),
                            @(SSDKPlatformSubTypeQZone)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeAliPaySocial:
                 [ShareSDKConnector connectAliPaySocial:[APOpenAPI class]];
                 break;

             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                 [appInfo SSDKSetupSinaWeiboByAppKey:SINA_Key
//                                           appSecret:SINA_Secret
//                                         redirectUri:@"http://www.sharesdk.cn"
//                                            authType:SSDKAuthTypeBoth];
                 [appInfo SSDKSetupAliPaySocialByAppId:AP_Key];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WX_Key
                                       appSecret:WX_Secret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:QQ_Key
                                      appKey:QQ_Secret
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    /**
     *  HUD 设置
     */
    [self setUpSvpProgress];
    /**
     *  数组越界
     */
    [AvoidCrash becomeEffective];
    /**
     *  键盘
     */
    [IQKeyboardManager sharedManager].previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysHide;
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    [IQKeyboardManager sharedManager].toolbarTintColor = YBLColor(40, 40, 40, 1);
    /**
     *  导航栏设置
     */
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:YBLColor(40, 40, 40, 1),
                                                           NSFontAttributeName:YBLFont(18)}];
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    attrs[NSForegroundColorAttributeName] = YBLColor(70, 70, 70, 1);
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    /**
     *  检查更新
     */
    [self checkAppVersion];
    /**
     *  网络
     */
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可达");
                break;
            case 1:
                NSLog(@"GPRS网络");
                break;
            case 2:
                NSLog(@"wifi网络");
                break;
            default:
                break;
        }
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            NSLog(@"有网");
            [YBLUserManageCenter shareInstance].isNoActiveNetStatus = NO;
        }else
        {
            NSLog(@"没有网");
            [YBLUserManageCenter shareInstance].isNoActiveNetStatus = YES;
        }
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ///监听网络
        WEAK
        [RACObserve([YBLUserManageCenter shareInstance], isNoActiveNetStatus) subscribeNext:^(NSNumber*  _Nullable x) {
            STRONG
            if (x.boolValue) {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                UINavigationController *navVc = [self getNavigationCWithWindow:window];
                [YBLNetWorkHudBar startMonitorWithVc:navVc.visibleViewController];
            } else {
                [YBLNetWorkHudBar dismissHudView];
            }
            [SVProgressHUD dismiss];
            [YBLLogLoadingView dismissInWindow];
        }];
    });
 
    [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    // 从全局的 queue pool 中获取一个 queue
//    dispatch_queue_t queue = YYDispatchQueueGetForQOS(NSQualityOfServiceUtility);
//    
//    // 创建一个新的 serial queue pool
//    YYDispatchQueuePool *pool = [[YYDispatchQueuePool alloc] initWithName:@"file.read" queueCount:5 qos:NSQualityOfServiceBackground];
//    dispatch_queue_t queue1 = [pool queue];
}


//初始化提示框
- (void)setUpSvpProgress {
    
    [[UIButton appearance] setExclusiveTouch:YES];
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"hud_error"]];
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"hud_success"]];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setCornerRadius:8];
    [SVProgressHUD setBackgroundColor:YBLColor(0, 0, 0, 0.6)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setFont:YBLFont(16)];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    CGFloat wi = YBLWindowWidth/3-space;
    [SVProgressHUD setMinimumSize:CGSizeMake(wi, wi)];
    
}

- (void)checkAppVersion{
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"app"] = @"ios";
    [YBLRequstTools HTTPGetDataWithUrl:url_versions
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                              
                                 NSString *version = result[@"version"];
                                 NSString *releaseNotes = result[@"desc"];
                                 NSString *now_version= [YBLMethodTools getAppVersion];
                                 NSComparisonResult compare_result =  [version compare:now_version options:NSNumericSearch];
                                 if (compare_result == NSOrderedDescending) {
                                     //需要更新
                                     YBLUpdateReaseNotModel *notModel = [YBLUpdateReaseNotModel new];
                                     notModel.releaseNot = releaseNotes;
                                     notModel.version = version;
                                     [[NSNotificationCenter defaultCenter] postNotificationName:App_Notification_Version object:nil userInfo:@{@"model":notModel}];
                                 }
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   
                               }];
    
}

- (void)showLaunchAnimationView{
    
    BOOL noFirstLaunch = [[[NSUserDefaults standardUserDefaults] objectForKey:NO_FIRST_LAUNCH_KEY] boolValue];
    if (noFirstLaunch) {
        //正常动画
        [self showAnimationLaunchImageView];
    } else {
        //引导页
        [self showGuideView];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:NO_FIRST_LAUNCH_KEY];
    }
}

- (void)showGuideView{
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i < 5; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@%@",@"LaunchIntrudutionImage",@(i)];
        [imageArray addObject:imageName];
    }
    [YBLGuideView showGuideViewWithDataArray:imageArray
                                   doneBlock:^{
                                       
                                   }];
    
}


- (void)showAnimationLaunchImageView{
 
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    __block UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage getTheLaunchImage]];
    launchView.frame = window.bounds;
    launchView.contentMode = UIViewContentModeScaleAspectFill;
    launchView.userInteractionEnabled = NO;
    [window addSubview:launchView];
    
    UIImage *launchImage = [UIImage imageNamed:@"loadding_line"];
    UIImageView *launchbgImageView = [[UIImageView alloc] initWithImage:launchImage];
    launchbgImageView.frame = CGRectMake(0, 0, launchImage.size.width, launchImage.size.height);
    launchbgImageView.center = launchView.center;
    [launchView addSubview:launchbgImageView];
    
    UIImage *launchProgressArrowImage = [UIImage imageNamed:@"launchProgressIcon"];
    UIImageView *launchProgressArrowImageView = [[UIImageView alloc] initWithImage:launchProgressArrowImage];
    launchProgressArrowImageView.frame = CGRectMake(0, 0, launchProgressArrowImage.size.width, launchProgressArrowImage.size.height);
    launchProgressArrowImageView.center = CGPointMake(launchProgressArrowImage.size.width/2, launchbgImageView.height/2);
    [launchbgImageView addSubview:launchProgressArrowImageView];
    
    [UIView animateWithDuration:0.7f
                          delay:0.7f
                        options:UIViewAnimationOptionCurveEaseOut
                      animations:^{
                          launchProgressArrowImageView.left = launchbgImageView.width-launchProgressArrowImageView.width*1.5;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0f
                              delay:0.5f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             launchView.alpha = 0.0f;
                             launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
                         }
                         completion:^(BOOL finished) {
                             [launchView removeFromSuperview];
                             launchView = nil;
                         }];
    }];
    
   }

- (UINavigationController *)getNavigationCWithWindow:(UIWindow *)window;{
    UITabBarController *tabVC = (UITabBarController  *)window.rootViewController;
    UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
    return pushClassStance;
}

@end

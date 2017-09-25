/*
 File:       Bugtags/Bugtags.h
 
 Contains:   API for using Bugtags's SDK.
 
 Copyright:  (c) 2017 by Bugtags, Ltd., all rights reserved.
 
 Version:    2.2.2
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BTGConstants.h"

@interface BugtagsOptions : NSObject <NSCopying>

/**
 * 是否跟踪闪退，联机 Debug 状态下默认 NO，其它情况默认 YES
 */
@property(nonatomic, assign) BOOL trackingCrashes;

/**
 * 是否跟踪用户操作步骤，默认 YES
 */
@property(nonatomic, assign) BOOL trackingUserSteps;

/**
 * 是否收集控制台日志，默认 YES
 */
@property(nonatomic, assign) BOOL trackingConsoleLog;

/**
 * 是否收集用户位置信息，默认 YES
 */
@property(nonatomic, assign) BOOL trackingUserLocation;

/**
 * 是否跟踪网络请求，只跟踪 HTTP / HTTPS 请求，默认 NO
 * 强烈建议同时设置 trackingNetworkURLFilter 对需要跟踪的网络请求进行过滤
 */
@property(nonatomic, assign) BOOL trackingNetwork;

/**
 * 设置需要跟踪的网络请求 URL，多个地址用 | 隔开，支持正则表达式，不设置则跟踪所有请求
 * 强烈建议设置为应用服务器接口的域名，如果接口是通过 IP 地址访问，则设置为 IP 地址
 * 如：设置为 bugtags.com，则网络请求跟踪只对 URL 中包含 bugtags.com 的请求有效
 */
@property(nonatomic, copy) NSString *trackingNetworkURLFilter;

/**
 * 网络请求跟踪遇到 HTTPS 请求证书无效的时候，是否允许继续访问，默认 NO
 */
@property(nonatomic, assign) BOOL trackingNetworkContinueWithInvalidCertificate;

/**
 * 是否收集闪退时的界面截图，默认 YES
 */
@property(nonatomic, assign) BOOL crashWithScreenshot;

/**
 * 是否忽略所有的 Signal 闪退，设置为 YES 将不再收集 Signal 闪退，默认 NO
 */
@property(nonatomic, assign) BOOL ignoreSignalCrash;

/**
 * 是否忽略 PIPE Signal (SIGPIPE) 闪退，默认 NO
 */
@property(nonatomic, assign) BOOL ignorePIPESignalCrash;

/**
 * 是否开启用户登录，默认 YES
 */
@property(nonatomic, assign) BOOL enableUserSignIn;

/**
 * 支持的屏幕方向，默认 UIInterfaceOrientationMaskAllButUpsideDown，请根据您的 App 支持的屏幕方向来设置
 * 1.1.2+ 不需要手动设置，SDK 会自动设置
 */
@property(nonatomic, assign) UIInterfaceOrientationMask supportedInterfaceOrientations __attribute__((deprecated));

/**
 * 设置应用版本号，默认自动获取应用的版本号
 */
@property(nonatomic, copy) NSString *version;

/**
 * 设置应用 build，默认自动获取应用的 build
 */
@property(nonatomic, copy) NSString *build;

/**
 * 设置应用的渠道名称
 */
@property(nonatomic, copy) NSString *channel;

/**
 * 设置远程配置的数据获取模式
 * 默认为 BTGDataModeProduction，获取生产环境的数据
 * BTGDataModeTesting 获取测试环境的数据
 * BTGDataModeLocal 获取本地的数据文件，自动读取本地 mainBundle 的 main.local.plist 文件
 */
@property(nonatomic, assign) BTGDataMode remoteConfigDataMode;

/**
 * 设置远程配置在执行过程中的回调
 */
@property(nonatomic, copy) BTGRemoteConfigCallback remoteConfigCallback;

/**
 * 设置其它的启动项
 * 目前支持的可设置项如下：
 * BTGUserStepLogCapacityKey NSNumber 设置收集最近的用户操作步骤数量，默认 500 项
 * BTGConsoleLogCapacityKey  NSNumber 设置收集最近的控制台日志数量，默认 500 项
 * BTGBugtagsLogCapacityKey  NSNumber 设置收集最近的 Bugtags 自定义日志数量，默认 500 项
 * BTGNetworkLogCapacityKey  NSNumber 设置记录最近的网络请求数量，默认 20 项
 */
@property(nonatomic, copy) NSDictionary *extraOptions;

@end

/**
 * 远程配置类
 *
 */
@interface BugtagsRemoteConfig : NSObject

/**
 * 获取指定的字符串，没有指定的 key，则返回 nil
 * @param key key
 * @return 字符串
 */
- (NSString *)stringForKey:(NSString *)key;

/**
 * 获取指定的 Bool 值，没有指定的 key，则返回 NO
 * @param key key
 * @return YES / NO
 */
- (BOOL)boolForKey:(NSString *)key;

/**
 * 获取指定的整型值，没有指定的 key，则返回 0
 * @param key key
 * @return 整型值
 */
- (NSInteger)integerForKey:(NSString *)key;

@end

@interface Bugtags : NSObject

/**
 * 初始化 Bugtags
 * @param appKey - 通过 bugtags.com 申请的应用appKey
 * @param invocationEvent - 呼出方式
 */
+ (void)startWithAppKey:(NSString *)appKey invocationEvent:(BTGInvocationEvent)invocationEvent;

/**
 * 初始化 Bugtags
 * @param appKey - 通过 bugtags.com 申请的应用appKey
 * @param invocationEvent - 呼出方式
 * @param options - 启动选项
 */
+ (void)startWithAppKey:(NSString *)appKey invocationEvent:(BTGInvocationEvent)invocationEvent options:(BugtagsOptions *)options;

/**
 * 设置 Bugtags 呼出方式
 * @param invocationEvent - 呼出方式
 */
+ (void)setInvocationEvent:(BTGInvocationEvent)invocationEvent;

/**
 * 获取 Bugtags 当前的呼出方式
 * @return 呼出方式
 */
+ (BTGInvocationEvent)currentInvocationEvent;

/**
 * Bugtags 日志工具，添加自定义日志，不会在控制台输出
 * @param format - 格式化字符串
 * @param ... - 字符串
 */
void BTGLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

/**
 * Bugtags 日志工具，添加自定义日志，不会在控制台输出，功能等同于 BTGLog
 * 在 Swift 中请调用此方法添加自定义日志
 * @param content - 日志内容
 */
+ (void)log:(NSString *)content;

/**
 * 设置是否收集 Crash 信息
 * @param trackingCrashes - 默认 YES
 */
+ (void)setTrackingCrashes:(BOOL)trackingCrashes;

/**
 * 设置是否跟踪用户操作步骤
 * @param trackingUserSteps - 默认 YES
 */
+ (void)setTrackingUserSteps:(BOOL)trackingUserSteps;

/**
 * 设置是否收集控制台日志
 * @param trackingConsoleLog - 默认 YES
 */
+ (void)setTrackingConsoleLog:(BOOL)trackingConsoleLog;

/**
* 设置是否收集用户位置信息
* @param trackingUserLocation - 默认 YES
*/
+ (void)setTrackingUserLocation:(BOOL)trackingUserLocation;

/**
 * 设置是否跟踪网络请求，只跟踪 HTTP / HTTPS 请求
 * 强烈建议同时设置 trackingNetworkURLFilter 对需要跟踪的网络请求进行过滤
 * @param trackingNetwork - 默认 NO
 */
+ (void)setTrackingNetwork:(BOOL)trackingNetwork;

/**
 * 设置自定义数据，会与问题一起提交
 * @param data - 用户数据
 * @param key - key
 */
+ (void)setUserData:(NSString *)data forKey:(NSString *)key;

/**
 * 移除指定 key 的自定义数据
 * @param key - key
 */
+ (void)removeUserDataForKey:(NSString *)key;

/**
 * 移除所有自定义数据
 */
+ (void)removeAllUserData;

/**
 * 手动发送Exception
 * @param exception - 要提交的 exception 对象
 */
+ (void)sendException:(NSException *)exception;

/**
 * 发送用户反馈
 * @param content - 反馈内容
 */
+ (void)sendFeedback:(NSString *)content;

/**
 * 发送用户反馈
 * @param content - 反馈内容
 * @param image   - 附图
 */
+ (void)sendFeedback:(NSString *)content image:(UIImage *)image;

/**
 * 添加自定义用户步骤
 * @param content - 步骤内容
 */
+ (void)addUserStep:(NSString *)content;

/**
 * 设置问题提交之前的回调
 * 手动提交问题或自动捕捉到崩溃，在保存相关数据之前会调用该回调
 * @param callback - 回调的 block
 */
+ (void)setBeforeSendingCallback:(void (^)(void))callback;

/**
 * 设置问题提交成功后的回调
 * 手动提交问题或自动捕捉到崩溃，在相关数据成功提交到 Bugtags 云端后调用该回调
 * @param callback - 回调的 block
 */
+ (void)setAfterSendingCallback:(void (^)(void))callback;

/**
 * 设置是否仅在 WiFi 模式下才上传数据
 * @param onlyViaWiFi - 默认 NO
 */
+ (void)setUploadDataOnlyViaWiFi:(BOOL)onlyViaWiFi;

/**
 * 手动调用截屏界面
 */
+ (void)invoke;

/**
 * 注册插件
 * @param plugin 需要注册的插件
 * @return 注册成功 - YES，注册失败 - NO
 */
+ (BOOL)registerPlugin:(id)plugin;

/**
 * 卸载插件
 * @param plugin 需要卸载的插件
 */
+ (void)unregisterPlugin:(id)plugin;

/**
 * 获取远程配置
 * @return BugtagsRemoteConfig
 */
+ (BugtagsRemoteConfig *)remoteConfig;

/**
 * 手动同步远程配置
 * Bugtags 初始化会自动调用一次
 * 如果本地缓存数据已经是最新版本，则不会拉取数据，相当于调用 [Bugtags sync:NO]
 */
+ (void)sync;

/**
 * 手动同步远程配置
 * @param force 清除本地缓存后重新拉取数据
 */
+ (void)sync:(BOOL)force;

@end

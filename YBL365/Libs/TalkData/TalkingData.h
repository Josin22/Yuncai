//
//  TalkingData.h
//  __MyProjectName__
//
//  Created by Biao Hou on 11-11-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


// 以下枚举用于WatchApp页面追踪
typedef enum {
    TDPageTypeGlance = 1,
    TDPageTypeNotification = 2,
    TDPageTypeWatchApp = 3
} TDPageType;

@interface TalkingData: NSObject

/**
 *  @method getDeviceID
 *  获取SDK所使用的DeviceID
 *  @return DeviceID
 */
+ (NSString *)getDeviceID;

/**
 *  @method setLogEnabled
 *  统计日志开关（可选）
 *  @param  enable      默认是开启状态
 */
+ (void)setLogEnabled:(BOOL)enable;

/**
 *  @method setExceptionReportEnabled
 *  是否捕捉程序崩溃记录（可选）
    如果需要记录程序崩溃日志，请将值设成YES，并且在调用sessionStarted:withChannelId:之前调用此函数
 *  @param  enable      默认是 NO
 */
+ (void)setExceptionReportEnabled:(BOOL)enable;

/**
 *  @method setSignalReportEnabled
 *  是否捕捉异常信号（可选）
    如果需要开启异常信号捕捉功能，请将值设成YES，并且在调用sessionStarted:withChannelId:之前调用此函数
 *  @param  enable      默认是NO
 */
+ (void)setSignalReportEnabled:(BOOL)enable;


/**
 *  @method setLatitude:longitude:
 *  设置位置信息（可选）
 *  @param  latitude    维度
 *  @param  longitude   经度
 */
+ (void)setLatitude:(double)latitude longitude:(double)longitude;

/**
 *  @method	sessionStarted:withChannelId:
 *  初始化统计实例，请在application:didFinishLaunchingWithOptions:方法里调用
 *  @param  appKey      应用的唯一标识，统计后台注册得到
 *  @param  channelId   渠道名，如“app store”（可选）
 */
+ (void)sessionStarted:(NSString *)appKey withChannelId:(NSString *)channelId;

/**
 *  @method	initWithWatch:
 *  初始化WatchApp统计实例，请在每个入口类的init方法里调用
 *  @param  appKey      应用的唯一标识，统计后台注册得到
 */
+ (void)initWithWatch:(NSString *)appKey;

/**
 *	@method	setAntiCheatingEnabled
 *  是否开启反作弊功能
 *	@param 	enabled 	默认是开启状态
 */
+ (void)setAntiCheatingEnabled:(BOOL)enabled;


/**
 *  @method trackEvent
 *  统计自定义事件（可选），如购买动作
 *  @param  eventId     事件名称（自定义）
 */
+ (void)trackEvent:(NSString *)eventId;

/**
 *  @method trackEvent:label:
 *  统计带标签的自定义事件（可选），可用标签来区别同一个事件的不同应用场景
    如购买某一特定的商品
 *  @param  eventId     事件名称（自定义）
 *  @param  eventLabel  事件标签（自定义）
 */
+ (void)trackEvent:(NSString *)eventId label:(NSString *)eventLabel;

/**
 *  @method	trackEvent:label:parameters
 *  统计带二级参数的自定义事件，单次调用的参数数量不能超过10个
 *  @param  eventId     事件名称（自定义）
 *  @param  eventLabel  事件标签（自定义）
 *  @param  parameters  事件参数 (key只支持NSString, value支持NSString和NSNumber)
 */
+ (void)trackEvent:(NSString *)eventId 
             label:(NSString *)eventLabel 
        parameters:(NSDictionary *)parameters;

/**
 *  @method setGlobalKV:value:
 *  添加全局的字段，这里的内容会每次的自定义事都会带着，发到服务器。也就是说如果您的自定义事件中每一条都需要带同样的内容，如用户名称等，就可以添加进去
 *  @param  key         自定义事件的key，如果在之后，创建自定义的时候，有相同的key，则会覆盖，全局的里相同key的内容
 *  @param  value       这里是NSObject类型，或者是NSString 或者NSNumber类型
 */
+ (void)setGlobalKV:(NSString *)key value:(id)value;

/**
 *  @method removeGlobalKV:
 *  删除全局数据
 *  @param  key         自定义事件的key
 */
+ (void)removeGlobalKV:(NSString *)key;

/**
 *  @method	trackPageBegin
 *  开始跟踪某一页面（可选），记录页面打开时间
    建议在viewWillAppear或者viewDidAppear方法里调用
 *  @param  pageName    页面名称（自定义）
 */
+ (void)trackPageBegin:(NSString *)pageName;

/**
 *  @method trackPageBegin:withPageType:
 *  开始跟踪WatchApp某一页面（可选），记录页面打开时间
    建议在willActivate方法里调用
 *  @param  pageName    页面名称（自定义）
 *  @param  pageType    页面类型（TDPageType枚举类型）
 */
+ (void)trackPageBegin:(NSString *)pageName withPageType:(TDPageType)pageType;

/**
 *  @method trackPageEnd
 *  结束某一页面的跟踪（可选），记录页面的关闭时间
    此方法与trackPageBegin方法结对使用，
    在iOS应用中建议在viewWillDisappear或者viewDidDisappear方法里调用
    在Watch应用中建议在DidDeactivate方法里调用
 *  @param  pageName    页面名称，请跟trackPageBegin方法的页面名称保持一致
 */
+ (void)trackPageEnd:(NSString *)pageName;

/**
 *  @method setDeviceToken              设置DeviceToken
 *  @param  deviceToken                 从Apple获取的DeviceToken
 */
+ (void)setDeviceToken:(NSData *)deviceToken;

/**
 *  @method handlePushMessage           处理来自TalkingData的Push消息
 *  @param  message                     收到的消息
 *  @return YES                         来自TalkingData的消息，SDK已处理
 *          NO                          其他来源消息，开发者需自行处理
 */
+ (BOOL)handlePushMessage:(NSDictionary *)message;


@end

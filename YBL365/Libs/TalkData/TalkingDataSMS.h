//
//  TalkingDataSMS.h
//  TalkingData
//
//  Created by liweiqiang on 15/6/9.
//  Copyright (c) 2015年 TendCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TalkingDataSMSDelegate <NSObject>

// Delegate回调是在您的主线程中
- (void)onApplySucc:(NSString *)requestId;
- (void)onApplyFailed:(int)errorCode errorMessage:(NSString *)errorMessage;
- (void)onVerifySucc:(NSString *)requestId;
- (void)onVerifyFailed:(int)errorCode errorMessage:(NSString *)errorMessage;

@end

@interface TalkingDataSMS : NSObject

/**
 * 短信认证初始化
 *
 * @param appId
 *            TalkingData 分配的App Id
 * @param secretId
 *            TalkingData 分配的 secretId
 */
+ (void)init:(NSString *)appId withSecretId:(NSString *)secretId;

/**
 * 申请短信认证码
 *
 * @param countryCode
 *            国家码 如：中国，86
 * @param mobile
 *            申请验证码的手机号
 * @param delegate
 *            申请的异步回调接口
 */
+ (void)applyAuthCode:(NSString *)countryCode
               mobile:(NSString *)mobile
             delegate:(id<TalkingDataSMSDelegate>)delegate;

/**
 * 重新申请短信认证码，将下发和requestId匹配的短信内容
 *
 * @param countryCode
 *            国家码 如：中国，86
 * @param mobile
 *            申请验证码的手机号
 * @param requestId
 *            相同的request id将返回相同的认证码
 * @param delegate
 *            申请的异步回调接口
 */
+ (void)reapplyAuthCode:(NSString *)countryCode
                 mobile:(NSString *)mobile
              requestId:(NSString *)requestId
               delegate:(id<TalkingDataSMSDelegate>)delegate;

/**
 * 验证短信认证码的有效性
 *
 * @param countryCode
 *            国家码 如：中国，86
 * @param mobile
 *            验证手机号
 * @param authCode
 *            短信认证码
 * @param delegate
 *            验证请求的异步回调接口
 */
+ (void)verifyAuthCode:(NSString *)countryCode
                mobile:(NSString *)mobile
              authCode:(NSString *)authCode
              delegate:(id<TalkingDataSMSDelegate>)delegate;

@end

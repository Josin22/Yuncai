//
//  YBLSendMessageTools.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

/** model 类 */
@interface YBLContactModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phoneNumber;

@end

typedef void(^YBLContactsBlock)(YBLContactModel *contact);

typedef NS_ENUM(NSInteger, YBLMessageComposeResult)
{
    YBLMessageComposeResultCancelled = 0,
    YBLMessageComposeResultSent,
    YBLMessageComposeResultFailed
};


typedef void(^YBLMessageBlock)(YBLMessageComposeResult result);

@interface YBLSendMessageTools : NSObject


/**
 *  调用系统通讯录 选择并获取联系人信息
 *
 *  @param handler 选取联系人后的回调
 */
- (void)callContactsHandler:(YBLContactsBlock)handler;

/**
 *  调用系统短信功能 单发/群发信息，并返回发送结果
 *
 *  @param phoneNumbers 电话号码数组
 *  @param message      短信内容
 *  @param handler      发送后的回调
 */
- (void)sendContacts:(NSArray<NSString *> *)phoneNumbers message:(NSString *)message completion:(YBLMessageBlock)handler;

/**
 *  使用:
 用属性调用实例方法打电话:
 self.contactsUtil = [JHSysContactsUtil new];
 [self.contactsUtil callContactsHandler:^(JHContactModel *contact) {
 NSLog(@"@@~~name : %@, phoneNumber: %@", contact.name, contact.phoneNumber);
 }];
 
 用属性调用实例方法发短信:
 [self.contactsUtil sendContacts:@[@"10010"] message:@"This is a test" completion:^(JHMessageComposeResult result) {
 NSLog(@"@@~~d : %ld", (long)result);
 }];
 */

+ (void)creatContactName:(NSString *)name phone:(NSString *)phone;
+ (void)creatContactName:(NSString *)name phone:(NSString *)phone address:(NSString *)address;

@end

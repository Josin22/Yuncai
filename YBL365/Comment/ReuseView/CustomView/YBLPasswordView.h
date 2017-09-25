//
//  YBLPasswordView.h
//  YC168
//
//  Created by 乔同新 on 2017/3/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PasswordSecretShowType) {
    PasswordSecretShowTypeHidden = 0,
    PasswordSecretShowTypeShow
};

typedef void(^PasswordViewTextChangeBlock)(NSString *text,BOOL isWriteDone);

@interface YBLPasswordView : UIView<UITextFieldDelegate>

@property (nonatomic, copy  ) PasswordViewTextChangeBlock passwordViewTextChangeBlock;

- (instancetype)initWithFrame:(CGRect)frame passwordSecretShowType:(PasswordSecretShowType)passwordSecretShowType;

/**
 *  清除密码
 */
- (void)clearUpPassword;

- (void)becomFirespone;

@end

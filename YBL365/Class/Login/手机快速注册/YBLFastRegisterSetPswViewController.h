//
//  YBLFastRegisterSetPswViewController.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMainViewController.h"

typedef NS_ENUM(NSInteger,PushPswType) {
    PushPswTypeFastRegister = 0,
    PushPswTypeForgotPsw
};

@interface YBLFastRegisterSetPswViewController : YBLMainViewController

- (instancetype)initPushPswTypeType:(PushPswType)type;

@property (nonatomic, strong) NSString *phoneNummber;

@property (nonatomic, strong) NSString *tmpcode;

@end

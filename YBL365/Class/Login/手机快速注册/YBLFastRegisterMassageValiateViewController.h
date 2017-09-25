//
//  YBLFastRegisterMassageValiateViewController.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMainViewController.h"

typedef NS_ENUM(NSInteger,PushType) {
    PushTypeFastRegister = 0,
    PushTypeForgotPsw,
};

@interface YBLFastRegisterMassageValiateViewController : YBLMainViewController

- (instancetype)initPushType:(PushType)type;

@property (nonatomic, strong) NSString *phoneNummber;

@end

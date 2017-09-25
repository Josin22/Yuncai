//
//  YBLLoginView.h
//  YBL365
//
//  Created by 乔同新 on 16/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLMainView.h"

typedef void(^LoginSuccessBlcok)();
typedef void(^LoginFaileBlock)();

@interface YBLLoginView : UIView

/**
 *  调用登录 动画弹出登录界面
 *
 *  @param VC           必填 是从哪个控制器弹出
 *  @param successBlock 登录成功回调
 *  @param failBlock    登录失败回调
 */
+ (void)loginWithViewController:(UIViewController *)VC
                   successBlock:(LoginSuccessBlcok)successBlock
                      failBlock:(LoginFaileBlock)failBlock;


@end

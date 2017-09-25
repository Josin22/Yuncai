//
//  YBLSystemSocialShareView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLBaseView.h"
#import "YBLSystemSocialModel.h"

@interface YBLSystemSocialShareView : YBLBaseView

+ (void)showSystemSocialShareViewWithInViewConcontroller:(UIViewController *)Vc
                                                   Model:(YBLSystemSocialModel *)model;

@end

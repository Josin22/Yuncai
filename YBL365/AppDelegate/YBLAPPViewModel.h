//
//  XNAPPViewModel.h
//  51XiaoNiu
//
//  Created by 乔同新 on 16/5/24.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLAPPViewModel : NSObject

+(YBLAPPViewModel *)shareApp;

- (void)finishLaunchOption:(NSDictionary *)option;

- (void)showLaunchAnimationView;

- (UINavigationController *)getNavigationCWithWindow:(UIWindow *)window;

@end

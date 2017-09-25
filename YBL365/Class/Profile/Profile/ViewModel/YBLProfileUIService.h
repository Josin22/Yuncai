//
//  YBLProfileUIService.h
//  YBL365
//
//  Created by 乔同新 on 16/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBLProfileViewController,YBLProfileViewModel;

typedef void(^LoginBlock)();

@interface YBLProfileUIService : NSObject

@property (nonatomic, weak) YBLProfileViewController *profileVC;

@property (nonatomic, strong) YBLProfileViewModel *viewModel;;

@property (nonatomic, copy) LoginBlock loginBlock;

- (void)updateWithRecommendArray:(NSArray *)recommendArray;

- (void)updateWithIsLogin:(BOOL)isLogin;


@end

//
//  YBLBaseService.h
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLBaseService : NSObject

@property (nonatomic, weak) UIViewController *baseVc;

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel;

+ (instancetype)serviceWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel;

@end

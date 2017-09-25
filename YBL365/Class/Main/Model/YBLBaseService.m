//
//  YBLBaseService.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBaseService.h"

@implementation YBLBaseService

+ (instancetype)serviceWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    return [[self alloc] initWithVC:VC ViewModel:viewModel];
}

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super init]) {

        self.baseVc = VC;
    }
    return self;
}

@end

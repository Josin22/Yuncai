//
//  YBLMessageDetailViewModel.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/1.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLPerPageBaseViewModel.h"

@class YBLMineMillionMessageItemModel;

@interface YBLMessageDetailViewModel : YBLPerPageBaseViewModel

@property (nonatomic, strong) YBLMineMillionMessageItemModel *model;

- (RACSignal *)singalForMessageIsReload:(BOOL)isReload;

@end

//
//  YBLOrderCommentsViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/6/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLPerPageBaseViewModel.h"

@interface YBLOrderCommentsViewModel : YBLPerPageBaseViewModel

@property (nonatomic, strong) NSArray *numberCountArray;

- (RACSignal *)siganlForOrderCommentsListIsReload:(BOOL)isReload;

@end

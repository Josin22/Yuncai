//
//  YBLGoodEvaluateViewModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLPerPageBaseViewModel.h"

@interface YBLGoodEvaluateViewModel : YBLPerPageBaseViewModel

@property (nonatomic, strong) NSArray *numberArray;

@property (nonatomic, strong) NSString *product_id;

- (RACSignal *)siganlForProductCommentsIsReload:(BOOL)isReload;

@end

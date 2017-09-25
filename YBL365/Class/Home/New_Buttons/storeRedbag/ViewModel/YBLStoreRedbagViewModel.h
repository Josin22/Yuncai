//
//  YBLStoreRedbagViewModel.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLPerPageBaseViewModel.h"

@interface YBLStoreRedbagViewModel : YBLPerPageBaseViewModel

//@property (nonatomic, strong) NSMutableArray *storeDataArray;

//- (RACSignal *)siganlForBaseStoreRedbag;

- (RACSignal *)siganlForBaseStoreRedbagIsReload:(BOOL)isReload;

@end

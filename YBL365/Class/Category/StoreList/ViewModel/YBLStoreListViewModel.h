//
//  YBLStoreListViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLStoreListViewModel : NSObject

@property (nonatomic, strong) NSString *storeName;

@property (nonatomic, strong) NSMutableArray *storeDataArray;

- (RACSignal *)siganlForStoreData;

@end

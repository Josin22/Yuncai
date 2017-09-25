//
//  YBLStoreSelectBannerViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/19.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^StoreSelectBannerViewModelChangeBlock)(NSString *url);

@interface YBLStoreSelectBannerViewModel : NSObject

@property (nonatomic, strong) StoreSelectBannerViewModelChangeBlock storeSelectBannerViewModelChangeBlock;

@property (nonatomic, strong) NSMutableArray *pureImageURLArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString *select_id;

@property (nonatomic, assign) BOOL isShow;

- (RACSignal *)siganlForAllStoreBanner;

- (RACSignal *)siganlForSettingStoreBanner;

@end

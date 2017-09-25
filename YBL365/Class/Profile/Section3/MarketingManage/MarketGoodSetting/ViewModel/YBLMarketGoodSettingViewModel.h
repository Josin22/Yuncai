//
//  YBLMarketGoodSettingViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/6/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLWMarketGoodModel.h"

typedef void(^MarketGoodSettingViewModelChangeBlock)(YBLWMarketGoodModel *changeModel);

typedef NS_ENUM(NSInteger,MarketGoodVCType) {
    /**
     *  营销文案设置
     */
    MarketGoodVCTypeSetting = 0,
    /**
     *  营销文案选择
     */
    MarketGoodVCTypeChoose
};

@interface YBLMarketGoodSettingViewModel : NSObject

@property (nonatomic, assign) MarketGoodVCType marketGoodVcType;

@property (nonatomic, strong) NSMutableArray *picDataArray;

@property (nonatomic, strong) YBLWMarketGoodModel *marketGoodModel;

@property (nonatomic, strong) NSString *selectText;

@property (nonatomic, copy  ) MarketGoodSettingViewModelChangeBlock changeBlock;

- (RACSignal *)siganlForMutilUploadImage:(NSArray *)imageArray;

- (RACSignal *)siganlForSetWMarket;

- (RACSignal *)siganlForSyncMarketText:(NSString *)text;

- (RACSignal *)siganlForUploadImage:(UIImage *)image index:(NSInteger)index isAppending:(BOOL)isAppending;

@end

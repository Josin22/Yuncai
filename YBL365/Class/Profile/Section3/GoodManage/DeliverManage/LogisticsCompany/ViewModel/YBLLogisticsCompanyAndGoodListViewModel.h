//
//  YBLLogisticsCompanyAndGoodListViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLStoreViewModel.h"

typedef NS_ENUM(NSInteger, ListVCType) {
    /**
     *  未设置物流商品
     */
    ListVCTypeGood = 0,
    /**
     *  物流公司
     */
    ListVCTypeExpressCompany,
    /**
     *  单个物流公司
     */
    ListVCTypeSingleExpressCompany,
    /**
     *  店铺商品(多选)
     */
    ListVCTypeStoreGood,
    ListVCTypeRewardToSetMoeny,
    /**
     *  店铺商品(单选)
     */
    ListVCTypeStoreGoodSingleSelect
};

typedef void(^LogisticsCompanyAndGoodListBlock)(NSMutableArray *selectArray);

@interface YBLLogisticsCompanyAndGoodListViewModel : YBLStoreViewModel
/**
 *  回传值
 */
@property (nonatomic, copy  ) LogisticsCompanyAndGoodListBlock logisticsCompanyAndGoodListBlock;
/**
 *  类型
 */
@property (nonatomic, assign) ListVCType listVCType;
/**
 *  请求数据
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 *  上级穿多来的值
 */
@property (nonatomic, strong) NSMutableArray *openedExpressCompanyGoodListDataArray;
/**
 *  选中保存商品数据
 */
@property (nonatomic, strong) NSMutableArray *selectCompanyGoodListDataArray;
/**
 *  物流快递商品
 */
@property (nonatomic, strong) RACSignal *expressCompanyGoodListSiganl;
/**
 *  设置商品物流快递数据
 */
@property (nonatomic, strong) RACSignal *settingExpressCompanyGoodListSiganl;
/**
 *  修改 添加 快递
 */
- (RACSignal *)siganlForAddExpressCompanyWithIds:(NSString *)_id Name:(NSString *)name;
/**
 *  删除快递物流
 */
- (RACSignal *)siganlForDeleteAddExpressCompanyWithIds:(NSString *)_id index:(NSInteger)index;

- (RACSignal *)siganlForVaildExpressCompany;

- (RACSignal *)storeGoodListSiganlIsReload:(BOOL)isReload;

- (BOOL)isGoodsType;

@end

//
//  YBLShopCarViewModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLOrderConfirmModel.h"

typedef NS_ENUM(NSInteger,CarVCType) {
    CarVCTypeNormal = 0,
    CarVCTypeSpecial
};

@class YBLShopCarBarView;

@interface YBLShopCarViewModel : NSObject
/**
 *  购物车类型
 */
@property (nonatomic, assign) CarVCType            carVCType;
/**
 *  购物车数据
 */
@property (nonatomic, strong) NSMutableArray       *shopCartDataArray;
/**
 *  选中购物车数据
 */
@property (nonatomic, strong) NSMutableArray       *selectCartDataArray;
/**
 *  库存不足商品
 */
@property (nonatomic, strong) NSMutableArray       *noStockCartDataArray;
/**
 *  购物车信号
 */
@property (nonatomic, strong) RACSignal            *shopCarSigal;
/**
 *  orderconfirm model
 */
@property (nonatomic, strong) YBLOrderConfirmModel *orderConfirmModel;
/**
 *  orderconfirm para  ===>>>[YBLTakeOrderParaItemModel,YBLTakeOrderParaItemModel]
 */
@property (nonatomic, strong) NSMutableArray       *orderConfirmParaArray;

//view
@property (nonatomic, weak  ) UITableView          *cartTableView;
@property (nonatomic, weak  ) YBLShopCarBarView    *barView;

//@property (nonatomic, assign) float                pay_price;

///确认订单信号
- (RACSignal *)confirmSignal;

+ (RACSignal *)confirmSignalWithParaArray:(NSMutableArray *)paraArray addressId:(NSString *)addressId ;
///删除购物车
- (RACSignal *)signalForDeleteCartItem:(NSMutableArray *)itemIDArray;
///数量改变
- (RACSignal *)signalForChangeItemQuantity:(NSMutableArray *)quantityArray;
//全选
- (void)selectAll:(BOOL)isSelect;
//section select
- (void)sectionSelect:(BOOL)isSelect section:(NSInteger)section;
//row select
- (void)rowSelectButton:(UIButton *)x IndexPath:(NSIndexPath *)indexPath;
//row change quantity
- (void)rowChangeQuantity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath;
//左滑删除商品
- (void)deleteGoodsBySingleSlide:(NSIndexPath *)path;
//选中删除
- (void)deleteGoodsBySelect;

+ (RACSignal *)getCurrentCartsNumber;

@end

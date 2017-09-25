//
//  YBLEdictPurchaseViewModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLGoodModel.h"
#import "YBLAllPurchaseInfoModel.h"

@interface YBLCheckGoldModel : NSObject

@property (nonatomic, strong) NSNumber *flag;

@property (nonatomic, strong) NSNumber *gold;

@property (nonatomic, strong) NSNumber *less_gold;

@property (nonatomic, strong) NSString *less_show_text;

@end

@class YBLPurchaseOrderModel;

@interface YBLEdictPurchaseViewModel : NSObject

@property (nonatomic, assign) PurchaseDetailPushType purchaseEditPushType;

@property (nonatomic, strong) YBLGoodModel *goodModel;

@property (nonatomic, strong) YBLPurchaseOrderModel *purchaseOrderModel;

@property (nonatomic, strong) NSMutableArray *cellDataArray;

@property (nonatomic, strong) YBLAllPurchaseInfoModel *allPayShipModel;

- (float)calculateFinalDepositMoney;

///历史
- (RACSignal *)signalForPurchaseOtherInfoWithType:(NSInteger)type;
///采购条件
+ (RACSignal *)signalForPurchaseinfosWithType:(NSInteger)type;
- (RACSignal *)signalForPurchaseinfosWithType:(NSInteger)type;
///采购商品信息
- (RACSignal *)signalForPurchaseProduct;
///保存采购订单发布
- (RACSignal *)signalForSavePurchaseOrder;
///检查钱包云币是否足够
+ (RACSignal *)signalReleasePurchaseForCheckGoldWith:(float)gold;
+ (RACSignal *)signalBiddingForCheckGoldWith:(float)gold;
- (RACSignal *)signalForCheckGold;
///返回完成信号标识
- (BOOL)isDoneAction;

- (RACSignal *)siganlForAllPayShipingMent;

@end

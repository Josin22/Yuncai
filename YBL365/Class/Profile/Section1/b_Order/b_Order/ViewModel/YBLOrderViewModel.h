//
//  YBLOrderViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLPerPageBaseViewModel.h"

static NSInteger const tag_order_table_view = 5954033;

typedef void(^OrderRebuyBlock)();

typedef void(^OrderDeleteBlock)();

typedef void(^OrderRequestBlock)();

@class YBLOrderItemModel;

typedef NS_ENUM(NSInteger,PushInVCType) {
    PushInVCTypeProfile = 0,//我的进入订单
    PushInVCTypeOtherWay //其他进入订单
};

@interface YBLOrderViewModel : YBLPerPageBaseViewModel

@property (nonatomic, assign) OrderSource orderSource;

@property (nonatomic, assign) PushInVCType pushInVCType;

@property (nonatomic, strong) NSMutableDictionary *selectImageDict;

@property (nonatomic, weak  ) UIViewController *Vc;

/**
 *  刷新订单数据
 *
 *  @return 信号
 */
- (RACSignal *)SingalForOrderIsReload:(BOOL)isReload;
/**
 *  上传物流
 *
 *  @param image 图片
 *  @param _id   orderid
 *
 *  @return 信号
 */
+ (RACSignal *)signalForUpLoadShippingEvidence:(UIImage *)image
                                           Ids:(NSString *)_id;
- (RACSignal *)signalForUpLoadShippingEvidence:(UIImage *)image
                                           Ids:(NSString *)_id;
/**
 *  删除订单
 *
 *  @param _id orderid
 *
 *  @return re
 */
- (RACSignal *)siganlForDeleteOrderWithID:(NSString *)_id;
+ (RACSignal *)siganlForDeleteOrderWithID:(NSString *)_id;
/**
 *  处理大小B按钮点击事件
 *
 *  @param model            单个model
 *  @param indexPath        当前indexpath
 *  @param currentTitle     按钮名字
 *  @param clickButtonModel 按钮model
 */
- (void)dealWithSellerAndBuyerCellButtonActionEventWithModel:(YBLOrderItemModel *)model
                                                   indexPath:(NSIndexPath *)indexPath
                                                currentTitle:(NSString *)currentTitle
                                      orderPropertyItemModel:(YBLOrderPropertyItemModel *)clickButtonModel
                                                        cell:(UITableViewCell *)cell
                                                    isSeller:(BOOL)isSeller
                                               isOrderDetail:(BOOL)isOrderDetail
                                            orderDeleteBlock:(OrderDeleteBlock)orderDeleteBlock
                                            orderRequestBlock:(OrderRequestBlock)orderRequestBlock
                                            currentTableView:(UITableView *)currentTableView;

- (void)handleRequestDataModel:(YBLOrderItemModel *)itemModel;
- (void)handleRequestDataModel:(YBLOrderItemModel *)itemModel isDetail:(BOOL)isDetail;

+ (RACSignal *)getCancelOrderReason:(NSString *)subtype;

@end

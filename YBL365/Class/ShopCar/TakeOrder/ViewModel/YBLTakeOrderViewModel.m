//
//  YBLTakeOrderViewModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLTakeOrderViewModel.h"
#import "YBLTakeOrderModel.h"
#import "YBLShopCarViewModel.h"
#import "YBLTakeOrderParaItemModel.h"

@implementation YBLTakeOrderViewModel

- (RACSignal *)commitSignal{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"提交中..."];
    
    NSInteger index = 0;
    NSMutableArray *new_confirm_para_array = [NSMutableArray array];
    for (YBLTakeOrderParaItemModel *paraItemModel in self.orderConfirmParaCopyArray) {
        YBLCartModel *cartModel =  self.orderConfirmModel.shop_line_items[index];
        NSInteger index2 = 0;
        NSMutableArray  *new_line_items = [NSMutableArray array];
        for (YBLTakeOrderParaLineItemsModel *paraLineItemModel in paraItemModel.line_items) {
            lineitems *itemsModel = cartModel.filter_line_items[index2];
            if (!itemsModel.no_permit_check_result.no_permit.boolValue) {
                [new_line_items addObject:paraLineItemModel];;
            }
            index2++;
        }
        paraItemModel.ship_address_id = self.orderConfirmModel.default_ship_address.id;
        paraItemModel.line_items = new_line_items;
        if (paraItemModel.line_items.count>0) {
            [new_confirm_para_array addObject:paraItemModel];
        }

        index++;
    }
    self.orderConfirmParaCopyArray = new_confirm_para_array;
    NSString *josnString = [self.orderConfirmParaCopyArray yy_modelToJSONString];
    NSDictionary *para = @{@"order":josnString};
    [YBLRequstTools HTTPPostWithUrl:url_orders
                            Parames:[para mutableCopy]
                          commplete:^(id result,NSInteger statusCode) {
                              [SVProgressHUD dismiss];
                              self.takeOrderModel = [YBLTakeOrderModel yy_modelWithJSON:result];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error,NSInteger errorCode) {
                                [subject sendError:error];
                            }];
     
    return subject;
   
}

- (void)resetOrderConfirmParaArray{
    
    NSInteger index = 0;
    for (YBLTakeOrderParaItemModel *paraItemModel in self.orderConfirmParaCopyArray) {
        YBLCartModel *cartModel =  self.orderConfirmModel.shop_line_items[index];
        NSInteger index2 = 0;
        for (YBLTakeOrderParaLineItemsModel *paraLineItemModel in paraItemModel.line_items) {
            
            lineitems *itemsModel = cartModel.line_items[index2];
            //已选参数数据
            paraLineItemModel.product_payment_method_id = nil;
            paraLineItemModel.product_shipping_method_id = nil;
            paraLineItemModel.select_product_shipping_method_name = nil;
            paraLineItemModel.select_product_payment_method_name = nil;
            paraLineItemModel.pick_up_address_id = nil;
            paraLineItemModel.shipping_price = nil;
            //已选数据
            itemsModel.product.selectAddressModel = nil;
            itemsModel.select_product_payment_methods = nil;
            itemsModel.select_product_shipping_methods = nil;
            itemsModel.select_pickup_address_model = nil;
            itemsModel.select_shipping_price_item_model = nil;
        }
        index2++;
    }
}

- (void)setOrderConfirmModel:(YBLOrderConfirmModel *)orderConfirmModel{
    _orderConfirmModel = orderConfirmModel;
    if (self.orderConfirmModel.default_ship_address.id) {
        self.isHaveAddress = YES;
    } else {
        self.isHaveAddress = NO;
    }
    //33.遍历self.dataArray  ==>> 过滤
    NSInteger allNoCanTakeOrderCount = 0;
    NSInteger allGoodCount = 0;
    NSInteger index = 0;
    for (YBLCartModel *new_cart_model in _orderConfirmModel.shop_line_items) {
        
        YBLTakeOrderParaItemModel *para_item_model = self.orderConfirmParaCopyArray[index];
        NSMutableArray *new_filter_item_array = [NSMutableArray array];
        NSMutableArray *para_filter_item_array = [NSMutableArray array];
        
        NSInteger index_1 = 0;
        for (lineitems *new_item_model in new_cart_model.line_items) {
            if (!new_item_model.no_permit_check_result.no_permit.boolValue) {
                //no_permit  为fasle  可以购买!!!
                NSString *default_payment = nil;
                NSString *default_shippingment = nil;
                
                YBLShippingPriceItemModel *priceItemModel = new_item_model.product.shipping_prices[0];
                //product_shipping_methods
                NSMutableArray *new_filter_ship_array = [NSMutableArray array];
                for (YBLShowPayShippingsmentModel *shipModel in new_item_model.product.product_shipping_methods) {
                    if (shipModel.shipping_method.same_city.boolValue == priceItemModel.same_city.boolValue) {
                        [new_filter_ship_array addObject:shipModel];
                        if (shipModel.is_default.boolValue) {
                            default_shippingment = shipModel.shipping_method.name;
                        }
                    }
                }
                new_item_model.product.filter_product_shiping_methods = new_filter_ship_array;
                
                //product_payment_methods
                NSMutableArray *new_filter_pay_array = [NSMutableArray array];
                for (YBLShowPayShippingsmentModel *payModel in new_item_model.product.product_payment_methods) {
                    if (payModel.payment_method.same_city.boolValue == priceItemModel.same_city.boolValue) {
                        [new_filter_pay_array addObject:payModel];
                        if (payModel.is_default.boolValue) {
                            default_payment = payModel.payment_method.name;
                        }
                    }
                }
                new_item_model.product.filter_product_payment_methods = new_filter_pay_array;
                //
                [new_filter_item_array addObject:new_item_model];
                
                /**
                 *  抽离默认方式到para_model
                 */
                YBLTakeOrderParaLineItemsModel *para_filter_line_item_model = [YBLTakeOrderParaLineItemsModel new];
                para_filter_line_item_model.line_item_id = new_item_model.line_item_id;
                para_filter_line_item_model.quantity = new_item_model.quantity;
                para_filter_line_item_model.select_product_payment_method_name = default_payment;
                para_filter_line_item_model.select_product_shipping_method_name = default_shippingment;
                
                YBLTakeOrderParaShippingPriceModel *new_shipping_price_model = [YBLTakeOrderParaShippingPriceModel new];
                new_shipping_price_model.price = new_item_model.shipping_price;
                new_shipping_price_model.express_company = new_item_model.express_company;
                para_filter_line_item_model.shipping_price = new_shipping_price_model;
                
                [para_filter_item_array addObject:para_filter_line_item_model];
                /*
                YBLTakeOrderParaLineItemsModel *para_line_item_model = para_item_model.line_items[index_1];
                para_line_item_model.select_product_payment_method_name = default_payment;
                para_line_item_model.select_product_shipping_method_name = default_shippingment;
                */
            } else {
                allNoCanTakeOrderCount++;
            }
            allGoodCount++;
            
            index_1++;
        }
        new_cart_model.filter_line_items = new_filter_item_array;
        para_item_model.line_items = para_filter_item_array;
        index++;
    }

    if (allNoCanTakeOrderCount == allGoodCount) {
        self.isCanTakeOrder = NO;
    } else {
        self.isCanTakeOrder = YES;
    }
}

- (RACSignal *)orderConfirmSiganl:(NSString *)addressId{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"努力加载中..."];
    });
    /**
     *  清除当前已选数据
     */
    [self resetOrderConfirmParaArray];
    
    [[YBLShopCarViewModel confirmSignalWithParaArray:self.orderConfirmParaArray addressId:addressId] subscribeNext:^(id  _Nullable x) {
        
        self.orderConfirmModel = (YBLOrderConfirmModel *)x;
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}


- (void)setOrderConfirmParaArray:(NSMutableArray *)orderConfirmParaArray{
    _orderConfirmParaArray = orderConfirmParaArray;
    /**
     *  深复制一份para数组作为处理|操作|请求
     */
    for (YBLTakeOrderParaItemModel *itemModel in _orderConfirmParaArray) {
        [self.orderConfirmParaCopyArray addObject:[itemModel mutableCopy]];
    }
}

- (NSMutableArray *)orderConfirmParaCopyArray{
    
    if (!_orderConfirmParaCopyArray) {
        _orderConfirmParaCopyArray = [NSMutableArray array];
    }
    return _orderConfirmParaCopyArray;
}

- (float)ReCalculateCurrentSectionPrice:(NSInteger)section{
    
    //*  单个订单总价 = item_total+shippingment_total-adjustment_tatol
    float total_price = self.orderConfirmModel.shops_total.doubleValue;
    
    YBLTakeOrderParaItemModel *paraItemModel = self.orderConfirmParaCopyArray[section];
    YBLCartModel *cartModel = self.orderConfirmModel.shop_line_items[section];
    __block float sum_fee = cartModel.shipment_total.doubleValue;
    __block float sum_price = cartModel.total.doubleValue;
    for (YBLTakeOrderParaLineItemsModel *selectLineItemModel in paraItemModel.line_items) {
        //找到对应得商品
        [cartModel.line_items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            lineitems *lineItemModel = (lineitems *)obj;
            if ([lineItemModel.line_item_id isEqualToString:selectLineItemModel.line_item_id]) {
                //sum_fee = sum_fee-old_fee+change_fee
                float old_fee = lineItemModel.shipping_price.doubleValue*lineItemModel.quantity.integerValue;
                float change_fee = selectLineItemModel.shipping_price.price.doubleValue*selectLineItemModel.quantity.integerValue;
                sum_fee += -old_fee+change_fee;
                
                //sum = sum-old_sum_fee+change_sum_fee
                lineItemModel.express_company = selectLineItemModel.shipping_price.express_company;
                lineItemModel.shipping_price = selectLineItemModel.shipping_price.price;
                
                *stop = YES;
            }
        }];
        sum_price = sum_price- cartModel.shipment_total.doubleValue+sum_fee;
        cartModel.shipment_total = @(sum_fee);
        
        total_price = total_price-cartModel.total.doubleValue+sum_price;
        self.orderConfirmModel.shops_total = @(total_price);
        
        cartModel.total = @(sum_price);
        
    }
    return total_price;
}

@end

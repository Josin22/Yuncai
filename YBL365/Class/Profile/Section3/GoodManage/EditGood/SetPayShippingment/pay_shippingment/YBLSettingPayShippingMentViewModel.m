//
//  YBLSettingPayShippingMentViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSettingPayShippingMentViewModel.h"
#import "YBLAddressModel.h"
#import "YBLAddressAreaModel.h"
//#import "YBLTakeOrderPaymentMethodModel.h"
#import "YBLTakeOrderShippingmentMethodModel.h"
#import "YBLShowPayShippingsmentModel.h"
#import "YBLAreaRadiusItemModel.h"
#import "YBLGoodModel.h"

@implementation YBLSettingPayShippingMentViewModel

- (NSMutableArray *)allPaymentDataArray{
    
    if (!_allPaymentDataArray) {
        _allPaymentDataArray = [NSMutableArray array];
    }
    return _allPaymentDataArray;
}

- (NSMutableArray *)allShippingmentDataArray{
    
    if (!_allShippingmentDataArray) {
        _allShippingmentDataArray = [NSMutableArray array];
    }
    return _allShippingmentDataArray;
}

- (NSMutableArray *)allNoPayshippingmentArray{
    
    if (!_allNoPayshippingmentArray) {
        _allNoPayshippingmentArray = [NSMutableArray array];
    }
    return _allNoPayshippingmentArray;
}

- (RACSignal *)siganlForAllPayShippingMent {
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
//    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [YBLLogLoadingView showInWindow];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_shippings_and_payments
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 [YBLLogLoadingView dismissInWindow];
                                 NSArray *shipping_data_array = [NSArray yy_modelArrayWithClass:[payshippingment_model class] json:result[@"shippings"]];
                                 NSArray *pay_data_array = [NSArray yy_modelArrayWithClass:[payshippingment_model class] json:result[@"payments"]];
                                 NSMutableArray *new_shipping_data_array = [NSMutableArray arrayWithCapacity:shipping_data_array.count];
                                 for (payshippingment_model *itemModel in shipping_data_array) {
                                     YBLShowPayShippingsmentModel *new_itemModel = [YBLShowPayShippingsmentModel new];
                                     new_itemModel.shipping_method = itemModel;
                                     [new_shipping_data_array addObject:new_itemModel];
                                 }
                                 NSMutableArray *new_pay_data_array = [NSMutableArray arrayWithCapacity:pay_data_array.count];
                                 for (payshippingment_model *itemModel in pay_data_array) {
                                     YBLShowPayShippingsmentModel *new_itemModel = [YBLShowPayShippingsmentModel new];
                                     new_itemModel.payment_method = itemModel;
                                     [new_pay_data_array addObject:new_itemModel];
                                 }
                                 [self handlePayment:new_pay_data_array shippingArray:new_shipping_data_array];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (void)handlePayment:(NSMutableArray *)paymentsArray shippingArray:(NSMutableArray *)shippingsArray{
    /*先判断是否已付国志*/
    if (self.allPaymentDataArray.count!=0&&self.allShippingmentDataArray.count!=0) {
        //pay
        for (YBLShowPayShippingsmentModel *paymentModel in paymentsArray) {
        
            for (NSMutableArray *payArray in self.allPaymentDataArray) {
                [payArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    YBLShowPayShippingsmentModel *sef_paymentModel = (YBLShowPayShippingsmentModel *)obj;
                    if ([paymentModel.payment_method.id isEqualToString:sef_paymentModel.payment_method.id]) {
                        *stop = YES;
                        if (*stop == YES) {
                            paymentModel.is_select = YES;
                            [payArray replaceObjectAtIndex:idx withObject:paymentModel];
                        }
                    }
                }];
            }
        }
        
        //shipping
        for (YBLShowPayShippingsmentModel *shippingmentModel in shippingsArray) {
            
            for (NSMutableArray *payArray in self.allShippingmentDataArray) {
                [payArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    YBLShowPayShippingsmentModel *sef_shippingmentModel = (YBLShowPayShippingsmentModel *)obj;
                    if ([shippingmentModel.shipping_method.id isEqualToString:sef_shippingmentModel.shipping_method.id]) {
                        *stop = YES;
                        if (*stop == YES) {
                            if (shippingmentModel.addresses.count!=0) {
                                for (YBLAddressModel *address in shippingmentModel.addresses) {
                                    address.is_select = YES;
                                }
                            }
                            if (shippingmentModel.area_text.count!=0) {
                                for (YBLAddressAreaModel *areaModel in shippingmentModel.area_text) {
                                    areaModel.isSelect = YES;
                                }
                            }
                            shippingmentModel.is_select = YES;
                            [payArray replaceObjectAtIndex:idx withObject:shippingmentModel];
                        }
                    }
                }];
            }
        }

        return;
    }
    
    //处理支付方式
    NSMutableArray *header_paymentArray = [NSMutableArray array];
    NSMutableArray *same_paymentArray = [NSMutableArray array];
    NSMutableArray *no_same_paymentArray = [NSMutableArray array];
    for (YBLShowPayShippingsmentModel *payment_model in paymentsArray) {
        if (payment_model.payment_method.same_city.boolValue) {
            [same_paymentArray addObject:payment_model];
        } else {
            [no_same_paymentArray addObject:payment_model];
        }
    }
    [header_paymentArray addObject:same_paymentArray];
    [header_paymentArray addObject:no_same_paymentArray];
    //处理配送方式
    NSMutableArray *cell_shippingmentArray = [NSMutableArray array];
    NSMutableArray *sameCiryPayShippingmentArray = [NSMutableArray array];
    NSMutableArray *no_sameCiryPayShippingmentArray = [NSMutableArray array];
    for (YBLShowPayShippingsmentModel *shipping_model in shippingsArray) {
        if (shipping_model.shipping_method.same_city.boolValue) {
            [sameCiryPayShippingmentArray addObject:shipping_model];
        } else {
            [no_sameCiryPayShippingmentArray addObject:shipping_model];
        }
    }
    [cell_shippingmentArray addObject:sameCiryPayShippingmentArray];
    [cell_shippingmentArray addObject:no_sameCiryPayShippingmentArray];
    
    //array -->> [同城+异地]
    self.allPaymentDataArray = header_paymentArray;
    self.allShippingmentDataArray = cell_shippingmentArray;
}
/*
- (NSInteger)isHaveDefaultPayShippingment{
    
    return [self isHaveSelectPayShippingmentIsDefault:YES];
}

- (NSInteger)isHaveSelectPayShippingment{

    return [self isHaveSelectPayShippingmentIsDefault:NO];
}


- (NSInteger)isHaveSelectPayShippingmentIsDefault:(BOOL)isDefault{
    
    
    NSInteger default_count = 0;
    NSInteger select_count = 0;
    for (NSMutableArray *payArray in self.allPaymentDataArray) {
        for (YBLShowPayShippingsmentModel *paymentModel in payArray) {
            if (isDefault) {
                if (paymentModel.is_default.boolValue) {
                    default_count++;
                }
            } else {
                if (paymentModel.is_select) {
                    select_count++;
                }
            }
        }
    }
    for (NSMutableArray *shippingArray in self.allShippingmentDataArray) {
        for (YBLShowPayShippingsmentModel *shippingmentModel in shippingArray) {
            if (isDefault) {
                if (shippingmentModel.is_default.boolValue) {
                    default_count++;
                }
            } else {
                if (shippingmentModel.is_select) {
                    select_count++;
                }
            }
        }
    }
    NSInteger allCount = 4;
    
    if (isDefault) {
        
        return allCount-default_count;

    } else {
        
        return allCount-select_count;
    }
}

 */

- (NSArray *)isHasChooseSameCityShipPayment:(BOOL)isSameCity{
    
    NSInteger default_count = 0;
    NSInteger select_pay_count = 0;
    NSInteger select_ship_count = 0;
    NSInteger select_ship_value_count = 0;
    NSInteger index_same = 0;
    if (isSameCity) {
        index_same = 0;
    } else {
        index_same = 1;
    }
    NSMutableArray *payArray = self.allPaymentDataArray[index_same];
    for (YBLShowPayShippingsmentModel *paymentModel in payArray) {
        if (paymentModel.is_default.boolValue) {
            default_count++;
        }
        if (paymentModel.is_select) {
            select_pay_count++;
        }
    }
    NSMutableArray *shippingArray = self.allShippingmentDataArray[index_same];
    for (YBLShowPayShippingsmentModel *shippingmentModel in shippingArray) {
        if (shippingmentModel.is_select) {
            
            select_ship_count++;
            
            NSInteger count = 0;
            NSString * sef_code = shippingmentModel.shipping_method.code;
            if ([sef_code isEqualToString:@"tcps"]) {
                //同城配送  --->>当前城市
                count = shippingmentModel.radius_prices.count;
                
            } else if ([sef_code isEqualToString:@"shsm"]){
                //送货上门  -->>全国
                count = shippingmentModel.area_text.count;
                
            } else if ([sef_code isEqualToString:@"smzt"]) {
                //上门自提  --->>自提地址库
                count = shippingmentModel.addresses.count;
                
            } else {
                count = 1;
            }
            if (count>0&&shippingmentModel.is_default.boolValue&&shippingmentModel.is_select) {
                default_count++;
            }
            if (count>0) {
                select_ship_value_count++;
            }
        }
    }
    //默认数量 支付方式选择数量 配送方式选中数量  配送方式value数量
    return @[@(default_count),@(select_pay_count),@(select_ship_count),@(select_ship_value_count)];
}


- (NSMutableArray *)getShippingmentParaArray{
    //配送
    NSMutableArray *paraShippingmentArray = [NSMutableArray array];
    for (NSMutableArray *shippingArray in self.allShippingmentDataArray) {
        for (YBLShowPayShippingsmentModel *shippingmentModel in shippingArray) {
            if (shippingmentModel.is_select) {
                
                NSMutableDictionary *shippingParaDict = [NSMutableDictionary dictionary];
                shippingParaDict[@"shipping_method_id"] = shippingmentModel.shipping_method.id;
                /*area*/
                /*address_ids*/
                NSMutableArray *addressArray = [NSMutableArray array];
                for (YBLAddressModel *model in shippingmentModel.addresses) {
                    [addressArray addObject:model.id];
                }
                shippingParaDict[@"address_ids"] = addressArray;
                /*radius_prices*/
                NSMutableArray *radius_prices = [NSMutableArray array];
                for (YBLAreaRadiusItemModel *radiusModel in shippingmentModel.radius_prices) {
                    [radius_prices addObject:@[@(radiusModel.radius.integerValue),radiusModel.price]];
                }
                shippingParaDict[@"radius_prices"] = radius_prices;
                shippingParaDict[@"default"] = shippingmentModel.is_default;
                [paraShippingmentArray addObject:shippingParaDict];
            }
        }
    }
    return paraShippingmentArray;
}

- (NSMutableArray *)getPaymentParaArray{
    //支付
    NSMutableArray *paraPaymentArray = [NSMutableArray array];
    for (NSMutableArray *payArray in self.allPaymentDataArray) {
        for (YBLShowPayShippingsmentModel *paymentModel in payArray) {
            if (paymentModel.is_select) {
                NSMutableDictionary *paymentParaDict = [NSMutableDictionary dictionary];
                paymentParaDict[@"payment_method_id"] = paymentModel.payment_method.id;
                paymentParaDict[@"default"] = paymentModel.is_default;
                paymentParaDict[@"down_payment_percent"] = @(paymentModel.down_payment_percent);
                [paraPaymentArray addObject:paymentParaDict];
            }
        }
    }
    
    return paraPaymentArray;
}

- (RACSignal *)siganlForNoPayShippingMentProduct{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_product_no_pay_shippings_products
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLGoodModel class] json:result];
                                 self.allNoPayshippingmentArray = [dataArray mutableCopy];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (NSMutableArray *)selectCompanyGoodListDataArray{
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (id model in self.allNoPayshippingmentArray) {
        NSNumber *selectNumber = [model valueForKey:@"is_select"];
        if (selectNumber.boolValue) {
            [tempArray addObject:model];
        }
    }
    return tempArray;
}

- (RACSignal *)siganlForSettingShippingPayment{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSMutableArray *idsArray = [NSMutableArray array];
    /**
     *  批量商品判断
     */
    if (self.settingPayShippingMentVCType == SettingPayShippingMentVCTypeManyGoodChange) {
        NSMutableArray *selectGoodArray = [self selectCompanyGoodListDataArray];
        if (selectGoodArray.count==0) {
            [SVProgressHUD showErrorWithStatus:@"您还没有选择商品呢~"];
            return subject;
        }
        for (id model in self.selectCompanyGoodListDataArray) {
            NSString *id = [model valueForKey:@"id"];
            [idsArray addObject:id];
        }
    } else {
        [idsArray addObject:self._id];
    }
    NSString *codeString = @"";
    for (NSString *_id in idsArray) {
        codeString = [codeString stringByAppendingString:[NSString stringWithFormat:@",%@",_id]];
    }
    codeString = [codeString substringFromIndex:1];
    NSMutableArray *shipingmentsArray = [self getShippingmentParaArray];;
    NSMutableArray *paymentsArray = [self getPaymentParaArray];
    [SVProgressHUD showWithStatus:@"设置中..."];
    NSDictionary *pp = @{@"ids":codeString,@"shippings":[shipingmentsArray yy_modelToJSONString],@"payments":[paymentsArray yy_modelToJSONString]};
    NSData *pData = [pp yy_modelToJSONData];

    [YBLRequstTools HTTPWithType:RequestTypePOST
                             Url:url_shippings_and_payments
                            body:pData
                         Parames:nil
                       commplete:^(id result, NSInteger statusCode) {
                           [SVProgressHUD showSuccessWithStatus:@"设置成功~"];
                           [subject sendCompleted];
                       }
                         failure:^(NSError *error, NSInteger errorCode) {
                             [subject sendError:error];
                         }];
    
    return subject;
}

- (RACSignal *)siganlForGetShippingPayment {

    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_shippings_and_payments_id(self._id)
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
//                                 [SVProgressHUD dismiss];
                                 [YBLLogLoadingView dismissInWindow];
                                 
                                 NSArray *product_shipping_methods_array = [NSArray yy_modelArrayWithClass:[YBLShowPayShippingsmentModel class] json:result[@"product_shipping_methods"]];
                                 NSArray *product_payment_methods_array = [NSArray yy_modelArrayWithClass:[YBLShowPayShippingsmentModel class] json:result[@"product_payment_methods"]];
                                 NSMutableArray *mutable_shipping = [NSMutableArray arrayWithArray:product_shipping_methods_array];
                                 NSMutableArray *mutable_payment = [NSMutableArray arrayWithArray:product_payment_methods_array];

                                 [self handlePayment:mutable_payment shippingArray:mutable_shipping];
                                 
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}


@end

//
//  YBLSelectPayShipsMentViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSelectPayShipsMentViewModel.h"
#import "YBLTakeOrderParaItemModel.h"

@implementation YBLSelectPayShipsMentViewModel

- (NSMutableArray *)titleArray{
    
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithCapacity:2];
        [_titleArray addObject:@"支付方式"];
        [_titleArray addObject:@"配送方式"];
    }
    return _titleArray;
}

- (void)setLineItemsArray:(NSMutableArray *)lineItemsArray{
    _lineItemsArray = lineItemsArray;
    
    
}


- (void)resetPayShipmentLineitemsModel:(lineitems *)lineitemsModel isPayment:(BOOL)isPayment isWLZT:(BOOL)isWLZT{
    //支付方式
    for (YBLShowPayShippingsmentModel *model in lineitemsModel.product.filter_product_payment_methods) {
        if (isWLZT) {
            model.is_default = @(NO);
        }else {
            if (isPayment) {
                model.is_default = @(NO);
            } else {
                if ([model.payment_method.type isEqualToString:@"PaymentMethod::ExpressCollecting"]&&model.is_default.boolValue == YES) {
                    model.is_default = @(NO);
                }
            }
        
        }
    }
    //配送方式
    for (YBLShowPayShippingsmentModel *model in lineitemsModel.product.filter_product_shiping_methods) {
        if (isWLZT) {
            model.is_default = @(NO);
        } else {
            if (isPayment) {
                if ([model.shipping_method.code isEqualToString:@"wlzt"]&&model.is_default.boolValue == YES) {
                    model.is_default = @(NO);
                }
            } else {
                model.is_default = @(NO);
            }
            
        }
    }
}


- (void)chooseWLZTShipPaymentModelWith:(lineitems *)lineitemsModel{
    //定位商品product_payment_methods和product_shipingment_methods
    [lineitemsModel.product.product_payment_methods enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YBLShowPayShippingsmentModel *item = (YBLShowPayShippingsmentModel *)obj;
        if ([item.payment_method.type isEqualToString:@"PaymentMethod::ExpressCollecting"]) {
            [item setValue:@(YES) forKey:@"is_default"];
            [lineitemsModel setValue:item forKey:@"select_product_payment_methods"];
            *stop = YES;
        }
    }];
    [lineitemsModel.product.product_shipping_methods enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YBLShowPayShippingsmentModel *item = (YBLShowPayShippingsmentModel *)obj;
        if ([item.shipping_method.code isEqualToString:@"wlzt"]) {
            [item setValue:@(YES) forKey:@"is_default"];
            [lineitemsModel setValue:item forKey:@"select_product_shipping_methods"];
            *stop = YES;
        }
    }];
}

- (BOOL)checkAllPayShippingmentIsSelect{

    NSInteger totalCount = self.lineItemsArray.count*2;
    NSInteger selectCount = 0;
    for (lineitems *itemModel in self.lineItemsArray) {
        
        for (YBLShowPayShippingsmentModel *paymentModel in itemModel.product.filter_product_payment_methods) {
            if (paymentModel.is_default.boolValue) {
                selectCount++;
            }
        }
        for (YBLShowPayShippingsmentModel *shippingmentModel in itemModel.product.filter_product_shiping_methods) {
            if (shippingmentModel.is_default.boolValue) {
                selectCount++;
            }
        }
    }
    
    if (selectCount==totalCount) {
        return YES;
    } else {
        return NO;
    }
}

- (void)handleParaPayShippingmentArray{
    
    NSInteger index = 0;
    for (lineitems *itemsModel in self.lineItemsArray) {
        //当前商品的支付方式
        YBLTakeOrderParaLineItemsModel *para_lineModel = self.paraLineItemsArray[index];
        para_lineModel.product_payment_method_id = nil;
        para_lineModel.product_shipping_method_id = nil;
        para_lineModel.select_product_shipping_method_name = nil;
        para_lineModel.select_product_payment_method_name = nil;
        para_lineModel.pick_up_address_id = nil;
        para_lineModel.shipping_price = nil;
        
        for (YBLShowPayShippingsmentModel *paymentModel in itemsModel.product.filter_product_payment_methods) {
            if (paymentModel.is_default.boolValue) {
                para_lineModel.product_payment_method_id = paymentModel.id;
                para_lineModel.select_product_payment_method_name = paymentModel.payment_method.name;
                
            }
        }
        //当前商品的配送方式
        for (YBLShowPayShippingsmentModel *shippingmentModel in itemsModel.product.filter_product_shiping_methods) {
            if (shippingmentModel.is_default.boolValue) {
                para_lineModel.product_shipping_method_id = shippingmentModel.id;
                para_lineModel.select_product_shipping_method_name = shippingmentModel.shipping_method.name;
                
            }
        }
        
        if ([itemsModel.select_product_shipping_methods.shipping_method.code isEqualToString:@"wlzt"]) {
            //物流自提
            [itemsModel.product.shipping_prices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YBLShippingPriceItemModel *priceItemModel = (YBLShippingPriceItemModel *)obj;
                if (priceItemModel.is_select.boolValue) {
                    YBLTakeOrderParaShippingPriceModel *shipPriceModel = [YBLTakeOrderParaShippingPriceModel new];
                    shipPriceModel.price = priceItemModel.price;
                    shipPriceModel.express_company = priceItemModel.express_company;
                    para_lineModel.shipping_price = shipPriceModel;
                    *stop = YES;
                }
            }];
        }
        if ([itemsModel.select_product_shipping_methods.shipping_method.code isEqualToString:@"smzt"]) {
            //上门自提地址
            [itemsModel.select_product_shipping_methods.addresses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YBLAddressModel *selectAddressModel = (YBLAddressModel *)obj;
                if (selectAddressModel.is_select) {
                    para_lineModel.pick_up_address_id = selectAddressModel.id;
                    *stop = YES;
                }
            }];
        }
        if ([itemsModel.select_product_shipping_methods.shipping_method.code isEqualToString:@"tcps"]) {
           //同城配送
            [itemsModel.product.shipping_prices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YBLShippingPriceItemModel *priceItemModel = (YBLShippingPriceItemModel *)obj;
                if (priceItemModel.same_city.boolValue) {
                    YBLTakeOrderParaShippingPriceModel *shipPriceModel = [YBLTakeOrderParaShippingPriceModel new];
                    shipPriceModel.price = priceItemModel.price;
                    shipPriceModel.express_company = priceItemModel.express_company;
                    para_lineModel.shipping_price = shipPriceModel;
                    *stop = YES;
                }
            }];
        }

        index++;
    }
    
}

@end

//
//  YBLShopCarViewModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLShopCarViewModel.h"
#import "YBLShopCarBarView.h"
#import "YBLCompanyTypePricesParaModel.h"
#import "YBLOrderConfirmModel.h"
#import "YBLTakeOrderParaItemModel.h"

@interface YBLShopCarViewModel ()

@end

@implementation YBLShopCarViewModel

#pragma mark - make data
- (RACSignal *)shopCarSigal{

    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLLogLoadingView showInWindow];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_carts_line_items
                               Parames:nil
                             commplete:^(id result,NSInteger statusCode) {
     
                                 [YBLLogLoadingView dismissInWindow];
                                 
                                 NSArray *cartArrayData = [NSArray yy_modelArrayWithClass:[YBLCartModel class] json:result];
                                 self.shopCartDataArray = [cartArrayData mutableCopy];
                                 //处理数据
                                 [self handleShopCarDataArray:self.shopCartDataArray];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error,NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (NSMutableArray *)noStockCartDataArray{
    if (!_noStockCartDataArray) {
        _noStockCartDataArray = [NSMutableArray array];
    }
    return _noStockCartDataArray;
}

- (void)handleShopCarDataArray:(NSMutableArray *)cartArrayData{
    
    if (self.noStockCartDataArray.count>0) {
        [self.noStockCartDataArray removeAllObjects];
    }
    
    for (YBLCartModel *cartModel in cartArrayData) {
        for (lineitems *items in cartModel.line_items) {
            //过滤多价格
            [YBLMethodTools filter_priceModel:items.product.prices];
            
            double fin_price = [YBLMethodTools getCurrentPriceWithCount:items.quantity.integerValue InPriceArray:items.product.prices.filter_prices];
            Prices_prices price_price = [YBLMethodTools getPrice_priceWithModel:items.product.prices];
            NSInteger minCount = price_price.minWholesaleCount;
            items.product.minCount = @(minCount);
            items.product.currentPrice = @(fin_price);
            if (items.no_permit_check_result.no_permit.boolValue) {
                [self.noStockCartDataArray addObject:items];
            }
            /*
            ///最大库存当成当前数量
            if (items.quantity.integerValue>items.product.stock.integerValue) {
                [items setValue:items.product.stock forKey:@"quantity"];
            }
            ///库存不足情况
            if (items.product.stock.integerValue == 0||items.product.minCount.integerValue>items.product.stock.integerValue) {
                items.isNotEnoughStock = YES;
                
                [self.noStockCartDataArray addObject:items];
            }
            */
            [items setValue:@(fin_price) forKey:@"lineitems_price"];
        }
    }
}

+ (RACSignal *)confirmSignalWithParaArray:(NSMutableArray *)paraArray addressId:(NSString *)addressId {
    
    return [[self alloc] confirmSignalWithParaArray:paraArray addressId:addressId isSef:NO];
}

- (RACSignal *)confirmSignalWithParaArray:(NSMutableArray *)paraArray addressId:(NSString *)addressId isSef:(BOOL)isSef{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    if (isSef) {
        [SVProgressHUD showWithStatus:@"努力加载中..."];
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSString *jsonValue = [paraArray yy_modelToJSONString];
    para[@"iteminfo"] = jsonValue;
    if (addressId) {
        para[@"address_id"] = addressId;
    }
    
    [YBLRequstTools HTTPPostWithUrl:url_orders_confirm
                            Parames:para
                          commplete:^(id result,NSInteger statusCode) {
                              
                              [SVProgressHUD dismiss];
                              
                              YBLOrderConfirmModel *orderConfirmModel = [YBLOrderConfirmModel yy_modelWithJSON:result];
                              if (isSef) {
                                  self.orderConfirmModel = orderConfirmModel;
                                  /**
                                   *  赋值最新库存
                                   */
                                  [self handleShopCarDataArray:self.orderConfirmModel.shop_line_items];

                              } else {
                                  [subject sendNext:orderConfirmModel];
                              }
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error,NSInteger errorCode) {
                                
                                [subject sendError:error];
                            }];
    
    return subject;
}

- (RACSignal *)confirmSignal{
    
    NSMutableArray *itemInfoArray = [NSMutableArray array];
    
    NSMutableArray *selectCartArray = [NSMutableArray array];
    
    for (YBLCartModel *cartModel in self.shopCartDataArray) {
        YBLCartModel *selectCartModel = [YBLCartModel new];
        selectCartModel.line_items = [NSMutableArray array];
        NSMutableArray *line_item_array = [NSMutableArray array];
        for (lineitems *itemsModel in cartModel.line_items) {
            if (itemsModel.lineitems_select&&!itemsModel.no_permit_check_result.no_permit.boolValue) {
                
                YBLTakeOrderParaLineItemsModel *paraLineItemModel = [YBLTakeOrderParaLineItemsModel new];
                paraLineItemModel.line_item_id = itemsModel.itemid;
                paraLineItemModel.quantity = itemsModel.quantity;
                [line_item_array addObject:paraLineItemModel];
                /*
                NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
                itemDict[@"line_item_id"] = ietms.itemid;
                itemDict[@"quantity"] = ietms.quantity;
                [line_item_array addObject:itemDict];
                */
                [selectCartModel.line_items addObject:itemsModel];
            }
        }
        if (selectCartModel.line_items.count!=0) {
            selectCartModel.shop = cartModel.shop;
            
            [selectCartArray addObject:selectCartModel];
            
            shop *shopModel = cartModel.shop;
            YBLTakeOrderParaItemModel *paraItemModel = [YBLTakeOrderParaItemModel new];
            paraItemModel.shop_id = shopModel.shopid;
            paraItemModel.line_items = line_item_array;
            [itemInfoArray addObject:paraItemModel];
            /*
            NSMutableDictionary *itemInfoDict = [NSMutableDictionary dictionary];
            itemInfoDict[@"shop_id"] = shopModel.shopid;
            itemInfoDict[@"line_items"] = line_item_array;
            [itemInfoArray addObject:itemInfoDict];
             */
        }
        
    }
    if (itemInfoArray.count==0) {
        
        [SVProgressHUD showErrorWithStatus:@"您还没有选择商品哦~"];
        
        return nil;
        
    } else {

        self.selectCartDataArray = selectCartArray;
        
        self.orderConfirmParaArray = itemInfoArray;
   
        return [self confirmSignalWithParaArray:self.orderConfirmParaArray addressId:nil isSef:YES];
    }
}

- (RACSignal *)signalForDeleteCartItem:(NSMutableArray *)itemIDArray{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"删除中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"item"] = [itemIDArray yy_modelToJSONString];
    
    [YBLRequstTools HTTPDELETEWithUrl:url_carts_line_items
                              Parames:para
                            commplete:^(id result, NSInteger statusCode) {
                                
                                [SVProgressHUD dismiss];
                                [subject sendNext:@YES];
                                [subject sendCompleted];
                            }
                              failure:^(NSError *error, NSInteger errorCode) {
                                  [subject sendError:error];
                              }];
    
    return subject;
}

- (RACSignal *)signalForChangeItemQuantity:(NSMutableArray *)quantityArray{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"cart"] = [quantityArray yy_modelToJSONString];
    
    [YBLRequstTools HTTPPUTWithUrl:url_carts_line_items_quantity
                           Parames:para
                         commplete:^(id result, NSInteger statusCode) {
                             
                             [subject sendNext:@YES];
                             [subject sendCompleted];
                         }
                           failure:^(NSError *error, NSInteger errorCode) {
                               [subject sendError:error];
                           }];
    
    return subject;
}

#pragma mark - cao zuo

- (void)selectAll:(BOOL)isSelect{
    
    for (YBLCartModel *cartModel in self.shopCartDataArray) {
        shop *shop = cartModel.shop;
        [shop setValue:@(isSelect) forKey:@"shop_select"];
        
        for (lineitems *model in cartModel.line_items) {
            if (!model.no_permit_check_result.no_permit.boolValue) {
             [model setValue:@(isSelect) forKey:@"lineitems_select"];
            }
        }
    }
    
    [self calcuatePrices];
    
    [self.cartTableView jsReloadData];
}

- (void)sectionSelect:(BOOL)isSelect section:(NSInteger)section{
    
    YBLCartModel *cartModel = self.shopCartDataArray[section];
    shop *shop = cartModel.shop;
    [shop setValue:@(isSelect) forKey:@"shop_select"];
    
    for (lineitems *model in cartModel.line_items) {
        if (!model.no_permit_check_result.no_permit.boolValue) {
            [model setValue:@(isSelect) forKey:@"lineitems_select"];
        }
    }
    
    [self calcuatePrices];
    
    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)rowSelectButton:(UIButton *)x IndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section          = indexPath.section;
    NSInteger row              = indexPath.row;
    
    YBLCartModel *cartModel = self.shopCartDataArray[section];
    lineitems *ietms = cartModel.line_items[row];
    shop *shop = cartModel.shop;
    if (!ietms.no_permit_check_result.no_permit.boolValue) {

        x.selected = !x.selected;
        
        [ietms setValue:@(x.selected) forKey:@"lineitems_select"];
        
        //判断是都到达足够数量
        NSInteger selectGoodCount = 0;
        NSInteger normalGoodCount = 0;
        for (lineitems *model in cartModel.line_items) {
            if (!model.no_permit_check_result.no_permit.boolValue) {
                normalGoodCount++;
            }
            if (model.lineitems_select) {
                selectGoodCount++;
            }
        }
        
        [shop setValue:selectGoodCount==normalGoodCount?@YES:@NO forKey:@"shop_select"];
        
        /*重新计算价格*/
        [self calcuatePrices];
        
        [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
      
    }
    
}

- (void)rowChangeQuantity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath{
    
    NSInteger section  = indexPath.section;
    NSInteger row      = indexPath.row;
    
    YBLCartModel *cartModel = self.shopCartDataArray[section];
    lineitems *ietms = cartModel.line_items[row];
    if (!ietms.no_permit_check_result.no_permit.boolValue) {
        [ietms setValue:@(quantity) forKey:@"quantity"];
        
        double fin_price = [YBLMethodTools getCurrentPriceWithCount:ietms.quantity.integerValue InPriceArray:ietms.product.prices.filter_prices];
        [ietms setValue:@(fin_price) forKey:@"lineitems_price"];
        
        /*重新计算价格*/
        [self calcuatePrices];
        
        [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)calcuatePrices{
    
    //判断是都到达足够数量
    BOOL selectNoAll = YES;
    double all_price = 0.0;
    NSInteger all_good_count = 0;
    for (YBLCartModel *cartModel in self.shopCartDataArray) {
        shop *shop = cartModel.shop;
        if (!shop.shop_select) {
            selectNoAll = NO;
        }
        NSInteger zhong = 0;
        NSInteger jian = 0;
        double single_shop_price = 0.0;
        for (lineitems *ietms in cartModel.line_items) {
            if (ietms.lineitems_select) {
                all_price += ietms.quantity.integerValue*ietms.lineitems_price.doubleValue;
                all_good_count++;
                zhong++;
                jian += ietms.quantity.integerValue;
                single_shop_price += ietms.quantity.integerValue*ietms.lineitems_price.doubleValue;

            }
        }
        [shop setValue:[NSString stringWithFormat:@"%.2f",single_shop_price] forKey:@"shop_select_goods_price"];
        [shop setValue:@(jian) forKey:@"shop_select_goods_count"];
        [shop setValue:@(zhong) forKey:@"shop_select_goods_zhong_count"];
        shop.att_price = [NSString price:shop.shop_select_goods_price color:YBLThemeColor font:16];
    }
    
    [self.barView setGoodNumber:all_good_count];
    self.barView.checkButton.selected = selectNoAll;
//    self.barView.buyButton.enabled =all_good_count;
//    self.pay_price = all_price;
    NSString *all_price_string = [NSString stringWithFormat:@"%.2f",all_price];
    self.barView.realPriceLabel.attributedText = [NSString price:all_price_string color:YBLThemeColor font:18];
    if (self.shopCartDataArray.count==0) {
        self.barView.hidden = YES;
    }

}

//左滑删除商品
- (void)deleteGoodsBySingleSlide:(NSIndexPath *)path{
    
    NSInteger section = path.section;
    NSInteger row     = path.row;
    
    [YBLUserManageCenter shareInstance].cartsCount--;
    
    YBLCartModel *cartModel = self.shopCartDataArray[section];
    
    [cartModel.line_items removeObjectAtIndex:row];

    if (cartModel.line_items.count == 0) {
        
        [self.shopCartDataArray removeObjectAtIndex:section];
        
        //重新计算价格
        [self calcuatePrices];
        
        [self.cartTableView jsReloadData];
        
    }  else {
     
        //重新计算价格
        [self calcuatePrices];
        
        [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

//选中删除
- (void)deleteGoodsBySelect{
    
    /*1 删除数据*/
    NSInteger index1 = -1;
    NSMutableIndexSet *shopSelectIndex = [NSMutableIndexSet indexSet];
    for (NSMutableArray *shopArray in self.shopCartDataArray) {
        index1++;
        
        NSInteger index2 = -1;
        NSMutableIndexSet *selectIndexSet = [NSMutableIndexSet indexSet];
        for (YBLCartModel *model in shopArray) {
            index2++;
//            if (model.isSelect) {
//                [selectIndexSet addIndex:index2];
//            }
        }
        NSInteger shopCount = shopArray.count;
        NSInteger selectCount = selectIndexSet.count;
        if (selectCount == shopCount) {
            [shopSelectIndex addIndex:index1];
//            self.cartGoodsCount-=selectCount;
        }
        [shopArray removeObjectsAtIndexes:selectIndexSet];
    }
//    [self.shopCartDataArray removeObjectsAtIndexes:shopSelectIndex];
//    /*2 删除 shopSelectArray*/
//    [self.shopSelectArray removeObjectsAtIndexes:shopSelectIndex];
//    [self.cartTableView jsReloadData];
//    /*3 carbar 恢复默认*/
//    self.allPrices = 0;
    /*重新计算价格*/
    [self calcuatePrices];
}


+ (RACSignal *)getCurrentCartsNumber{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    if (![YBLUserManageCenter shareInstance].isLoginStatus) {
        
        [subject sendNext:@(0)];
        
        return subject;
    }
    
    [YBLRequstTools HTTPGetDataWithUrl:url_carts_product_quantity
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 NSInteger count = [result[@"line_items_count"] integerValue];
                                 [YBLUserManageCenter shareInstance].cartsCount = count;
                                 [subject sendNext:@(count)];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

@end

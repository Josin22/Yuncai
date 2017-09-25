//
//  YBLGoodsDetailViewModel.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLGoodsDetailViewModel.h"
#import "YBLAddressViewModel.h"
#import "YBLGoodParameterView.h"
#import "YBLGoodShippingPriceModel.h"
#import "YBLGoodsDetailViewController.h"

@implementation YBLGoodsDetailViewModel

- (NSMutableArray *)paraDataArray{
    if (!_paraDataArray) {
        _paraDataArray = [NSMutableArray array];
    }
    
    return _paraDataArray;
}

- (NSMutableArray *)cellIDArray{
    
    if (!_cellIDArray) {
        _cellIDArray = [NSMutableArray array];
        //section0  @{cell_identity_key:@"YBLSeckillGoodsPriceCell"}
        NSMutableArray *section0 = [NSMutableArray array];
        [section0 addObject:@{cell_identity_key:@"YBLGoodsDetailInfoCell"}];
        [section0 addObject:@{cell_identity_key:@"YBLGoodsWholesalePriceCell"}];
        [section0 addObject:@{cell_identity_key:@"YBLGoodsOriginInfoCell"}];
        [_cellIDArray addObject:section0];
        //section1
        [_cellIDArray addObject:@[@{cell_identity_key:@"YBLSpecInfoCell"}]];
//        [_cellIDArray addObject:@[@{cell_identity_key:@"YBLGoodsPromotionCell"}]];
        [_cellIDArray addObject:@[@{cell_identity_key:@"YBLGoodsSpecCell"}]];
        //section2
        [_cellIDArray addObject:@[@{cell_identity_key:@"YBLGoodsDeliverToCell"}]];
        //section3
//        NSMutableArray *section4 = [NSMutableArray array];
//        for (int i = 0; i < 3; i++) {
//            [section4 addObject:@{cell_identity_key:@"YBLGoodsEvaluateCell"}];
//        }
//        [_cellIDArray addObject:section4];
        //section4
        [_cellIDArray addObject:@[@{cell_identity_key:@"YBLGoodsStoreCell"}]];
        //section5
//        [_cellIDArray addObject:@[@{cell_identity_key:@"YBLGoodsHotListCell"}]];
    }
    return _cellIDArray;
}

- (NSMutableArray *)addressArray{
    if (!_addressArray) {
        _addressArray = [NSMutableArray array];
    }
    return _addressArray;
}

+ (RACSignal *)goodDetailSignalWithID:(NSString *)gID{
    
    return [[self alloc] goodDetailSignalWithGoodId:gID isSelf:NO];
}

- (RACSignal *)goodDetailSignal{
    return [self goodDetailSignalWithGoodId:self.goodID isSelf:YES];
}

- (RACSignal *)siganlForAddress{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[YBLAddressViewModel siganlForAllAddress] subscribeNext:^(id  _Nullable x) {
        
        self.addressArray = (NSMutableArray *)x;
        if (self.addressArray.count>0) {
            self.goodDetailModel.selectAddressModel = self.addressArray[0];
        } else {
            self.goodDetailModel.selectAddressModel = nil;
        }
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}

- (RACSignal *)goodDetailSignalWithGoodId:(NSString *)gID isSelf:(BOOL)isSelf{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLLogLoadingView showInWindow];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_products_products_id(gID)
                               Parames:nil
                             commplete:^(id result,NSInteger statusCode) {
                                 
                                 [YBLLogLoadingView dismissInWindow];
                                 
                                 YBLGoodModel *model = [YBLGoodModel yy_modelWithJSON:result[@"product"]];
                                 
                                 //prices
                                 YBLCompanyTypePricesParaModel *pricesModel = [YBLCompanyTypePricesParaModel yy_modelWithJSON:result[@"prices"]];
                                 [model setValue:pricesModel forKey:@"prices"];
                                 
                                 //shipping_price
                                 NSMutableArray *shipping_price_array = [[NSArray yy_modelArrayWithClass:[YBLGoodShippingPriceModel class] json:result[@"shipping_prices"]] mutableCopy];
                                 [model setValue:shipping_price_array forKey:@"shipping_prices"];
                                 
                                 //comments
                                 NSArray *commentsArray = [NSArray yy_modelArrayWithClass:[YBLOrderCommentsModel class] json:result[@"comments"]];
                                 for (YBLOrderCommentsModel *itemModel in commentsArray) {
                                     if (itemModel.anonymity.boolValue) {
                                         itemModel.k_user_name = [YBLMethodTools changeToNiMing:itemModel.user_name];
                                     } else {
                                         itemModel.k_user_name = itemModel.user_name;
                                     }
                                     CGSize contentSize = [itemModel.content heightWithFont:YBLFont(14) MaxWidth:YBLWindowWidth-space];
                                     itemModel.content_height = @(contentSize.height>40?40:contentSize.height);
                                 }
                                 //coupons
                                 NSArray *couponsArray = [NSArray yy_modelArrayWithClass:NSClassFromString(@"YBLGoodDetailCouponsModel") json:result[@"coupons"]];
                                 
                                 [model setValue:commentsArray.mutableCopy forKey:@"comments"];
                                 [model setValue:result[@"comments_total"] forKey:@"comments_total"];
                                 [model setValue:result[@"good_comments_rate"] forKey:@"good_comments_rate"];
                                 [model setValue:couponsArray.mutableCopy forKey:@"coupons"];
                                 
                                 
                                 if (isSelf) {
                                     if (model.coupons.count>0) {
                                         [self.cellIDArray insertObject:@[@{cell_identity_key:@"YBLCouponsLabelsCell"}] atIndex:1];
                                     }
                                     if (_paraDataArray.count>0) {
                                         [_paraDataArray removeAllObjects];
                                     }
                                     for (NSString *key in [model.properties allKeys]) {
                                         NSString *value_value = model.properties[key];
                                         NSString *value_name = [model.properties_with_name[key] stringByAppendingString:@" :"];
                                         [self.paraDataArray addObject:[GoodParaModel getModelWithTitle:value_name value:value_value]];
                                     }
                                     [self.paraDataArray addObject:[GoodParaModel getModelWithTitle:@"商品条码 :" value:[NSString stringWithFormat:@"%@",model.qrcode]]];
                                     [self.paraDataArray addObject:[GoodParaModel getModelWithTitle:@"生产厂家 :" value:model.manufacturer]];
                                     
                                     [YBLMethodTools filter_priceModel:model.prices];
                                     
                                     Prices_prices price_price = [YBLMethodTools getPrice_priceWithModel:model.prices];
                                     NSInteger minCount = price_price.minWholesaleCount;
                                     float currentPrice = price_price.currentPrice;
                                     
                                     model.minCount = @(minCount);
                                     model.quantity = @(minCount);
                                     model.currentPrice = @(currentPrice);
                                     
                                     //perice
                                     [model setValue:@(currentPrice) forKey:@"price"];
                                
                                     self.carBarEnable = !model.no_permit_check_result.no_permit.boolValue;
                                     self.goodDetailModel = model;
                                     self.isFollowed = [result[@"followed"] boolValue];
                                     NSMutableArray *section4 = @[].mutableCopy;
                                     if (model.comments.count!=0) {
                                         for (int i = 0; i < model.comments.count; i++) {
                                             [section4 addObject:@{cell_identity_key:@"YBLGoodsEvaluateCell",}];
                                         }
                                     } else {
                                         [section4 addObject:@{cell_identity_key:@"YBLNoneEvaluateCell",}];
                                     }
                                     [self.cellIDArray insertObject:section4 atIndex:4];
                                 } else {
                                     [subject sendNext:model];
                                 }
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error,NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

+ (RACSignal *)addCartWithQuantity:(NSInteger)quantity goodID:(NSString *)pid{
    
    return [[self alloc] addCartWithQuantity:quantity goodID:pid];
}

- (RACSignal *)addCartWithQuantity:(NSInteger)quantity goodID:(NSString *)pid{
    
    RACReplaySubject *subject = [RACReplaySubject subject];

    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"product_id"] = pid;
    para[@"quantity"] = @(quantity);
    
    [YBLRequstTools HTTPPostWithUrl:url_carts_line_items_onebyone_quantity
                            Parames:para
                          commplete:^(id result,NSInteger statusCode) {
                              
                              [subject sendNext:@YES];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error,NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}
/**
 *  根据地址获取物流价格
 */
- (RACSignal *)siganlForShippingPrice{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"ship_address_id"] = self.goodDetailModel.selectAddressModel.id;
    
    [YBLRequstTools HTTPGetDataWithUrl:url_product_shiping_price(self.goodID)
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLShippingPriceItemModel class] json:result];
                                 if (dataArray.count>0) {
                                     YBLShippingPriceItemModel *shipPriceModel = dataArray[0];
                                     self.goodDetailModel.expressCompanyItemModel = shipPriceModel;
                                     self.carBarEnable = !shipPriceModel.no_permit_check_result.no_permit.boolValue;
                                 } else {
                                     self.goodDetailModel.expressCompanyItemModel = nil;
                                     self.carBarEnable = NO;
                                 }
                                 [subject sendNext:dataArray];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

+ (RACSignal *)signalForGood:(NSString *)goodID isFollow:(BOOL)isFollow{
    return [[self alloc] signalForGood:goodID isFollow:isFollow];
}

- (RACSignal *)signalForGoodFollow:(BOOL)isFollow{
    return [self signalForGood:self.goodID isFollow:isFollow];
}

- (RACSignal *)signalForGood:(NSString *)goodID isFollow:(BOOL)isFollow{

    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSString *new_url= nil;
    NSString *fousString = nil;
    if (!isFollow) {
        //取消关注
        fousString = @"取消";
        new_url = url_product_unfollow(goodID);
    } else {
        //关注
        fousString = @"关注";
        new_url = url_product_follow(goodID);
    }
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%@中...",fousString]];
    [YBLRequstTools HTTPPostWithUrl:new_url
                            Parames:nil
                          commplete:^(id result, NSInteger statusCode) {
                              
                              [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@成功~",fousString]];
                              [subject sendNext:result];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

+ (RACSignal *)singalForGoodIDWithQrcid:(NSString *)qrcID selfVc:(UIViewController *)selfVc{
    RACReplaySubject *subject = [RACReplaySubject subject];
//    WEAK
    [[self singalForGoodIDWithQrcid:qrcID] subscribeNext:^(id  _Nullable x) {
//        STRONG
        YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
        viewModel.goodID = x;
        YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
        goodDetailVC.viewModel = viewModel;
        [selfVc.navigationController pushViewController:goodDetailVC animated:YES];
        [subject  sendNext:x];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    return subject;
}

+ (RACSignal *)singalForGoodIDWithQrcid:(NSString *)qrcID{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSMutableDictionary*para = [NSMutableDictionary dictionary];
    para[@"qrcode"] = qrcID;
    
    [YBLRequstTools HTTPGetDataWithUrl:url_products_products_qrcode
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 [SVProgressHUD dismiss];
                                 [subject sendNext:result[@"id"]];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

@end

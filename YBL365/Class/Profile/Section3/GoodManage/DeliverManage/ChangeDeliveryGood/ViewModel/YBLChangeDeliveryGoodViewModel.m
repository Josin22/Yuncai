//
//  YBLChangeDeliveryGoodViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLChangeDeliveryGoodViewModel.h"
#import "YBLGetProductShippPricesModel.h"

@implementation YBLChangeDeliveryGoodViewModel

- (NSMutableDictionary *)getAreaPriceDataDict{
    if (!_getAreaPriceDataDict) {
        _getAreaPriceDataDict = [NSMutableDictionary dictionary];
    }
    return _getAreaPriceDataDict;
}

- (NSMutableDictionary *)getExpressCompanyDataDict{
    if (!_getExpressCompanyDataDict) {
        _getExpressCompanyDataDict = [NSMutableDictionary dictionary];
    }
    return _getExpressCompanyDataDict;
}

+ (RACSignal *)getShippingPricesSiganlWithID:(NSString *)_id{
    
    return [[self alloc] getShippingPricesSiganlWithID:_id isSelf:NO];
}

- (RACSignal *)getShippingPricesSiganl{
    
    return [self getShippingPricesSiganlWithID:self._id isSelf:YES];
}

- (RACSignal *)getShippingPricesSiganlWithID:(NSString *)_id isSelf:(BOOL )isSelf{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_products_shipping_prices(_id)
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLGetProductShippPricesModel class] json:result];
                                 if (!isSelf) {
                                     [subject sendNext:dataArray];
                                 } else {
                                     for (YBLGetProductShippPricesModel *itemModel in dataArray) {
                                         [self.getExpressCompanyDataDict setObject:itemModel.express_company forKey:itemModel.express_company.id];
                                         [self.getAreaPriceDataDict setObject:itemModel.area_prices forKey:itemModel.express_company.id];
                                     }
                                 }
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (RACSignal *)settingGoodShippingPriceSiganl{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"保存中..."];
    
    NSMutableArray *shipping_prices_price = [NSMutableArray array];
    for (YBLExpressCompanyItemModel *model in [self.getExpressCompanyDataDict allValues]) {
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionaryWithCapacity:2];
        itemDict[@"express_company_id"] = model.id;
        NSMutableArray *all_area_price_array = [NSMutableArray array];
        for (area_prices *areaID in self.getAreaPriceDataDict[model.id]) {
            NSArray *areaPriceArray = @[areaID.area_id,areaID.price];
            [all_area_price_array addObject:areaPriceArray];
        }
        itemDict[@"area_prices"] = all_area_price_array;
        [shipping_prices_price addObject:itemDict];
    }
    
    NSDictionary *pp = @{@"shipping_prices":[shipping_prices_price yy_modelToJSONString],@"ids":self._id};
    NSData *pData = [pp yy_modelToJSONData];
    
    [YBLRequstTools HTTPWithType:RequestTypePOST
                             Url:url_products_set_shipping_prices
                            body:pData
                         Parames:nil
                       commplete:^(id result, NSInteger statusCode) {
                           [SVProgressHUD showSuccessWithStatus:@"保存成功~"];
                           
                           [subject sendCompleted];
                       }
                         failure:^(NSError *error, NSInteger errorCode) {
                             [subject sendError:error];
                         }];
    return subject;
    
}

@end

//
//  YBLChooseDeliveryViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLChooseDeliveryViewModel.h"
#import "YBLExpressCompanyItemModel.h"
#import "YBLGoodModel.h"
#import "YBLAddressAreaModel.h"

@implementation YBLChooseDeliveryViewModel

- (NSMutableArray *)selectExpressCompanyArray{
    if (!_selectExpressCompanyArray) {
        _selectExpressCompanyArray = [NSMutableArray array];
    }
    return _selectExpressCompanyArray;
}

- (NSMutableArray *)selectGoodsArray{
    if (!_selectGoodsArray) {
        _selectGoodsArray = [NSMutableArray array];
    }
    return _selectGoodsArray;
}

- (NSMutableArray *)addToAreaAddressArray{

    NSMutableArray *addArray = [NSMutableArray array];
    for (YBLExpressCompanyItemModel *model in self.selectExpressCompanyArray) {
        if (model.is_select) {
            [addArray addObject:model];
        }
    }
    return addArray;
}

- (BOOL)isHaveSelectGoods{
    
    NSInteger count = 0;
    for (YBLGoodModel *model in self.selectGoodsArray) {
        if (model.is_select) {
            count++;
        }
    }
    if (count>0) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isHaveSelectExpressCompany{
 
    NSInteger count = self.addToAreaAddressArray.count;
    if (count>0) {
        return YES;
    } else {
        return NO;
    }
}

+ (RACSignal *)validExpressCompaniesSiganl{
    
    return [[self alloc] validExpressCompaniesSiganlIsSelf:NO];
}

- (RACSignal *)validExpressCompaniesSiganl{
    
    return [self validExpressCompaniesSiganlIsSelf:YES];
}

- (RACSignal *)validExpressCompaniesSiganlIsSelf:(BOOL)isSelf{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_express_companies_valid_express_companies
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLExpressCompanyItemModel class] json:result];
                                 if (isSelf) {
                                     self.selectExpressCompanyArray = [dataArray mutableCopy];
                                 } else {
                                     [subject sendNext:[dataArray mutableCopy]];
                                 }
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (RACSignal *)siganlForSettingShippingsPricesWith:(NSMutableDictionary *)selectAreaDict{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"保存中..."];
    //ids
    NSMutableArray *idsArray = [NSMutableArray array];
    for (YBLGoodModel *model in self.selectGoodsArray) {
        if (model.is_select) {
            [idsArray addObject:model.id];
        }
    }
    NSString *codeString = @"";
    for (NSNumber *idNumber in idsArray) {
        codeString = [codeString stringByAppendingString:[NSString stringWithFormat:@",%@",idNumber]];
    }
    codeString = [codeString substringFromIndex:1];
    //shipping_prices
    NSArray *allKey = [selectAreaDict allKeys];
    NSMutableArray *shipping_prices_price = [NSMutableArray array];
    for (YBLExpressCompanyItemModel *model in self.addToAreaAddressArray) {
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionaryWithCapacity:2];
        itemDict[@"express_company_id"] = model.id;
        NSMutableArray *all_area_price_array = [NSMutableArray array];
        for (NSString *areaID in allKey) {
            if (!model.price) {
                model.price = @(0);
            }
            NSArray *areaPriceArray = @[areaID,model.price];
            [all_area_price_array addObject:areaPriceArray];
        }
        itemDict[@"area_prices"] = all_area_price_array;
        [shipping_prices_price addObject:itemDict];
    }

    NSDictionary *pp = @{@"shipping_prices":[shipping_prices_price yy_modelToJSONString],@"ids":codeString};
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

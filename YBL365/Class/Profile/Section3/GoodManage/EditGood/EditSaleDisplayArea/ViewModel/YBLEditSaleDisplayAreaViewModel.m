//
//  YBLEditSaleDisplayAreaViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/19.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditSaleDisplayAreaViewModel.h"

@implementation YBLEditSaleDisplayAreaViewModel

- (RACSignal *)siganlForSaveDisplayPriceArea{
    
    return [self siganlForSaveAreaType:@"display_price_area" selectAllAreaDict:self.getSaleDisplayPriceModel.display_price_area];
}

- (RACSignal *)siganlForSaveSaleArea{
    
    return [self siganlForSaveAreaType:@"sales_area" selectAllAreaDict:self.getSaleDisplayPriceModel.sales_area];
}

- (RACSignal *)siganlForSaveAreaType:(NSString *)type selectAllAreaDict:(NSMutableArray *)areaDict{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"设置中..."];
    //处理数据
    NSString *codeString = @"";
    for (YBLAddressAreaModel *areaModel in areaDict) {
        codeString = [codeString stringByAppendingString:[NSString stringWithFormat:@",%@",areaModel.id]];
    }
    codeString = [codeString substringFromIndex:1];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"type"] = type;
    para[@"areas"] = codeString==nil?@"":codeString;
    
    [YBLRequstTools HTTPPostWithUrl:url_setareas(self._id)
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"设置成功~"];
                              if (result[@"areas"]) {
                                  [subject sendNext:@YES];
                              } else {
                                  [subject sendNext:@NO];
                              }
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    return subject;
}

+ (RACSignal *)siganlForGetAreaInfoWithID:(NSString *)_id{
    
    return [[self alloc] siganlForGetAreaInfoWithID:_id isSelf:NO];
}

- (RACSignal *)siganlForGetAreaInfo{
    
    return [self siganlForGetAreaInfoWithID:self._id isSelf:YES];
}

- (RACSignal *)siganlForGetAreaInfoWithID:(NSString *)_id isSelf:(BOOL)isSelf{
    
    RACReplaySubject *subject = [RACReplaySubject subject];

    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_sales_area_display_price_area(_id)
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 [SVProgressHUD dismiss];
                                 YBLSalesDisplayPriceModel *resultModel = [YBLSalesDisplayPriceModel yy_modelWithJSON:result];
                                 if (isSelf) {
                                     self.getSaleDisplayPriceModel = resultModel;
                                 }
                                 [subject sendNext:resultModel];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    return subject;
}

- (RACSignal *)siganlForSalesAreaStatus:(BOOL)isOn{
    
    return [self siganlForAreaType:@"enable_sales_area" isOn:isOn];
}

- (RACSignal *)siganlForDisplayPriceAreaStatus:(BOOL)isOn{
    
    return [self siganlForAreaType:@"enable_display_price_area" isOn:isOn];
}

- (RACSignal *)siganlForAreaType:(NSString *)type isOn:(BOOL)isOn{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"area"] = type;
    para[@"status"] = @(isOn);
    
    [YBLRequstTools HTTPPUTWithUrl:url_product_area_status(self._id)
                           Parames:para
                         commplete:^(id result, NSInteger statusCode) {
                             
                             [SVProgressHUD showSuccessWithStatus:@"设置成功~"];
                             [subject sendCompleted];
                         }
                           failure:^(NSError *error, NSInteger errorCode) {
                               [subject sendError:error];
                           }];
    
    return subject;
}

- (NSMutableDictionary *)getSalesPriceDict{
    
    NSMutableDictionary *sales_price_dict = [NSMutableDictionary dictionary];
    
    for (YBLAddressAreaModel *areaModel in self.getSaleDisplayPriceModel.sales_area) {
        [sales_price_dict setObject:areaModel forKey:areaModel.id];
    }
    return sales_price_dict;
}

- (NSMutableDictionary *)getDisplayPriceDict{
    
    NSMutableDictionary *display_price_dict = [NSMutableDictionary dictionary];
    
    for (YBLAddressAreaModel *areaModel in self.getSaleDisplayPriceModel.display_price_area) {
        [display_price_dict setObject:areaModel forKey:areaModel.id];
    }
    return display_price_dict;
}

@end

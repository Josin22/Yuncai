//
//  YBLLogisticsCompanyAndGoodListViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLLogisticsCompanyAndGoodListViewModel.h"
#import "YBLExpressCompanyItemModel.h"
#import "YBLGoodModel.h"
#import "YBLChooseDeliveryViewModel.h"

@implementation YBLLogisticsCompanyAndGoodListViewModel

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (RACSignal *)storeGoodListSiganlIsReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSString *userInfoID = [YBLUserManageCenter shareInstance].userModel.userinfo_id;
    
    [[self signalForShopDataWithID:userInfoID category_id:nil isReload:isReload] subscribeNext:^(NSArray*  _Nullable x) {
        NSMutableArray *indexps = x[1];
        self.dataArray = self.goodCategoryDataDict[@(0)];
        [self resetDataArray:self.dataArray
                  otherArray:self.openedExpressCompanyGoodListDataArray
                 isStoreGood:YES
                     indexps:indexps];
        [subject sendNext:indexps];
        [subject sendCompleted];

    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    /*
    [[YBLStoreViewModel signalForShopDataWithID:userInfoID] subscribeNext:^(id  _Nullable x) {
        [YBLLogLoadingView dismissInWindow];
        YBLShopModel *shopModel = x;
        self.dataArray = shopModel.products;
        [self resetDataArray:self.dataArray otherArray:self.openedExpressCompanyGoodListDataArray isStoreGood:YES];
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    */
    return subject;
}

- (RACSignal *)expressCompanyGoodListSiganl{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
//    [SVProgressHUD showWithStatus:@"加载中..."];
    [YBLLogLoadingView showInWindow];
    NSString *URL = nil;
    if (self.listVCType == ListVCTypeGood) {
        URL = url_product_no_shipping_price_products;
    } else {
        URL = url_express_companies;
    }
    [YBLRequstTools HTTPGetDataWithUrl:URL
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
//                                 [SVProgressHUD dismiss];
                                 [YBLLogLoadingView dismissInWindow];
                                 NSMutableArray *muTDataArray;
                                 if (self.listVCType == ListVCTypeGood) {
                                     muTDataArray = [NSArray yy_modelArrayWithClass:[YBLGoodModel class] json:result].mutableCopy;
                                 } else {
                                     muTDataArray = [NSArray yy_modelArrayWithClass:[YBLExpressCompanyItemModel class] json:result].mutableCopy;
                                 }
                                 [self resetDataArray:muTDataArray
                                           otherArray:self.openedExpressCompanyGoodListDataArray
                                          isStoreGood:NO
                                              indexps:nil];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (void)resetDataArray:(NSMutableArray *)dataArray
            otherArray:(NSMutableArray *)otherArray
           isStoreGood:(BOOL)isStoreGood
               indexps:(NSMutableArray *)indexps{
    
    for (id model in otherArray) {
        NSString *model_id;
        if (isStoreGood) {
            model_id = [model valueForKey:@"product_id"];
            if (!model_id) {
                model_id = [model valueForKey:@"id"];
            }
        } else {
            model_id = [model valueForKey:@"id"];
            if (!model_id) {
                model_id = [model valueForKey:@"product_id"];
            }
        }
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *obj_id = [obj valueForKey:@"id"];
            if ([obj_id isEqualToString:model_id]) {
                *stop = YES;
                if (*stop == YES) {
                    if (isStoreGood&&self.listVCType != ListVCTypeStoreGoodSingleSelect) {
                        //remove
                        [dataArray removeObject:obj];
                        if (indexps) {
                            [indexps removeLastObject];
                        }
                    } else {
                        [obj setValue:@(YES) forKey:@"is_select"];
                    }
                }
            }
            
        }];
    }
    self.dataArray = dataArray;
}

- (RACSignal *)siganlForVaildExpressCompany{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[YBLChooseDeliveryViewModel validExpressCompaniesSiganl] subscribeNext:^(id  _Nullable x) {
        
        [self resetDataArray:self.dataArray otherArray:x isStoreGood:NO indexps:nil];
        [subject sendNext:self.dataArray];
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}

- (NSMutableArray *)selectCompanyGoodListDataArray{
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (id model in self.dataArray) {
        NSNumber *selectNumber = [model valueForKey:@"is_select"];
        if (selectNumber.boolValue) {
            [tempArray addObject:model];
        }
    }
    return tempArray;
}

- (RACSignal *)settingExpressCompanyGoodListSiganl{
    
    RACReplaySubject *subejct = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"保存中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSMutableArray *idsArray = [NSMutableArray array];
    for (id model in self.selectCompanyGoodListDataArray) {
        NSString *id = [model valueForKey:@"id"];
        [idsArray addObject:id];
    }
    para[@"ids"] = idsArray;
    
    [YBLRequstTools HTTPPostWithUrl:url_express_companies_valid_express_companies
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                  [subejct sendCompleted];
                              });
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subejct sendError:error];
                            }];
    
    return subejct;
}

- (RACSignal *)siganlForAddExpressCompanyWithIds:(NSString *)_id Name:(NSString *)name{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (_id) {
       para[@"id"] = _id;
    }
    para[@"name"] = name;
    
    [YBLRequstTools HTTPPostWithUrl:url_express_companies
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              
                              YBLExpressCompanyItemModel *itemModel = [YBLExpressCompanyItemModel yy_modelWithJSON:result];
                              [self.dataArray insertObject:itemModel atIndex:0];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

- (RACSignal *)siganlForDeleteAddExpressCompanyWithIds:(NSString *)_id index:(NSInteger)index{
    
    RACReplaySubject *subject = [RACReplaySubject subject];

    [SVProgressHUD showWithStatus:@"删除中..."];
    
    [YBLRequstTools HTTPDELETEWithUrl:url_express_companies_delete(_id)
                              Parames:nil
                            commplete:^(id result, NSInteger statusCode) {
                                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                                [self.dataArray removeObjectAtIndex:index];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                   [subject sendCompleted];
                                });
                            }
                              failure:^(NSError *error, NSInteger errorCode) {
                                  [subject sendError:error];
                              }];
    
    return subject;
}

- (BOOL)isGoodsType{
    if (self.listVCType == ListVCTypeGood||self.listVCType == ListVCTypeStoreGood||self.listVCType == ListVCTypeStoreGoodSingleSelect||self.listVCType == ListVCTypeRewardToSetMoeny) {
        return YES;
    } else {
        return NO;
    }
}

@end

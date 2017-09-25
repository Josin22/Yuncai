//
//  YBLCompanyTypePricesViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCompanyTypePricesViewModel.h"
#import "YBLCompanyTypePricesParaModel.h"
#import "YBLEditGoodViewModel.h"
#import "YBLCompanyTypesItemModel.h"
#import "YBLGoodsDetailViewModel.h"

@implementation YBLCompanyTypePricesViewModel


- (NSMutableArray *)pricesDataArray{
    if (!_pricesDataArray) {
        _pricesDataArray = [NSMutableArray array];
    }
    return _pricesDataArray;
}

- (void)handlePriceArrayWith:(NSMutableArray *)dataArray{
    
    if (self.pricesDataArray.count!=0) {
        [self.pricesDataArray removeAllObjects];
    }
    for (YBLCompanyTypesItemModel *typeItemModel in dataArray) {
        
        YBLCompanyTypePricesParaModel *paraModel = [YBLCompanyTypePricesParaModel new];
        paraModel.active = @(NO);
        NSMutableArray *priceArray = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            PricesItemModel *priceItemModel = [PricesItemModel new];
            priceItemModel.sale_price = @(0);
            priceItemModel.active = @(NO);
            priceItemModel.min = @(0);
            [priceArray addObject:priceItemModel];
        }
        for (YBLCompanyTypePricesParaModel *company_typeItemModel  in self.company_type_prices) {
//
            if ([company_typeItemModel.company_type_id isEqualToString:typeItemModel._id]) {
                priceArray = company_typeItemModel.prices;
                paraModel.active = company_typeItemModel.active;
            }
        }
        paraModel.prices = priceArray;
        paraModel.company_type_id = typeItemModel._id;
        paraModel.company_title = typeItemModel.title;
        paraModel.unit = self.unitValue;
        [self.pricesDataArray addObject:paraModel];
    }
    
    YBLCompanyTypePricesParaModel *paraModel = [YBLCompanyTypePricesParaModel new];
    paraModel.active = @(NO);
    /**
     *  批量
     */
    paraModel.isPiLiang = YES;
    NSMutableArray *priceArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        PricesItemModel *priceItemModel = [PricesItemModel new];
        priceItemModel.sale_price = @(0);
        priceItemModel.active = @(NO);
        priceItemModel.min = @(0);
        [priceArray addObject:priceItemModel];
    }
    paraModel.prices = priceArray;
    paraModel.company_title = @"一键同步";
    paraModel.unit = self.unitValue;
    [self.pricesDataArray insertObject:paraModel atIndex:0];
}

- (RACSignal *)siganlForTwoLeverlCompanyTypeData{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
//    [SVProgressHUD showWithStatus:@"加载中..."];
    [YBLLogLoadingView showInWindow];
    
    WEAK
    [[YBLEditGoodViewModel siganlForCompanyTypeID:nil] subscribeNext:^(NSMutableArray*  _Nullable x) {
        STRONG
        
        [YBLLogLoadingView dismissInWindow];
//        [SVProgressHUD dismiss];
        
        [self handlePriceArrayWith:x];
        
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}


- (RACSignal *)siganlForSettingCompanyTypePrices{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"设置中..."];
    [self.pricesDataArray removeObjectAtIndex:0];
    NSDictionary *pp = @{@"company_type_prices":[self.pricesDataArray yy_modelToJSONString]};
    NSData *pData = [pp yy_modelToJSONData];
    
    [YBLRequstTools HTTPWithType:RequestTypePOST
                             Url:url_company_type_prices(self.product_id)
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

- (void)resetMin:(NSInteger)min
       salePrice:(double)salePrice
fromIndexOfArray:(NSInteger)fromIndexOfArray
         section:(NSInteger)section
isAllButtonnAction:(BOOL)isAllButtonnAction
     isPureWrite:(BOOL)isPureWrite{
    YBLCompanyTypePricesParaModel *sectionModel = self.pricesDataArray[section];
    PricesItemModel *model;
    if (fromIndexOfArray!=-1) {
        model = sectionModel.prices[fromIndexOfArray];
    }
    if (isPureWrite) {
        //纯文本框
        if (model.active.boolValue) {
            //选中状态
            for (YBLCompanyTypePricesParaModel *js_sectionModel in self.pricesDataArray) {
                PricesItemModel *js_rowModel = js_sectionModel.prices[fromIndexOfArray];
                if (min!=-1) {
                    js_rowModel.min = @(min);
                }
                if (salePrice!=-1.0) {
                    js_rowModel.sale_price = @(salePrice);
                }
//                for (PricesItemModel *js_rowModel in js_sectionModel.prices) {
//                    
//                }
            }
            
        } else {
            //未选中状态
            
        }
        
        
    } else {
        if (isAllButtonnAction) {
            //全选按钮点击
            
            for (YBLCompanyTypePricesParaModel *js_sectionModel in self.pricesDataArray) {
                js_sectionModel.prices = sectionModel.prices;
                js_sectionModel.active = sectionModel.active;
            }
//            for (YBLCompanyTypePricesParaModel *js_sectionModel in self.pricesDataArray) {
//                for (PricesItemModel *js_rowModel in js_sectionModel.prices) {
//                    if (min!=-1) {
//                        js_rowModel.min = @(min);
//                    }
//                    if (salePrice!=-1.0) {
//                        js_rowModel.sale_price = @(salePrice);
//                    }
//                    js_rowModel.active = @(model.active.boolValue);
//                }
//            }
           
        } else {
            //单个按钮点击
            for (YBLCompanyTypePricesParaModel *js_sectionModel in self.pricesDataArray) {
                PricesItemModel *js_rowModel = js_sectionModel.prices[fromIndexOfArray];
                js_rowModel.min = @(min);
                js_rowModel.sale_price = @(salePrice);
                js_rowModel.active = @(model.active.boolValue);
                //                for (PricesItemModel *js_rowModel in js_sectionModel.prices) {
                //
                //                }
            }
           
        }
   
    }
    
}

@end

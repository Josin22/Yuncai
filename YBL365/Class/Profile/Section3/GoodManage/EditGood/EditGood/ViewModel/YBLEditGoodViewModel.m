//
//  YBLEditGoodViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditGoodViewModel.h"
#import "YBLGoodModel.h"
#import "YBLOptionTypesModel.h"
#import "YBLEditItemGoodParaModel.h"
#import "YBLCompanyTypesItemModel.h"

@implementation YBLEditGoodViewModel


- (NSArray *)optionTypesArray{
    
    if (!_optionTypesArray) {
        _optionTypesArray = [NSArray array];
    }
    return _optionTypesArray;
}

- (NSMutableArray *)cellDataArray{
    
    if (!_cellDataArray) {
        _cellDataArray = [NSMutableArray array];
    }
    return _cellDataArray;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray  = [NSMutableArray array];
        [_titleArray addObjectsFromArray:@[@"基本信息",@"价格信息",@"物流区域",@"销售区域",@"编辑说明"]];
    }
    return _titleArray;
}

- (void)handleData:(NSArray *)data{
    
    if (self.cellManageGoodDataArray.count!=0) {
        return;
    }
    [self.cellManageGoodDataArray addObject:[self getModelWith:@"上/下架商品"
                                                     value:[NSString stringWithFormat:@"%@",@(NO)]
                                                isRequired:YES
                                                      type:EditTypeCellOnlySwith
                                                paraString:@"sxjsp"]];
    [self.cellManageGoodDataArray addObject:[self getModelWith:@"销售区域显示设置"
                                                     value:nil
                                                isRequired:YES
                                                      type:EditTypeCellOnlyClick
                                                paraString:@"xsqygl"]];
    [self.cellManageGoodDataArray addObject:[self getModelWith:@"配送支付方式"
                                                     value:nil
                                                isRequired:YES
                                                      type:EditTypeCellOnlyClick
                                                paraString:@"pszffs"]];
    [self.cellManageGoodDataArray addObject:[self getModelWith:@"销售价格以及起批数量设置"
                                                         value:nil
                                                    isRequired:YES
                                                          type:EditTypeCellOnlyClick
                                                    paraString:@"xsjgyjqpslsz"]];

}

+ (RACSignal *)siganlForCompanyTypeID:(NSString *)_id{

    return [[self alloc] siganlForCompanyType:@"0" company_id:_id isSelf:NO];
}

- (RACSignal *)siganlForCompanyType{
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    return [self siganlForCompanyType:@"0" company_id:nil isSelf:YES];
}

- (RACSignal *)siganlForCompanyType:(NSString *)type company_id:(NSString *)company_id isSelf:(BOOL)isSelf{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"type"] = type;
    if (company_id) {
        para[@"id"] = company_id;
    }
    [YBLRequstTools HTTPGetDataWithUrl:url_company_types
                               Parames:para
                             commplete:^(id result,NSInteger statusCode) {
                                 [SVProgressHUD dismiss];
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLCompanyTypesItemModel class] json:result[@"companytypes"]];
                                 if (company_id) {
                                     [subject sendNext:dataArray];
                                 } else {
                                     [subject sendNext:dataArray];
                                     if (isSelf) {
                                      [self handleData:dataArray];
                                     }
                                 }
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error,NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (NSMutableArray *)cellManageGoodDataArray{
    
    if (!_cellManageGoodDataArray) {
        _cellManageGoodDataArray = [NSMutableArray array];
        [_cellManageGoodDataArray addObject:[self getModelWith:@"上/下架商品"
                                                             value:[NSString stringWithFormat:@"%@",@(NO)]
                                                        isRequired:YES
                                                              type:EditTypeCellOnlySwith
                                                        paraString:@"sxjsp"]];
        
        [_cellManageGoodDataArray addObject:[self getModelWith:@"销售区域显示设置"
                                                             value:nil
                                                        isRequired:YES
                                                              type:EditTypeCellOnlyClick
                                                        paraString:@"xsqygl"]];
        
        [_cellManageGoodDataArray addObject:[self getModelWith:@"配送支付方式"
                                                             value:nil
                                                        isRequired:YES
                                                              type:EditTypeCellOnlyClick
                                                        paraString:@"pszffs"]];
        
        [_cellManageGoodDataArray addObject:[self getModelWith:@"销售价格以及起批数量设置"
                                                             value:nil
                                                        isRequired:YES
                                                              type:EditTypeCellOnlyClick
                                                        paraString:@"xsjgyjqpslsz"]];
        
        [_cellManageGoodDataArray addObject:[self getModelWith:@"开通快递物流管理"
                                                         value:nil
                                                    isRequired:YES
                                                          type:EditTypeCellOnlyClick
                                                    paraString:@"ktkdwlgl"]];
        
        [_cellManageGoodDataArray addObject:[self getModelWith:@"商品物流区域设置"
                                                         value:nil
                                                    isRequired:YES
                                                          type:EditTypeCellOnlyClick
                                                    paraString:@"spwlszqy"]];

    }
    return _cellManageGoodDataArray;
}

- (RACSignal *)rackProductSingal{
    
    RACReplaySubject *subject = [RACReplaySubject subject];

    [YBLLogLoadingView showInWindow];
//    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_product_rack(self._id)
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 [YBLLogLoadingView dismissInWindow];
//                                 [SVProgressHUD dismiss];
                                 
                                 self.productModel = [YBLGoodModel yy_modelWithJSON:result[@"product"]];
                                 
                                 self.optionTypesArray = [NSArray yy_modelArrayWithClass:[YBLEditItemGoodParaModel class] json:result[@"option_types"]];
                                 
                                 [self makeDataArray];
                                 
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

-(void)makeDataArray{
    
    if (self.cellDataArray.count!=0) {
        return;
    }
    
    [self.cellDataArray addObject:[self getModelWith:@"商品名称 : "
                                               value:self.productModel.title
                                          isRequired:YES
                                                type:EditTypeCellOnlyClick
                                          paraString:@"title"]];
    
    [self.cellDataArray addObject:[self getModelWith:@"商品规格 : "
                                               value:self.productModel.specification
                                          isRequired:YES
                                                type:EditTypeCellOnlyClick
                                          paraString:@"specification"]];
    
    [self.cellDataArray addObject:[self getModelWith:@"活动内容 : "
                                               value:self.productModel.self_description
                                          isRequired:NO
                                                type:EditTypeCellOnlyClick
                                          paraString:@"description"]];
    
    [self.cellDataArray addObject:[self getModelWith:@"我的库存 : "
                                               value:[NSString stringWithFormat:@"%@",self.productModel.stock]
                                          isRequired:YES
                                                type:EditTypeCellOnlyWrite
                                          paraString:@"stock"
                                        keyboardType:UIKeyboardTypePhonePad]];
    
    [self.cellDataArray addObject:[self getModelWith:@"进  货  价 : ¥"
                                               value:[NSString stringWithFormat:@"%@",self.productModel.cost_price]
                                          isRequired:NO
                                                type:EditTypeCellOnlyWrite
                                          paraString:@"cost_price"
                                        keyboardType:UIKeyboardTypeDecimalPad]];
    
    [self.cellDataArray addObject:[self getModelWith:@"扫  码  价 : ¥"
                                               value:[NSString stringWithFormat:@"%@",self.productModel.market_guide_price]
                                          isRequired:YES
                                                type:EditTypeCellOnlyWrite
                                          paraString:@"market_guide_price"
                                        keyboardType:UIKeyboardTypeDecimalPad]];
    
    [self.cellDataArray addObject:[self getModelWith:@"参  考  价 : ¥"
                                               value:[NSString stringWithFormat:@"%@",self.productModel.market_retail_price]
                                          isRequired:YES
                                                type:EditTypeCellOnlyWrite
                                          paraString:@"market_retail_price"
                                        keyboardType:UIKeyboardTypeDecimalPad]];
    
    [self.cellDataArray addObject:[self getModelWith:@"零  售  价 : ¥"
                                               value:[NSString stringWithFormat:@"%@",self.productModel.guest_price]
                                          isRequired:NO
                                                type:EditTypeCellOnlyWrite
                                          paraString:@"guest_price"
                                        keyboardType:UIKeyboardTypeDecimalPad]];
    
    [self.cellDataArray addObject:[self getModelWith:@"商品条码 : "
                                               value:[NSString stringWithFormat:@"%@",self.productModel.qrcode]
                                          isRequired:YES
                                                type:EditTypeCellOnlyWrite
                                          paraString:@"qrcode"
                                        keyboardType:UIKeyboardTypePhonePad]];

    [self.cellDataArray addObject:[self getModelWith:@"毛 重(kg) : "
                                               value:[NSString stringWithFormat:@"%ld",(long)self.productModel.weight.integerValue]
                                          isRequired:YES
                                                type:EditTypeCellOnlyWrite
                                          paraString:@"weight"
                                        keyboardType:UIKeyboardTypeDecimalPad]];
    
    [self.cellDataArray addObject:[self getModelWith:@"单       位 : "
                                               value:self.productModel.unit
                                          isRequired:YES
                                                type:EditTypeCellOnlyClick
                                          paraString:@"unit"
                                        keyboardType:UIKeyboardTypeDecimalPad]];
    
    /* 可变 */
    NSArray *new_filter_array = [self.optionTypesArray sortedArrayUsingComparator:finderEditTypeSort];
    for (YBLEditItemGoodParaModel *typeModel in new_filter_array) {
        NSString *value = self.productModel.properties[typeModel.id];
        typeModel.title = [typeModel.name stringByAppendingString:@" : "];
        typeModel.value = value;
        typeModel.editTypeCell = EditTypeCellWriteAndClick;
        typeModel.paraString = typeModel.id;
        typeModel.isUnsureValue = YES;
        [self.cellDataArray addObject:typeModel];
    }

    [self.cellDataArray addObject:[self getModelWith:@"生产厂家 : "
                                               value:[NSString stringWithFormat:@"%@",self.productModel.manufacturer.length==0?@"":self.productModel.manufacturer]
                                          isRequired:YES
                                                type:EditTypeCellOnlyWrite
                                          paraString:@"manufacturer"]];
    
}

NSComparator finderEditTypeSort = ^(YBLEditItemGoodParaModel *model1,YBLEditItemGoodParaModel *model2){
    
    if (model1.position.integerValue > model2.position.integerValue) {
        return (NSComparisonResult)NSOrderedDescending;
    } else if (model1.position.integerValue < model2.position.integerValue){
        return (NSComparisonResult)NSOrderedAscending;
    } else{
        return (NSComparisonResult)NSOrderedSame;
    }
};


- (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                                     value:(NSString *)value
                                isRequired:(BOOL)isRequired
                                      type:(EditTypeCell)type
                                paraString:(NSString *)paraString
                              keyboardType:(UIKeyboardType)keyboardType{
    
    YBLEditItemGoodParaModel *model = [YBLEditItemGoodParaModel new];
    model.title = title;
    model.value = value;
    model.editTypeCell = type;
    model.isRequired = isRequired;
    model.paraString = paraString;
    model.keyboardType = keyboardType;
    return model;
}

- (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                                     value:(NSString *)value
                                isRequired:(BOOL)isRequired
                                      type:(EditTypeCell)type
                                paraString:(NSString *)paraString{
    
    return [self getModelWith:title
                        value:value
                   isRequired:isRequired
                         type:type
                   paraString:paraString
                 keyboardType:UIKeyboardTypeDefault];
}

- (RACSignal *)SignalForOptionTypeWithId:(NSString *)_id{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_product_option_types(_id)
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 [SVProgressHUD dismiss];
                                 
                                 YBLOptionTypesModel *model = [YBLOptionTypesModel yy_modelWithJSON:result];
                                 [subject sendNext:model];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (RACSignal *)SingalForSaveProduct{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"保存中..."];
    
    NSMutableDictionary *productDict = [NSMutableDictionary dictionary];
    productDict[@"id"] = self._id;
    /**/
//    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    for (YBLEditItemGoodParaModel *paraModel in self.cellDataArray) {
        if (paraModel.isUnsureValue) {
            NSString *key = [@"option_type_" stringByAppendingString:paraModel.paraString];
            productDict[key] = paraModel.value;
        } else {
            productDict[paraModel.paraString] = paraModel.value;
        }
    }
//    productDict[@"properties"] = properties;
    NSDictionary *pp = @{@"product":productDict};
    NSData *pData = [pp yy_modelToJSONData];
    
    [YBLRequstTools HTTPWithType:RequestTypePUT
                             Url:url_products_save(self._id)
                            body:pData
                         Parames:nil
                       commplete:^(id result, NSInteger statusCode) {
                           [subject sendCompleted];
                       }
                         failure:^(NSError *error, NSInteger errorCode) {
                             [subject sendError:error];
                         }];
    
    return subject;
}


@end

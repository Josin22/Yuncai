//
//  YBLStoreInfoViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/5/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreInfoViewModel.h"
#import "YBLLoginViewModel.h"
#import "YBLEditItemGoodParaModel.h"
#import "shop.h"
#import "YBLShopInfoModel.h"

@implementation YBLStoreInfoViewModel

- (NSMutableArray *)cellDataArray{
    
    if (!_cellDataArray) {
        _cellDataArray = [NSMutableArray array];
    }
    return _cellDataArray;
}

+ (RACSignal *)siganlForShopInfoWithShopID:(NSString *)shopid{
    
    return [[self alloc] siganlForShopInfoWithShopID:shopid Self:NO];
}

- (RACSignal *)siganlForShopInfo{
    
    return [self siganlForShopInfoWithShopID:self.shopModel.shopid Self:YES];
}

- (RACSignal *)siganlForShopInfoWithShopID:(NSString *)shopid Self:(BOOL)isSelf{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"shop_id"] = shopid;
    
    [YBLRequstTools HTTPGetDataWithUrl:url_shopinfo
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                              
                                 NSDictionary *shop_dict = result[@"shopinfo"];
                                 YBLShopInfoModel *shopInfoModel = [YBLShopInfoModel yy_modelWithJSON:shop_dict];
                                 if (isSelf) {
                                     self.shopInfoModel = shopInfoModel;
                                     [self resetCellDataArray];
                                 } else {
                                     [subject sendNext:shopInfoModel];
                                 }
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

//- (RACSignal *)siganlForStoreInfo{
//    
//    RACReplaySubject *subject = [RACReplaySubject subject];
//    
//    [[YBLLoginViewModel siganlForGetStoreInfoWithID:self.shopModel.shopid] subscribeNext:^(YBLUserInfoModel*  _Nullable x) {
//        
//        self.shopUserInfoModel = x;
//        [self resetCellDataArray];
//        [subject sendCompleted];
//        
//    } error:^(NSError * _Nullable error) {
//        
//        [subject sendError:error];
//    }];
//    
//    return subject;
//}

- (void)resetCellDataArray{
    
    if (self.cellDataArray.count>0) {
        [self.cellDataArray removeAllObjects];
    }
    
    NSMutableArray *section0 = [NSMutableArray array];
    [self.cellDataArray addObject:section0];
    
    NSMutableArray *section1 = [NSMutableArray array];
    [self.cellDataArray addObject:section1];
    
    NSMutableArray *section2 = [NSMutableArray array];
    [self.cellDataArray addObject:section2];
    
    //店铺信息
    
    [section0 addObject:[YBLEditItemGoodParaModel getModelWith:@"店铺简介 :"
                                                         value:self.shopInfoModel.shop_intro
                                                    isRequired:YES
                                                          type:EditTypeCellNoWriteClick
                                                    paraString:@"dpjj"
                                                  keyboardType:UIKeyboardTypeDefault]];
    
    [section0 addObject:[YBLEditItemGoodParaModel getModelWith:@"开店时间 :"
                                                         value:self.shopInfoModel.userinfo.created_at
                                                    isRequired:YES
                                                          type:EditTypeCellNoWriteClick
                                                    paraString:@"kdsj"
                                                  keyboardType:UIKeyboardTypeDefault]];
    
    [section0 addObject:[YBLEditItemGoodParaModel getModelWith:@"经营类型 :"
                                                         value:self.shopInfoModel.userinfo.company_type_title
                                                    isRequired:YES
                                                          type:EditTypeCellNoWriteClick
                                                    paraString:@"jylx"
                                                  keyboardType:UIKeyboardTypeDefault]];
    //认证信息
    NSString *creditString = @"";
    NSString *creditImage = nil;
    if ([self.shopInfoModel.userinfo.credit isEqualToString:@"china"]) {
        creditString = [NSString stringWithFormat:@"%@年",self.shopInfoModel.userinfo.sum_credit];
        creditImage = @"credit_open";
    } else {
        creditString = @"未开通";
        creditImage = @"credit_open_grey";
    }
    YBLEditItemGoodParaModel  *item_ren =[YBLEditItemGoodParaModel getModelWith:@"信  用  通 :"
                                                                          value:creditString
                                                                     isRequired:YES
                                                                           type:EditTypeCellOnlyClick
                                                                     paraString:@"xyt"
                                                                   keyboardType:UIKeyboardTypeDefault];
    item_ren.arrow_image = creditImage;
    [section1 addObject:item_ren];
    
   
    //店铺qrcode
    YBLEditItemGoodParaModel *qrcode = [YBLEditItemGoodParaModel getModelWith:@"店铺二维码 "
                                                                     value:nil
                                                                isRequired:YES
                                                                      type:EditTypeCellOnlyClick
                                                                paraString:@"dpewm"
                                                              keyboardType:UIKeyboardTypeDefault];
    qrcode.arrow_image = @"ewm_icon";
    [section1 addObject:qrcode];
    
    //证件信息
    YBLEditItemGoodParaModel *zjz = [YBLEditItemGoodParaModel getModelWith:@"证照信息 "
                                                                     value:nil
                                                                isRequired:YES
                                                                      type:EditTypeCellOnlyClick
                                                                paraString:@"zjxx"
                                                              keyboardType:UIKeyboardTypeDefault];
    zjz.arrow_image = @"zjzxx_icon";
    [section1 addObject:zjz];
    //基本信息
    NSString *areaString = [NSString stringWithFormat:@"%@ %@ %@",self.shopInfoModel.userinfo.province_name,self.shopInfoModel.userinfo.city_name,self.shopInfoModel.userinfo.county_name];
    
    [section2 addObject:[YBLEditItemGoodParaModel getModelWith:@"所在地区 :"
                                                         value:areaString
                                                    isRequired:YES
                                                          type:EditTypeCellNoWriteClick
                                                    paraString:@"szdq"
                                                  keyboardType:UIKeyboardTypeDefault]];
    [section2 addObject:[YBLEditItemGoodParaModel getModelWith:@"联  系  人 :"
                                                         value:self.shopInfoModel.userinfo.name
                                                    isRequired:YES
                                                          type:EditTypeCellNoWriteClick
                                                    paraString:@"lxr"
                                                  keyboardType:UIKeyboardTypeDefault]];
    NSString *fulklk = [NSString stringWithFormat:@"%@%@%@",self.shopInfoModel.userinfo.area_name,self.shopInfoModel.userinfo.street_address,self.shopInfoModel.userinfo.desc_address];
    self.shopInfoModel.full_address = fulklk;
    [section2 addObject:[YBLEditItemGoodParaModel getModelWith:@"联系地址 :"
                                                         value:fulklk
                                                    isRequired:YES
                                                          type:EditTypeCellNoWriteClick
                                                    paraString:@"lxr"
                                                  keyboardType:UIKeyboardTypeDefault]];
}

@end

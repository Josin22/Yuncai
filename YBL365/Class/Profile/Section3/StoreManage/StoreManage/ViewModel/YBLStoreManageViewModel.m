//
//  YBLStoreManageViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/5/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreManageViewModel.h"
#import "YBLGoodsManageVC.h"
#import "YBLOrderViewController.h"
#import "YBLLogisticsCompanyAndGoodListViewController.h"
#import "YBLWriteInfoViewController.h"
#import "YBLStoreOpenManageVC.h"
#import "ZJUsefulPickerView.h"

#import "YBLStoreInfoViewModel.h"
#import "YBLShopInfoModel.h"
#import "YBLSingletonMethodTools.h"
#import "YBLPhotoHeplerViewController.h"

@implementation YBLStoreManageViewModel

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        if (self.storeManageTypeList == StoreManageTypeListManage) {
            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"基本信息管理"
                                                                   value:nil
                                                                    type:EditTypeCellOnlyClick
                                                              paraString:@"YBLStoreOpenManageVC"
                                                         paraValueString:nil]];
            
            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"商品管理"
                                                                   value:nil
                                                                    type:EditTypeCellOnlyClick
                                                              paraString:@"YBLGoodsManageVC"
                                                         paraValueString:nil]];
            
            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"订单管理"
                                                                   value:nil
                                                                    type:EditTypeCellOnlyClick
                                                              paraString:@"YBLOrderViewController"
                                                         paraValueString:nil]];
            
            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"开通快递物流管理"
                                                                   value:nil
                                                                    type:EditTypeCellOnlyClick
                                                              paraString:@"YBLLogisticsCompanyAndGoodListViewController"
                                                         paraValueString:nil]];
            
            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"店铺收藏"
                                                                   value:nil
                                                                    type:EditTypeCellOnlyClick
                                                              paraString:@"YBLStoreFollowViewController"
                                                         paraValueString:nil]];
//            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"赏金管理"
//                                                                   value:nil
//                                                                    type:EditTypeCellOnlyClick
//                                                              paraString:@"YBLRewardManageViewController"
//                                                         paraValueString:nil]];
            
        } else if (self.storeManageTypeList == StoreManageTypeListBaseInfo) {
            
        
            
        } else if (self.storeManageTypeList == StoreManageTypeListZZXX) {
            
            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"企业名称"
                                                                   value:nil
                                                              
                                                                    type:EditTypeCellOnlyClick
                                                              paraString:@"type"
                                                            paraValueString:@"company_name"
                                                             unfineValue:self.shopInfoModel.company_name]];
            
            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"统一社会信用代码"
                                                                   value:nil
                                                                    type:EditTypeCellOnlyClick
                                                              paraString:@"type"
                                                         paraValueString:@"registration_numbe"
                                                             unfineValue:self.shopInfoModel.registration_numbe]];
            
            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"企业类型"
                                                                   value:nil
                                                                    type:EditTypeCellOnlyClick
                                                              paraString:@"type"
                                                         paraValueString:@"company_type"
                                                             unfineValue:self.shopInfoModel.company_type]];
            
            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"法人代表"
                                                                   value:nil
                                                                    type:EditTypeCellOnlyClick
                                                              paraString:@"type"
                                                         paraValueString:@"leal_person"
                                                             unfineValue:self.shopInfoModel.leal_person]];
            
            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"营业执照所在地"
                                                                   value:nil
                                                                    type:EditTypeCellOnlyClick
                                                              paraString:@"type"
                                                            paraValueString:@"seat"
                                                             unfineValue:self.shopInfoModel.seat]];
            
            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"企业注册资本"
                                                                   value:nil
                                                                    type:EditTypeCellOnlyClick
                                                              paraString:@"type"
                                                            paraValueString:@"capital"
                                                             unfineValue:self.shopInfoModel.capital]];
            
            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"营业执照有效期开始"
                                                                   value:nil
                                                                    type:EditTypeCellOnlyClick
                                                              paraString:@"useful_life_from"
                                                            paraValueString:nil
                                                             unfineValue:self.shopInfoModel.useful_life_from]];
            
            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"营业执照有效期结束"
                                                                   value:nil
                                                              
                                                                    type:EditTypeCellOnlyClick
                                                              paraString:@"useful_life_end"
                                                            paraValueString:nil
                                                             unfineValue:self.shopInfoModel.useful_life_end]];
            
            
            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"营业执照经营范围"
                                                                   value:nil
                                                                    type:EditTypeCellOnlyClick
                                                              paraString:@"range"
                                                            paraValueString:nil
                                                             unfineValue:self.shopInfoModel.range]];
            
            [_dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"食品经营/流通许可证"
                                                                   value:nil
                                                                    type:EditTypeCellOnlyClick
                                                              paraString:@"liutong"
                                                            paraValueString:nil
                                                             unfineValue:self.shopInfoModel.liutong]];
            
        }
      
    }
    return _dataArray;
}

- (void)resetListBaseInfoData{
    
    if (self.dataArray.count>0) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"授权品牌"
                                                               value:nil
                                                                type:EditTypeCellOnlyClick
                                                          paraString:@"licensing_brand"
                                                     paraValueString:nil
                                                         unfineValue:self.shopInfoModel.licensing_brand]];
    

    [self.dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"店铺名称"
                                                               value:nil
                                                                type:EditTypeCellOnlyClick
                                                          paraString:@"shop_name"
                                                     paraValueString:nil
                                                         unfineValue:self.shopInfoModel.shop_name]];
    
    [self.dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"店铺简介"
                                                               value:nil
                                                                type:EditTypeCellOnlyClick
                                                          paraString:@"type"
                                                     paraValueString:@"shop_intro"
                                                         unfineValue:self.shopInfoModel.shop_intro]];

    [self.dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"证照信息管理"
                                                               value:nil
                                                                type:EditTypeCellOnlyClick
                                                          paraString:@"zzxxgl"
                                                     paraValueString:nil
                                                         unfineValue:self.shopInfoModel]];

    [self.dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"手机号码"
                                                               value:nil
                                                                type:EditTypeCellOnlyClick
                                                          paraString:@"type"
                                                     paraValueString:@"mobile"
                                                         unfineValue:self.shopInfoModel.mobile]];
    
    [self.dataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"固定电话"
                                                               value:nil
                                                                type:EditTypeCellOnlyClick
                                                          paraString:@"type"
                                                     paraValueString:@"tel"
                                                         unfineValue:self.shopInfoModel.tel]];
}

- (void)pushVcWithParaModel:(YBLEditItemGoodParaModel *)paraModel fromeVc:(UIViewController *)Vc{

    NSString *className = paraModel.paraString;
    Class class = NSClassFromString(className);
    id classVC;
    if (self.storeManageTypeList == StoreManageTypeListManage) {
        
        if ([className isEqualToString:@"YBLGoodsManageVC"]){
            
            YBLGoodsManageViewModel *viewModel = [YBLGoodsManageViewModel new];
            YBLGoodsManageVC *goodManageVC = [YBLGoodsManageVC new];
            goodManageVC.viewModel = viewModel;
            classVC = goodManageVC;
            
        } else if ([className isEqualToString:@"YBLOrderViewController"]){
            
            YBLOrderViewModel *viewModel = [YBLOrderViewModel new];
            viewModel.orderSource = OrderSourceSeller;
            viewModel.currentFoundIndex = 0;
            YBLOrderViewController *orderVC = [YBLOrderViewController new];
            orderVC.viewModel = viewModel;
            classVC = orderVC;
            
        } else if ([className isEqualToString:@"YBLLogisticsCompanyAndGoodListViewController"]){
            
            YBLLogisticsCompanyAndGoodListViewModel *viewModel = [YBLLogisticsCompanyAndGoodListViewModel new];
            viewModel.listVCType = ListVCTypeSingleExpressCompany;
            YBLLogisticsCompanyAndGoodListViewController *lcaglVC = [YBLLogisticsCompanyAndGoodListViewController new];
            lcaglVC.viewModel = viewModel;
            classVC = lcaglVC;
            
        } else if ([className isEqualToString:@"YBLStoreOpenManageVC"]){
          
            YBLStoreManageViewModel *manageViewModel = [YBLStoreManageViewModel new];
            manageViewModel.storeManageTypeList = StoreManageTypeListBaseInfo;
            YBLStoreOpenManageVC *storeOpenVC = [YBLStoreOpenManageVC new];
            storeOpenVC.viewModel = manageViewModel;
            classVC  = storeOpenVC;
            
        } else {
            
            classVC = [[class alloc] init];
        }

    } else if (self.storeManageTypeList == StoreManageTypeListBaseInfo) {
     
        if ([className isEqualToString:@"zzxxgl"]) {
            
            YBLStoreManageViewModel *manageViewModel = [YBLStoreManageViewModel new];
            manageViewModel.storeManageTypeList = StoreManageTypeListZZXX;
            manageViewModel.shopInfoModel = paraModel.undefineValue;
            YBLStoreOpenManageVC *storeOpenVC = [YBLStoreOpenManageVC new];
            storeOpenVC.viewModel = manageViewModel;
            classVC  = storeOpenVC;
            
        } else {
            
            YBLWriteInfoViewController *writeVC = [YBLWriteInfoViewController new];
            if ([className isEqualToString:@"type"]) {
                writeVC.infoString = paraModel.paraValueString;
            } else {
                writeVC.infoString = className;
            }
            writeVC.titleString = paraModel.title;
            writeVC.undefineValue = paraModel.undefineValue;
            WEAK
            writeVC.writeInfoValueBlock = ^(NSString *value) {
                STRONG
                [self signalForShopInfoSetWithType:paraModel.paraValueString
                                             value:value
                                               key:paraModel.paraString
                                         key_value:value
                                         paraModel:paraModel];
            };
            classVC = writeVC;
        }
        
    } else if (self.storeManageTypeList == StoreManageTypeListZZXX) {
        
        if ([className isEqualToString:@"useful_life_from"]||[className isEqualToString:@"useful_life_end"]) {
            
            ZJDatePickerStyle *style = [ZJDatePickerStyle new];
            style.datePickerMode = UIDatePickerModeDate;
            [ZJUsefulPickerView showDatePickerWithToolBarText:@"有效期"
                                                    withStyle:style
                                            withCancelHandler:^{}
                                              withDoneHandler:^(NSDate *selectedDate) {
                                                  
                                                  NSDateFormatter *dateFormatter = [YBLSingletonMethodTools shareMethodTools].cachedDateFormatter;
                                                  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                                  NSString *strDate = [dateFormatter stringFromDate:selectedDate];
                                                  
                                                  [self signalForShopInfoSetWithType:nil
                                                                               value:nil
                                                                                 key:paraModel.paraString
                                                                           key_value:strDate
                                                                           paraModel:paraModel];
                                              }];
            
        } else if ([className isEqualToString:@"liutong"]) {
            
            [[YBLPhotoHeplerViewController shareHelper] showImageViewSelcteWithResultBlock:^(UIImage *image) {
                if (image) {
                    [self siganlForUpdateLiutong:image];
                }
            }
                                                                                    isEdit:NO
                                                                               isJustPhoto:NO];
            /*
            [YBLTakePhotoSheetPhotoView showPickerWithVC:Vc PikerDoneHandle:^(UIImage *image) {
                if (image) {
                    [self siganlForUpdateLiutong:image];
                }
            }];
            */
            
        } else {
            
            YBLWriteInfoViewController *writeVC = [YBLWriteInfoViewController new];
            if ([className isEqualToString:@"type"]) {
                writeVC.infoString = paraModel.paraValueString;
            } else {
                writeVC.infoString = className;
            }
            writeVC.titleString = paraModel.title;
            writeVC.undefineValue = paraModel.undefineValue;
            WEAK
            writeVC.writeInfoValueBlock = ^(NSString *value) {
                STRONG
                [self signalForShopInfoSetWithType:paraModel.paraValueString
                                             value:value
                                               key:paraModel.paraString
                                         key_value:value
                                         paraModel:paraModel];
            };
            classVC = writeVC;
        }
    
    }
    
    [Vc.navigationController pushViewController:classVC animated:YES];

}

- (RACSignal *)signalForShopInfoSetWithType:(NSString *)type
                                      value:(NSString *)value
                                        key:(NSString *)key
                                  key_value:(NSString *)key_value
                                  paraModel:(YBLEditItemGoodParaModel *)paraModel{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (type) {
        para[@"type"] = type;
        para[@"value"] = value;
    } else {
        para[key] = key_value;
    }
    
    [YBLRequstTools HTTPPostWithUrl:url_shopinfo_set
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              
                              [SVProgressHUD showSuccessWithStatus:@"保存成功~"];
                              paraModel.undefineValue = value;
                              [subject sendNext:result];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

- (RACSignal *)siganlForUpdateLiutong:(UIImage *)image
{
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSData *thumbImageData = UIImageJPEGRepresentation(image, .8);
    YBLFileConfig *fileConfig = [YBLFileConfig
                                 fileConfigWithfileData:thumbImageData
                                 name:@"liutong"
                                 fileName:@"liutong"
                                 mimeType:@"image/png"];
    
    [SVProgressHUD showWithStatus:@"上传中..."];
    
    [YBLRequstTools updateRequest:url_shopinfo_set
                           params:nil
                  fileConfigArray:[@[fileConfig] mutableCopy]
                          success:^(id result,NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"上传成功~"];
                              [subject sendCompleted];
                          }
                          failure:^(NSError *error,NSInteger errorCode) {
                              [subject sendError:error];
                          }];
    
    return subject;
}

- (RACSignal *)siganlForShopInfo{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLLogLoadingView showInWindow];
    
    [[YBLStoreInfoViewModel siganlForShopInfoWithShopID:self.shopID] subscribeNext:^(id  _Nullable x) {
        [YBLLogLoadingView dismissInWindow];
        self.shopInfoModel = x;
        [self resetListBaseInfoData];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    return subject;
}

@end

//
//  YBLHomeViewModel.m
//  YBL365
//
//  Created by 乔同新 on 12/20/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLHomeViewModel.h"
#import "YBLPushPurchaseInfoModel.h"
#import "YBLAdsModel.h"
#import "YBLGoodModel.h"
#import "YBLOrderBulletModel.h"

@interface YBLHomeViewModel()

@end

@implementation YBLHomeViewModel

- (NSMutableArray *)orginOderBulletIDArray{
    if (!_orginOderBulletIDArray) {
        _orginOderBulletIDArray = @[].mutableCopy;
    }
    return _orginOderBulletIDArray;
}

- (NSMutableArray *)oderBulletArray{
    if (!_oderBulletArray) {
        _oderBulletArray = [NSMutableArray array];
    }
    return _oderBulletArray;
}

- (NSArray *)buttonClassNameArray{
    if (!_buttonClassNameArray) {
        _buttonClassNameArray = @[@"YBLStoreRedbagViewController",
                                  @"YBLMineRedBagViewController",
                                  @"YBLMineMillionMessageViewController",
                                  @"YBLRewardViewController",
                                  @"YBLCouponsCenterViewController",
                                  ];
    }
    return _buttonClassNameArray;
}

- (NSMutableDictionary *)cell_data_dict{
    if (!_cell_data_dict) {
        _cell_data_dict = [NSMutableDictionary dictionary];
        NSArray *defaultArray = @[@"YBLHomeBannerCell",
                                  @"YBLHomeButtonsCell",
                                  @"YBLExpressNewsCell"];
        NSMutableArray *sectionModel = @[].mutableCopy;
        for (NSString *cellname in defaultArray) {
            YBLListCellItemModel *cellItemModel = [YBLListCellItemModel new];
            cellItemModel.identifyOfRowItemCell = cellname;
            [sectionModel addObject:cellItemModel];
        }
        YBLListBaseModel *listItemModel = [YBLListBaseModel new];
        listItemModel.identifyOfSectionCellItemArray = sectionModel;
        [_cell_data_dict setObject:listItemModel forKey:@(0)];
    }
    return _cell_data_dict;
}

- (RACSignal *)purchasePushSiganl{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_purchasingorder_purchase_order_push
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLPushPurchaseInfoModel class] json:result];
                                 [self resetPurchaseData:dataArray];
                                 NSIndexPath *purchaseIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                                 [subject sendNext:@[purchaseIndexPath]];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (void)resetPurchaseData:(NSArray *)purchasePushData{
    
    [self resetAdsBannerPurchasePushWithIndex:2 data:purchasePushData];
}

- (void)resetAdsArray:(NSArray *)adsArray{
    
    [self resetAdsBannerPurchasePushWithIndex:0 data:adsArray];
}

- (void)resetAdsBannerPurchasePushWithIndex:(NSInteger)index data:(NSArray *)data{
    
    YBLListBaseModel *listItemModel = self.cell_data_dict[@(0)];
    YBLListCellItemModel *CellItemModel = listItemModel.identifyOfSectionCellItemArray[index];
    CellItemModel.orginValueOfRowItemCellData = data.mutableCopy;
    if (!CellItemModel.valueOfRowItemCellData) {
        CellItemModel.valueOfRowItemCellData = [NSMutableArray array];
    }
    if ([CellItemModel.valueOfRowItemCellData count]>0) {
        [CellItemModel.valueOfRowItemCellData removeAllObjects];
    }
    CellItemModel.orginValueOfRowItemCellData = data.mutableCopy;
    for (id model in data) {
        if ([model isKindOfClass:[YBLAdsModel class]]) {
            YBLAdsModel *adsModel = (YBLAdsModel *)model;
            [CellItemModel.valueOfRowItemCellData addObject:adsModel.pic_path];
            
        } else if ([model isKindOfClass:[YBLPushPurchaseInfoModel class]]) {
            YBLPushPurchaseInfoModel *pushPurchaseModel = (YBLPushPurchaseInfoModel *)model;
            [CellItemModel.valueOfRowItemCellData addObject:pushPurchaseModel.message];
        }
    }
}

- (RACSignal *)floorsSignal{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_floors
                               Parames:nil
                             commplete:^(id result,NSInteger statusCode) {
                                 /**
                                  *  banner
                                  */
                                 NSArray *adsArray = [NSArray yy_modelArrayWithClass:[YBLAdsModel class] json:result[@"ads"]];
                                 [self resetAdsArray:adsArray];
                                 [subject sendNext:@(0)];
                                 /**
                                  *  分类
                                  */
                                 NSArray *floorsArray = [NSArray yy_modelArrayWithClass:[YBLFloorsModel class] json:result[@"categories"]];
                                 //一级数组
                                 NSMutableArray *depth1Array = [NSMutableArray array];
                                 //二级数组
                                 NSMutableArray *depth2Array = [NSMutableArray array];
                                 for (YBLFloorsModel *floorsModel in floorsArray) {
                                     //改为2 3级
                                     if (floorsModel.depth.integerValue == 2) {
                                         [depth1Array addObject:floorsModel];
                                     } else if (floorsModel.depth.integerValue == 3) {
                                         [depth2Array addObject:floorsModel];
                                     }
                                 }
                                 //一级排序后数组
                                 //遍历排序完的一级数组
                                 NSInteger mou_index = 1;
                                 for (YBLFloorsModel *sortModel in depth1Array) {
                                     //所有二级数组
                                     NSMutableArray *singleArray = [NSMutableArray array];
                                     for (YBLFloorsModel *model1 in depth2Array) {
                                         //从二级里找每个一级id
                                         if ([model1.parent_id isEqualToString:sortModel.id]) {
                                             [singleArray addObject:model1];
                                         }
                                     }
                                     //one section && one row
                                     YBLListCellItemModel *moduleCellModel = [YBLListCellItemModel new];
                                     moduleCellModel.identifyOfRowItemCell = @"YBLHomeModuleCell";
                                     moduleCellModel.valueOfRowItemCellData = singleArray;
                                     //模块分类
                                     YBLListBaseModel *moduleCellItemModel = [YBLListBaseModel new];
                                     moduleCellItemModel.identifyOfSectionCellItemArray = @[moduleCellModel].mutableCopy;
                                     moduleCellItemModel.identifyOfSectionItemHeaderView = @"YBLModuleTitleView";
                                     moduleCellItemModel.valueOfSectionItemHeaderViewData = sortModel;
                                     [self.cell_data_dict setObject:moduleCellItemModel forKey:@(mou_index)];
                                     mou_index++;
                                 }
                                 //为你推荐
                                 YBLListBaseModel *commandItemModel = [YBLListBaseModel new];
                                 commandItemModel.identifyOfSectionItemHeaderView = @"YBLModuleTitleView";
                                 commandItemModel.identifyOfSectionItemFooterView = @"YBLHomeFooterView";
                                 commandItemModel.valueOfSectionItemHeaderViewData = @"uniformRecommend_head_image_";
                                 [self.cell_data_dict setObject:commandItemModel forKey:@(mou_index)];
                            
                                 [subject sendNext:@(1)];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error,NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
    
}

- (RACSignal *)siganlForProductRecommend{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[self siganlForSingleListViewRequestLoadMoreWithPara:nil url:url_products_recommand isReload:NO] subscribeNext:^(id  _Nullable result) {

        NSArray *command_data_array = [NSArray yy_modelArrayWithClass:[YBLGoodModel class] json:result[@"products"]];
        NSInteger command_index = self.cell_data_dict.count-1;
        YBLListBaseModel *commandModel = self.cell_data_dict[@(command_index)];
        NSMutableArray *commandData = commandModel.identifyOfSectionCellItemArray;
        if (!commandData) {
            commandData = [NSMutableArray array];
            commandModel.identifyOfSectionCellItemArray = commandData;
        }
        NSInteger commandCount = [commandData count];

        NSMutableArray *indexps = [YBLMethodTools getRowAppendingIndexPathsWithIndex:commandCount appendingCount:command_data_array.count inSection:command_index];
        if (command_data_array.count==0) {
            self.isNoMoreData = YES;
        } else {
            self.isNoMoreData = NO;
            for (YBLGoodModel *commandModel in command_data_array) {
                
                [commandModel handleAttPrice];
                
                YBLListCellItemModel *itemModel = [YBLListCellItemModel new];
                itemModel.identifyOfRowItemCell = @"YBLCategoryItemCell";
                itemModel.valueOfRowItemCellData= commandModel;
                [commandData addObject:itemModel];
            }
        }
        //发送indexpaths
        [subject sendNext:indexps];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];

    return subject;
}

- (RACSignal *)ordersBullet{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_orders_bullet
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLOrderBulletModel class] json:result];
                                 for (YBLOrderBulletModel *itemModel in dataArray) {
                                     if (![self.orginOderBulletIDArray containsObject:itemModel.id]) {
                                         [self.orginOderBulletIDArray addObject:itemModel.id];
                                         itemModel.iconWidth = 30;
                                         itemModel.maxContentWidth = YBLWindowWidth/2-2*space-itemModel.iconWidth;
                                         itemModel.contentSize = [itemModel.content heightWithFont:YBLFont(12) MaxWidth:itemModel.maxContentWidth];
                                         [self.oderBulletArray insertObject:itemModel atIndex:0];
                                     }
                                 }
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

@end

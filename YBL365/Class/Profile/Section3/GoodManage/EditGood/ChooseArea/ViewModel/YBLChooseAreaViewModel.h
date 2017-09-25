//
//  YBLChooseAreaViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBLAddressAreaModel;

typedef NS_ENUM(NSInteger,AreaType) {

    AreaTypeSalesArea = 0,//销售区域
    AreaTypeDisplayPriceArea//显示价格区域
};

typedef NS_ENUM(NSInteger,ChooseAreaVCType) {
    //设置区域显示
    ChooseAreaVCTypeSetAll = 0,
    //获取全部区域
    ChooseAreaVCTypeGetAll,
    //获取部分区域
    ChooseAreaVCTypeGetPart,
    //水平方式
    ChooseAreaVCTypeHorizontal
};

typedef void(^ChooseAreaSaveBlock)(NSMutableDictionary *selectAreaDataDict);

@interface YBLChooseAreaViewModel : NSObject

@property (nonatomic, copy  ) ChooseAreaSaveBlock chooseAreaSaveBlock;
@property (nonatomic, assign) ChooseAreaVCType chooseAreaVCType;
@property (nonatomic, assign) AreaType areaType;
@property (nonatomic, copy  ) NSString *_id;
@property (nonatomic, assign) NSInteger countByAreaType;

///设置商品销售区域或显示区域
- (RACSignal *)signalForSaveAreaSetting;
///省市县乡数据
@property (nonatomic, strong) NSMutableDictionary *sxAreaDataDict;
///选中数据
@property (nonatomic, strong) NSMutableDictionary *selectAreaDataDict;
///获取四级地址库
- (RACSignal *)areaListSignalWithId:(NSInteger)Id Index:(NSInteger)index;

- (void)saveModel:(YBLAddressAreaModel *)model;

- (void)deleteModel:(YBLAddressAreaModel *)model;

@end

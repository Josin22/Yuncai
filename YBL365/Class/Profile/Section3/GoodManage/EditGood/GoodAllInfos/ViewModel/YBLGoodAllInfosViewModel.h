//
//  YBLGoodAllInfosViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBLGoodModel,YBLSalesDisplayPriceModel;

typedef NS_ENUM(NSInteger,GoodAllInfosType) {
    /**
     *  基本信息
     */
    GoodAllInfosTypeBaseVC = 0,
    /**
     *  价格详情
     */
    GoodAllInfosTypePriceVC,
    /**
     *  物流信息
     */
    GoodAllInfosTypeExpressVC,
    /**
     *  销售区域
     */
    GoodAllInfosTypePriceVCSaleAreaVC,
};

@interface YBLGoodAllInfosViewModel : NSObject

@property (nonatomic, assign) GoodAllInfosType          goodAllInfosType;

@property (nonatomic, strong) YBLGoodModel              *productModel;

@property (nonatomic, assign) NSMutableArray            *goodInfoDataArray;

@property (nonatomic, strong) NSString                  *titleString;

@property (nonatomic, strong) YBLSalesDisplayPriceModel *saleDisPriceModel;

@property (nonatomic, strong) NSMutableArray            *expressDataArray;

@property (nonatomic, strong) NSMutableArray            *companyTypeDataArray;

@end

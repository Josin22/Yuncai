//
//  YBLStoreManageViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLEditItemGoodParaModel.h"

typedef NS_ENUM(NSInteger,StoreManageTypeList) {
    /**
     *  店铺管理
     */
    StoreManageTypeListManage = 0,
    /**
     *  基本信息
     */
    StoreManageTypeListBaseInfo,
    /**
     *  证照信息
     */
    StoreManageTypeListZZXX
};

@class YBLShopInfoModel;

@interface YBLStoreManageViewModel : NSObject

@property (nonatomic, assign) StoreManageTypeList storeManageTypeList;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy  ) NSString *shopID;

@property (nonatomic, strong) YBLShopInfoModel *shopInfoModel;

- (void)pushVcWithParaModel:(YBLEditItemGoodParaModel *)paraModel fromeVc:(UIViewController *)Vc;

- (RACSignal *)siganlForShopInfo;

@end

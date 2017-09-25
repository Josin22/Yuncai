//
//  YBLShopCarUIService.h
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLShopCarViewController.h"

@class YBLShopCarTempGoodModel;

//选中圈圈商品回调
typedef void(^CheckGoodBlock)(YBLShopCarTempGoodModel *good , BOOL isSelected, NSIndexPath *indexPath);
//选中店铺回调
typedef void(^CheckShopBlock)(id shop, BOOL isSelected, NSInteger section);
//删除回调
typedef void(^DeleteGoodBlock)(YBLShopCarTempGoodModel *good ,NSInteger section);
//修改商品数量回调
typedef void(^ChangeGoodNumberBlock)();


@interface YBLShopCarUIService : NSObject

@property (nonatomic, weak) YBLShopCarViewController *shopCarVC;

@property (nonatomic, copy) CheckGoodBlock checkGoodBlock;

@property (nonatomic, copy) CheckShopBlock checkShopBlock;

@property (nonatomic, copy) DeleteGoodBlock deleteGoodBlock;

@property (nonatomic, copy) ChangeGoodNumberBlock changeGoodNumberBlock;

//根据是否登录改变UI
- (void)changeUIWithIslogin:(BOOL )isLogin;

//更新数据源
- (void)updateWithCarGoodArray:(NSArray *)carGoodArray recommendArray:(NSArray *)recommendArray;

//修改tableView的高度
- (void)changeTableViewHeight:(CGFloat)height;

//根据是否是编辑状态修改tableView
- (void)updateWithCarType:(ShopCarType )carType;

//更新某一行数据
- (void)updateCellForIndexPath:(NSIndexPath *)indexPath;

//更新所有
- (void)updateAllSections;

//更新某一区
- (void)updateCellInSection:(NSInteger)section;




@end

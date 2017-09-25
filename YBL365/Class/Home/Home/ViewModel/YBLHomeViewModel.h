//
//  YBLHomeViewModel.h
//  YBL365
//
//  Created by 乔同新 on 12/20/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLFloorsModel.h"
#import "YBLPerPageBaseViewModel.h"
#import "YBLListBaseModel.h"

@interface YBLHomeViewModel : YBLPerPageBaseViewModel
/**
 *  楼层Signal
 */
@property (nonatomic, strong) RACSignal           *floorsSignal;
/**
 *  采购记录Signal
 */
@property (nonatomic, strong) RACSignal           *purchasePushSiganl;
/**
 *  订单弹幕Signal
 */
@property (nonatomic, strong) RACSignal           *ordersBullet;
/**
 *  cell_Dict
 */
@property (nonatomic, strong) NSMutableDictionary *cell_data_dict;
/**
 *  记录为你推荐位置的Y
 */
@property (nonatomic, assign) CGFloat              firstCommandPoint;
/**
 *  订单弹幕Array
 */
@property (nonatomic, strong) NSMutableArray      *oderBulletArray;
/**
 *  原始订单弹幕IDArray
 */
@property (nonatomic, strong) NSMutableArray      *orginOderBulletIDArray;
/**
 *  是否弹幕
 */
@property (nonatomic, assign) BOOL                isRunBullets;
/**
 *  按钮VCArray
 */
@property (nonatomic, strong) NSArray             *buttonClassNameArray;
/**
 *  为你推荐
 *
 *  @return Signal
 */
- (RACSignal *)siganlForProductRecommend;

@end

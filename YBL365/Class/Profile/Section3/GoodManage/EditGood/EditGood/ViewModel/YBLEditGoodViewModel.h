//
//  YBLEditGoodViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBLGoodModel;

typedef void(^EditGoodViewModelGoodModelBlock)(YBLGoodModel *changeModel);

typedef void(^EditGoodViewModelDeleteBlock)(YBLGoodModel *changeModel);

@interface YBLEditGoodViewModel : NSObject

@property (nonatomic, copy  ) EditGoodViewModelGoodModelBlock goodModelBlock;

@property (nonatomic, copy  ) EditGoodViewModelDeleteBlock  deleteBlock;

@property (nonatomic, strong) NSString *_id;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) YBLGoodModel *productModel;

@property (nonatomic, strong) NSArray *optionTypesArray;
/**
 *  商品编辑
 */
@property (nonatomic, strong) NSMutableArray *cellDataArray;
/**
 *  商品管理
 */
@property (nonatomic, strong) NSMutableArray *cellManageGoodDataArray;
/**
 *  上架商品信息
 */
@property (nonatomic, strong) RACSignal *rackProductSingal;
/**
 *  可选类型
 *
 *  @param _id 商品id
 *
 *  @return return RACSignal
 */
- (RACSignal *)SignalForOptionTypeWithId:(NSString *)_id;
/**
 *  保存商品
 *
 *  @return RACSignal
 */
- (RACSignal *)SingalForSaveProduct;
/**
 *  公司类型
 *
 *  @return RACSignal
 */
- (RACSignal *)siganlForCompanyType;
/**
 *  公司二级类型
 *
 *  @param _id _id description
 *
 *  @return return value description
 */
+ (RACSignal *)siganlForCompanyTypeID:(NSString *)_id;

@end

//
//  YBLAddressViewModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLAddressAreaModel.h"
#import "YBLAddressModel.h"

typedef void(^AddressViewBlock)(YBLAddressModel *selectModel);

typedef void(^AddressViewManySelectAddresBlock)(NSMutableArray *selectArray);

typedef NS_ENUM(NSInteger, AddressType) {
    AddressTypeOrderEdit = 0, //编辑收货地址
    AddressTypeOrderAdd,  //新建收货地址
};

@interface YBLAddressViewModel : NSObject

@property (nonatomic, copy  ) AddressViewBlock addressViewBlock;

@property (nonatomic, copy  ) AddressViewManySelectAddresBlock addressViewManySelectAddresBlock;

@property (nonatomic, strong) NSMutableArray *selectAddressArray;

@property (nonatomic, assign) AddressType addressType;

@property (nonatomic, assign) AddressGenre addressGenre;

@property (nonatomic, strong) YBLAddressModel *addressInfoModel;

@property (nonatomic, strong) NSMutableDictionary *areaDict;
///所有收货地址
@property (nonatomic, strong) NSMutableArray *allAddressArray;

///获取地区列表
- (RACSignal *)areaListSignalWithId:(NSInteger)Id Index:(NSInteger)index;
///获取地区信息
- (RACSignal *)areaInfoSignalWithId:(NSInteger)Id Index:(NSInteger)index;

+ (RACSignal *)siganlForAllAddress;

- (RACSignal *)allAddressSignal;

///添加收货地址
- (RACSignal *)signalForAddAddress;
///删除地址
- (RACSignal *)signalForDeleteAddressWithID:(NSString *)_id;
///修改地址
- (RACSignal *)signalForChangeAddress;
///自提地址
- (NSMutableArray *)getSelectZitiArray ;

@end

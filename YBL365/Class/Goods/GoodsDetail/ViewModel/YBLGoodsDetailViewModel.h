//
//  YBLGoodsDetailViewModel.h
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLGoodModel.h"
#import "YBLOrderCommentsItemModel.h"

@interface YBLGoodsDetailViewModel : NSObject

@property (nonatomic, copy  ) NSString        *goodID;

@property (nonatomic, strong) YBLGoodModel    *goodDetailModel;

@property (nonatomic, assign) BOOL            carBarEnable;

@property (nonatomic, assign) BOOL            isFollowed;

@property (nonatomic, strong) NSMutableArray  *cellIDArray;

@property (nonatomic, strong) NSMutableArray  *addressArray;

@property (nonatomic, assign) BOOL isHasRequestCartNumber;

@property (nonatomic, strong) NSMutableArray *paraDataArray;

- (RACSignal *)goodDetailSignal;

+ (RACSignal *)addCartWithQuantity:(NSInteger)quantity goodID:(NSString *)pid;

- (RACSignal *)addCartWithQuantity:(NSInteger)quantity goodID:(NSString *)pid;

+ (RACSignal *)goodDetailSignalWithID:(NSString *)gID;

- (RACSignal *)siganlForAddress;

- (RACSignal *)siganlForShippingPrice;

- (RACSignal *)signalForGoodFollow:(BOOL)isFollow;

+ (RACSignal *)signalForGood:(NSString *)goodID isFollow:(BOOL)isFollow;

+ (RACSignal *)singalForGoodIDWithQrcid:(NSString *)qrcID;

+ (RACSignal *)singalForGoodIDWithQrcid:(NSString *)qrcID selfVc:(UIViewController *)selfVc;

@end

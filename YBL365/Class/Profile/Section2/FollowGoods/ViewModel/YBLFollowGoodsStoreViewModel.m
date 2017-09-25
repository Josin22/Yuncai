//
//  YBLFollowGoodsViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/6/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFollowGoodsStoreViewModel.h"
#import "YBLGoodModel.h"

@implementation YBLFollowGoodsStoreViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.titleArray = @[@[@"商品",@"店铺"]];
        
        [self hanldeTitleData];
        
    }
    return self;
}
- (RACSignal *)signalForFollowGoodsIsReload:(BOOL)isReload{

    //商品关注
    NSString *new_url = url_product_myfollow;
    if (self.currentFoundIndex == 1) {
        new_url = url_store_myfollow;
    }
    NSString *key = @"products";
    NSString *className = @"YBLGoodModel";
    if (self.currentFoundIndex == 1) {
        key = @"shops";
        className = @"YBLUserInfoModel";
    }
    return [self siganlForManyListViewRequestLoadMoreWithPara:nil
                                                     isReload:isReload
                                                          url:new_url
                                                      dictKey:key
                                                jsonClassName:className];
}

@end

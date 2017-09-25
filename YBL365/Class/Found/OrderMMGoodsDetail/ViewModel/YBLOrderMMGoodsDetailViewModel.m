//
//  YBLOrderMMGoodsDetailViewModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMGoodsDetailViewModel.h"

@implementation YBLOrderMMGoodsDetailViewModel

- (NSMutableArray *)cellArray{
    
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
        [_cellArray addObject:@[@{@"cell":@"YBLOrderMMGoodsDetailInfoCell"},@{@"cell":@"YBLOrderMMGoodsDetailOtherInfoCell"}]];
        [_cellArray addObject:@[@{@"cell":@"YBLOrderMMGoodsDetailOutPriceRecordsCell"}]];
        [_cellArray addObject:@[@{@"cell":@"YBLOrderMMGoodsDetailMiningSupplyProcessCell"}]];
        [_cellArray addObject:@[@{@"cell":@"YBLOrderMMGoodsDetailAddressCell"},@{@"cell":@"YBLOrderMMGoodsDetailBusinessStarCell"}]];
        [_cellArray addObject:@[@{@"cell":@"YBLGoodsHotListCell"}]];
        [_cellArray addObject:@[@{@"cell":@"YBLOrderMMGoodsDetailPicsCell"}]];
        
    }
    return _cellArray;
}

@end

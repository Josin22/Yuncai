//
//  YBLAreaRadiusViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAreaRadiusViewModel.h"
#import "YBLAreaRadiusItemModel.h"

@implementation YBLAreaRadiusViewModel

- (NSMutableArray *)areaDataArray{
    
    if (!_areaDataArray) {
        _areaDataArray = [NSMutableArray array];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"1" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"2" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"3" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"5" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"6" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"8" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"10" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"15" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"20" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"25" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"30" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"40" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"50" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"60" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"70" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"80" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"90" price:@(0)]];
        [_areaDataArray addObject:[self getAreaRadiusModelWith:@"100"price:@(0)]];
        
    }
    return _areaDataArray;
}

- (NSMutableArray *)areaSelectDataArray{
    
    if (!_areaSelectDataArray) {
        _areaSelectDataArray = [NSMutableArray array];
        [_areaSelectDataArray addObject:[self getAreaRadiusModelWith:@"1" price:@(0)]];
        [_areaSelectDataArray addObject:[self getAreaRadiusModelWith:@"2" price:@(0)]];
        [_areaSelectDataArray addObject:[self getAreaRadiusModelWith:@"3" price:@(0)]];
    }
    return _areaSelectDataArray;
}

- (NSMutableArray *)savePriceArray{
    if (!_savePriceArray) {
        _savePriceArray = [NSMutableArray array];
    }
    return _savePriceArray;
}

- (void)handleData{

    //记录下价格
    [self.savePriceArray removeAllObjects];
    for (YBLAreaRadiusItemModel *itemModel in self.areaSelectDataArray) {
        [self.savePriceArray addObject:itemModel];
    }
    [self.areaSelectDataArray removeAllObjects];
    
    for (YBLAreaRadiusItemModel *itemModel in self.areaDataArray) {
        if (itemModel.is_select) {
            [self.areaSelectDataArray addObject:itemModel];
        }
    }
    for (YBLAreaRadiusItemModel *itemModel in self.savePriceArray) {
        for (YBLAreaRadiusItemModel *new_itemModel in self.areaSelectDataArray) {
            if ([itemModel.radius isEqualToString:new_itemModel.radius]) {
                new_itemModel.price = itemModel.price;
            }
        }
    }
}

- (YBLAreaRadiusItemModel *)getAreaRadiusModelWith:(NSString *)radius price:(NSNumber *)price{
   
    YBLAreaRadiusItemModel *itemModel = [YBLAreaRadiusItemModel new];
    itemModel.radius = radius;
    itemModel.price = price;
    return itemModel;
}

@end

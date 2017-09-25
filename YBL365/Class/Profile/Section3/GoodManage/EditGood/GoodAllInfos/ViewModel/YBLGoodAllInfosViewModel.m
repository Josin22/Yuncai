//
//  YBLGoodAllInfosViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/5/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodAllInfosViewModel.h"
#import "YBLGoodModel.h"

@implementation YBLGoodAllInfosViewModel

- (NSMutableArray *)companyTypeDataArray{
    if (!_companyTypeDataArray) {
        _companyTypeDataArray = [NSMutableArray array];
    }
    return _companyTypeDataArray;
}

- (NSMutableArray *)expressDataArray{
    if (!_expressDataArray) {
        _expressDataArray = [NSMutableArray array];
    }
    return _expressDataArray;
}

@end

//
//  YBLSeckillViewModel.m
//  YBL365
//
//  Created by 乔同新 on 12/21/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLSeckillViewModel.h"

@implementation YBLSeckillViewModel

- (NSMutableArray *)testArray{
    
    if (!_testArray) {
        _testArray = [NSMutableArray array];
        [_testArray addObject:@1];
        [_testArray addObject:@2];
        [_testArray addObject:@3];
        [_testArray addObject:@4];
        [_testArray addObject:@5];
    }
    return _testArray;
}

@end

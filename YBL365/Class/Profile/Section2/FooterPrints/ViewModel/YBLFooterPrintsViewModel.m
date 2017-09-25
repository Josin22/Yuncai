//
//  YBLFooterPrintsViewModel.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFooterPrintsViewModel.h"
#import "YBLDBManage.h"

@implementation YBLFooterPrintsViewModel

- (NSMutableArray *)footerPrintData{
    if (!_footerPrintData) {
        _footerPrintData = [NSMutableArray array];
    }
    return _footerPrintData;
}

- (void)reGetFooterPrintsData{
    self.footerPrintData = [YBLDBManage shareDB].getRecordsGoodDataArray;
}

- (void)cleanAllFooterPrintsData{
    [[YBLDBManage shareDB] cleanAllRecordsGood];
    [self.footerPrintData removeAllObjects];
}

- (void)deleteFooterPrintsGoodWithID:(NSString *)goodID index:(NSInteger)index{
    [[YBLDBManage shareDB] deleRecordsGoodModelByGoodID:goodID];
    [self.footerPrintData removeObjectAtIndex:index];
}

@end

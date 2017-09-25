//
//  YBLCategoryViewModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCategoryViewModel.h"

@implementation YBLCategoryViewModel

- (NSMutableArray *)topCategoryArray{
    
    if (!_topCategoryArray) {
        _topCategoryArray = [NSMutableArray array];
    }
    return _topCategoryArray;
}

- (NSMutableDictionary *)allSubTreeCategoryDict{
    
    if (!_allSubTreeCategoryDict) {
        _allSubTreeCategoryDict = [NSMutableDictionary dictionary];
    }
    return _allSubTreeCategoryDict;
}

- (RACSignal *)singalForCategoryTreeWithId:(NSString *)ids Index:(NSInteger)index{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_categories_tree(ids)
                               Parames:nil
                             commplete:^(id result,NSInteger statusCode) {
                                 if ([ids isEqualToString:@"0"]) {
                                     //一级
                                     self.topCategoryArray = [[NSArray yy_modelArrayWithClass:[YBLCategoryTreeModel class] json:result[@"categories"]] mutableCopy];
                                    //二级
                                     NSArray *topSubtressArray = [NSArray yy_modelArrayWithClass:[YBLCategoryTreeModel class] json:result[@"first"]];
                                     
                                     [self calculateDataWithArray:topSubtressArray Index:0];
                                     
                                 } else {
                                     NSArray *subtressArray = [NSArray yy_modelArrayWithClass:[YBLCategoryTreeModel class] json:result[@"categories"]];
                                     //
                                     [self calculateDataWithArray:subtressArray Index:index];
                                 }
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error,NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (void)calculateDataWithArray:(NSArray *)topSubtressArray Index:(NSInteger)index{
    
    //二级数据
    NSMutableArray *topSubtress_depth2_Array = [NSMutableArray array];
    for (YBLCategoryTreeModel *model in topSubtressArray) {
        if (model.depth.integerValue == 2) {
            [topSubtress_depth2_Array addObject:model];
        }
    }
    //排序后二级数据
    NSMutableArray *new_topSubtress_depth2_Array = [[topSubtress_depth2_Array sortedArrayUsingComparator:positionSort] mutableCopy];
    //存放二级下的三级总数据
    NSMutableArray *all_depth3_array = [NSMutableArray array];
    for (YBLCategoryTreeModel *model1 in new_topSubtress_depth2_Array) {
        //遍历总二级数据
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
        NSMutableArray *topSubtress_depth3_Array = [NSMutableArray array];
        for (YBLCategoryTreeModel *model2 in topSubtressArray) {
            if ([model2.parent_id isEqualToString:model1.id]) {
                [topSubtress_depth3_Array addObject:model2];
            }
        }
        NSMutableArray *new_topSubtress_depth3_Array = [[topSubtress_depth3_Array sortedArrayUsingComparator:positionSort] mutableCopy];
        
        [itemDict setObject:model1 forKey:@"section"];
        [itemDict setObject:new_topSubtress_depth3_Array forKey:@"row"];
        
        [all_depth3_array addObject:itemDict];
    }
    [self.allSubTreeCategoryDict setObject:all_depth3_array forKey:@(index)];
}

NSComparator positionSort = ^(YBLCategoryTreeModel *model1,YBLCategoryTreeModel *model2){
    
    if (model1.position.integerValue > model2.position.integerValue) {
        return (NSComparisonResult)NSOrderedDescending;
    }else if (model1.position.integerValue < model2.position.integerValue){
        return (NSComparisonResult)NSOrderedAscending;
    }
    else
        return (NSComparisonResult)NSOrderedSame;
};

@end

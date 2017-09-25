//
//  YBLOrderCommentsViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/6/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderCommentsViewModel.h"
#import "YBLOrderCommentsItemModel.h"

@interface YBLOrderCommentsViewModel ()

@end

@implementation YBLOrderCommentsViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        //custom title data
        self.titleArray = @[@[@"待评价",@"已评价"],
                            @[@"not_commented",@"commented"]];

        [self hanldeTitleData];
        
//        [self.all_title_data_array removeAllObjects];
//        
//        NSInteger index = 0;
//        for (NSString *title in self.titleArray[0]) {
//            NSString *para_value = self.titleArray[1][index];
//            YBLCategoryTreeModel *commentModel = [YBLCategoryTreeModel new];
//            commentModel.id = [NSString stringWithFormat:@"%@",@(index)];
//            commentModel.title = title;
//            commentModel.para_value = para_value;
//            [self.all_title_data_array addObject:commentModel];
//            index++;
//        }
    }
    return self;
}

- (RACSignal *)siganlForOrderCommentsListIsReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    YBLCategoryTreeModel *commentModel = self.all_title_data_array[self.currentFoundIndex];
    NSString *commented_or_not = commentModel.para_value;
    para[@"commented_or_not"] = commented_or_not;
    NSString *categoryID = commentModel.id;
    
    [[self siganlForManyListViewRequestLoadMoreWithPara:para
                                                   url:url_orders_comments
                                              isReload:isReload] subscribeNext:^(id  _Nullable x) {
        
        self.numberCountArray  = @[x[@"not_commented_count"],x[@"commented_count"]];
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLOrderCommentsItemModel class] json:x[@"items"]];
        NSMutableArray *fin_indexps = [self getNewIndexpathWithDataArray:dataArray categotyID:categoryID isReload:isReload];
        [subject sendNext:fin_indexps];
        [subject sendCompleted];

    } error:^(NSError * _Nullable error) {
        
    }];
    
    return subject;
}

@end

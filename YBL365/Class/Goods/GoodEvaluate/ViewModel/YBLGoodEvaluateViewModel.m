//
//  YBLGoodEvaluateViewModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodEvaluateViewModel.h"
#import "YBLOrderCommentsItemModel.h"

@implementation YBLGoodEvaluateViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleArray = @[@[@"全部",@"好评",@"中评",@"差评",@"有图"],
                            @[@"all",@"good",@"mid",@"bad",@"picture"]];

        [self hanldeTitleData];
        
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

- (RACSignal *)siganlForProductCommentsIsReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    YBLCategoryTreeModel *commentModel = self.all_title_data_array[self.currentFoundIndex];
    NSString *good_or_bad_score = commentModel.para_value;
    para[@"good_or_bad_score"] = good_or_bad_score;
    NSString *categoryID = commentModel.id;
    para[@"product_id"] = self.product_id;
    
    [[self siganlForManyListViewRequestLoadMoreWithPara:para
                                                   url:url_product_comments
                                              isReload:isReload] subscribeNext:^(id  _Nullable x) {
        
        self.numberArray = @[x[@"total"],x[@"good_total"],x[@"mid_total"],x[@"bad_total"],x[@"picture_total"]];
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLOrderCommentsModel class] json:x[@"comments"]];
        
        CGFloat comment_content_width = YBLWindowWidth-comments_left_space-space;
        
        for (YBLOrderCommentsModel *itemModel in dataArray) {
            if (itemModel.anonymity.boolValue) {
                itemModel.k_user_name = [YBLMethodTools changeToNiMing:itemModel.user_name];
            } else {
                itemModel.k_user_name = itemModel.user_name;
            }
            CGSize contentSize = [itemModel.content heightWithFont:YBLFont(14) MaxWidth:comment_content_width];
            itemModel.content_height = @(contentSize.height);
            itemModel.gridView_item_space = @(space/2);
            if (itemModel.pictures.count==0) {
                //1.无图
                itemModel.gridView_height = @(0);
                itemModel.cell_name = @"YBLEvaluateBaseCell";
                
            } else if (itemModel.pictures.count==1) {
                //2.单张图
                itemModel.gridView_item_width = @(comment_content_width/2);
                itemModel.gridView_height = itemModel.gridView_item_width;
                itemModel.cell_name = @"YBLEvaluateOnePicCell";
                
            } else if (itemModel.pictures.count == 4){
                //3.4张图
                itemModel.gridView_item_space = @(space/2);
                itemModel.gridView_item_width = @(comment_content_width/2-space);
                itemModel.gridView_height = @(2*itemModel.gridView_item_width.doubleValue+itemModel.gridView_item_space.doubleValue*4);
                itemModel.cell_name = @"YBLEvaluateFourCell";
                
            } else {
                //九宫格
                itemModel.gridView_item_space = @(space/2);
                itemModel.gridView_item_width = @((comment_content_width-space*2)/3);
                NSInteger lie = ceil((double)itemModel.pictures.count/3);
                itemModel.gridView_height = @(lie*(itemModel.gridView_item_width.doubleValue+itemModel.gridView_item_space.doubleValue+3));
                itemModel.cell_name = @"YBLEvaluateNineSortCell";
            }
        }
        NSMutableArray *fin_indexps = [self getNewIndexpathWithDataArray:dataArray categotyID:categoryID isReload:isReload];
        [subject sendNext:fin_indexps];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}

@end

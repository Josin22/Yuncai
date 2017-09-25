//
//  YBLMessageDetailViewModel.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/1.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMessageDetailViewModel.h"
#import "YBLCustomersLogsModel.h"
#import "YBLMineMillionMessageItemModel.h"

@implementation YBLMessageDetailViewModel

- (RACSignal *)singalForMessageIsReload:(BOOL)isReload{
    
    WEAK
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[self js_siganlForSingleListViewRequestLoadMoreWithPara:nil
                                                isReload:isReload
                                                     url:url_customers_log(self.model.id)
                                                 dictKey:@"logs"
                                           jsonClassName:@"YBLCustomersLogsModel"] subscribeNext:^(id  _Nullable x) {
        STRONG
//        [subject sendNext:x];
        for (YBLCustomersLogsModel *itemModel in x) {
            itemModel.name_bg_color = self.model.name_bg_color;
            itemModel.first_name = self.model.first_name;
            CGSize content_size = [itemModel.content heightWithFont:YBLFont(14) MaxWidth:YBLWindowWidth-50-4*space];
            itemModel.content_height = content_size.height+space;
            
            CGSize time_size = [itemModel.created_at heightWithFont:YBLFont(11) MaxWidth:YBLWindowWidth];
            itemModel.time_width = time_size.width;
        }
        
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    } completed:^{
        [subject sendCompleted];
    }];
    
    return subject;
}

@end

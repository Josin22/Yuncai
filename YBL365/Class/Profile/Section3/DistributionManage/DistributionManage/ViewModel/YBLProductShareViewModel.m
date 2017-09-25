
//
//  YBLProductShareViewModel.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLProductShareViewModel.h"
#import "YBLProductShareModel.h"

@implementation YBLProductShareViewModel

- (RACSignal *)singalForShareMoenyIsReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSString *url = url_share_money_products;
    NSString *dictkey = @"product_shares";
    if (self.rewardType == RewardTypeShare) {
        url = url_get_share_products;
        dictkey = nil;
    }
    
    [[self js_siganlForSingleListViewRequestLoadMoreWithPara:nil
                                                    isReload:isReload
                                                         url:url
                                                     dictKey:dictkey
                                               jsonClassName:@"YBLProductShareModel"] subscribeNext:^(id  _Nullable x) {
        for (YBLProductShareModel *model in x) {
            if ([model.status isEqualToString:@"running"]) {
                model.han_status = @"分享中";
            } else {
                model.han_status = @"已结束";
            }
            NSDictionary *same_dict = @{NSFontAttributeName:YBLFont(14),
                                        NSForegroundColorAttributeName:YBLThemeColor};
            if (self.rewardType == RewardTypeShare) {
            
                NSString *per_string = [NSString stringWithFormat:@"%.2f",model.per.doubleValue];
                NSString *visit_string = [NSString stringWithFormat:@"好友浏览 : %@ 云币",per_string];
                NSRange visit_range = [visit_string rangeOfString:per_string];
            
                NSMutableAttributedString *att_visit_string = [[NSMutableAttributedString alloc] initWithString:visit_string];
                [att_visit_string addAttributes:same_dict                                          range:NSMakeRange(visit_range.location, visit_range.length)];
                model.han_shared_visit_count = visit_string;
                model.att_han_shared_visit_count = att_visit_string;

                NSString *total_string = [NSString stringWithFormat:@"%.2f",model.total.doubleValue];
                NSString *remain_string = [NSString stringWithFormat:@"%.2f",model.remain.doubleValue];
                NSString *all_string = [NSString stringWithFormat:@"赏金总额 : %@ 云币 剩余云币 %@",total_string,remain_string];
                NSRange total_range = [all_string rangeOfString:total_string];
//                NSRange remain_range = [all_string rangeOfString:remain_string];
                
                NSMutableAttributedString *att_all_string = [[NSMutableAttributedString alloc] initWithString:all_string];
                [att_all_string addAttributes:same_dict range:NSMakeRange(total_range.location, total_range.length)];
                [att_all_string addAttributes:same_dict range:NSMakeRange(all_string.length-remain_string.length, remain_string.length)];
                model.han_total_per = all_string;
                model.att_total_per = att_all_string;
                
                
            } else {
                
                NSString *all_string = [NSString stringWithFormat:@"总额:%.2f云币 佣金:%.2f 云币/人",model.total.doubleValue,model.per.doubleValue];
                model.han_total_per = all_string;
                
                NSString *visit_string = [NSString stringWithFormat:@"分享%@次 / %@人浏览",model.shared_count,model.visit_count];
                model.han_shared_visit_count = visit_string;
            }
        }
        [subject sendNext:x];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    } completed:^{
        [subject sendCompleted];
    }];
    
    return subject;

}

@end

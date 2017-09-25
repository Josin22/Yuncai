//
//  YBLMyWalletsViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyWalletsViewModel.h"
#import "YBLWalletsRecordModel.h"
#import "YBLSingletonMethodTools.h"

@implementation YBLMyWalletsViewModel

- (NSMutableArray *)walletflows{
    if (!_walletflows) {
        _walletflows = [NSMutableArray array];
    }
    return _walletflows;
}

- (RACSignal *)siganlForWalletsIsReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[self siganlForSingleListViewRequestLoadMoreWithPara:nil
                                                     url:url_wallets_flows
                                                isReload:isReload] subscribeNext:^(id  _Nullable x) {
        if (isReload) {
            [self.singleDataArray removeAllObjects];
        }
        self.frozen_gold = x[@"frozen_gold"];
        self.gold = x[@"gold"];
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:NSClassFromString(@"YBLWalletflowsItemModel") json:x[@"flows"]];
        NSDateFormatter *dateFormatter = [YBLSingletonMethodTools shareMethodTools].cachedDateFormatter;
        //                                 dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSArray *sortedArray = [dataArray sortedArrayUsingComparator:^(YBLWalletflowsItemModel *walletsModel1,YBLWalletflowsItemModel *walletsModel2) {
            NSDate *date1 = [dateFormatter dateFromString:walletsModel1.created_at];
            NSDate *date2 = [dateFormatter dateFromString:walletsModel2.created_at];
            return [date2 compare:date1];
        }];
        
        for (YBLWalletflowsItemModel *itemModel in sortedArray) {
            [self resetWalletsFlowsItemModel:itemModel];
            itemModel.text_font = YBLFont(15);
            itemModel.text_max_width = YBLWindowWidth/2-space;
            [itemModel calulateTextSize:itemModel.desc];
        }
        NSInteger index_from = self.singleDataArray.count;
        //        NSMutableArray *fin_indexps = [YBLMethodTools getNewAppendingIndexPathsWithIndex:index_from appendingCount:dataArray.count];
        NSMutableArray *fin_indexps = [YBLMethodTools getRowAppendingIndexPathsWithIndex:index_from appendingCount:dataArray.count inSection:0];
        if (dataArray.count==0) {
            self.isNoMoreData = YES;
        } else {
            self.isNoMoreData = NO;
            [self.singleDataArray addObjectsFromArray:dataArray];
        }
        [subject sendNext:fin_indexps];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}

- (RACSignal *)siganlForWallets{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLLogLoadingView showInWindow];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_wallets
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
     
                                 [YBLLogLoadingView dismissInWindow];
                                 
                                 self.walletsModel = [YBLWalletsRecordModel yy_modelWithJSON:result];
                                 NSDateFormatter *dateFormatter = [YBLSingletonMethodTools shareMethodTools].cachedDateFormatter;
//                                 dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                                 NSArray *sortedArray = [self.walletsModel.walletflows sortedArrayUsingComparator:^(YBLWalletflowsItemModel *walletsModel1,YBLWalletflowsItemModel *walletsModel2) {
                                     NSDate *date1 = [dateFormatter dateFromString:walletsModel1.created_at];
                                     NSDate *date2 = [dateFormatter dateFromString:walletsModel2.created_at];
                                     return [date2 compare:date1];
                                 }];
                                 
                                 for (YBLWalletflowsItemModel *itemModel in sortedArray) {
                                     [self resetWalletsFlowsItemModel:itemModel];
                                     itemModel.text_font = YBLFont(15);
                                     itemModel.text_max_width = YBLWindowWidth/2-space;
                                     [itemModel calulateTextSize:itemModel.desc];
                                 }
                                 [self.walletsModel setValue:sortedArray forKey:@"firter_walletflows"];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (void)resetWalletsFlowsItemModel:(YBLWalletflowsItemModel *)itemModel
{
    NSString *otherString = @"";
    UIColor *s_textColor = BlackTextColor;
    NSArray *greyColor = @[@"bidding_frozen",@"purchse_frozen",@"frozen"];
    for (NSString *key in greyColor) {
        if ([itemModel.type isEqualToString:key]) {
            s_textColor = YBLTextLightColor;
            otherString = @"";
        }
    }
    NSArray *redColor = @[@"unfrozen",@"cancel_order_unfrozen",@"fail_bid_unfrozen",@"complete_unfrozen",@"income",@"compensate_income",@"bidder_break_income",@"no_break_purchase_over_unfrozen",@"no_break_bidder_over_unfrozen",@"bidder_cancel_unfrozen",@"purchasing_over_unfrozen",@"purchaser_complete_unfrozen",@"bidder_complete_unfrozen",@"gift",@"follow_quota_return",@"followed",@"income_share"];
    for (NSString *key in redColor) {
        if ([itemModel.type isEqualToString:key]) {
            otherString = @"+";
            s_textColor = YBLThemeColorAlp(.8);
        }
    }
    NSArray *blackColor = @[@"Illegal_spending",@"spending",@"purchaser_break_spending",@"follow_quota_spending",@"spending_follow",@"spending_share"];
    for (NSString *key in blackColor) {
        if ([itemModel.type isEqualToString:key]) {
            s_textColor = BlackTextColor;
            otherString = @"-";
        }
    }
    itemModel.textColor = s_textColor;
    itemModel.signlText = otherString;
}

@end

//
//  YBLPurchaseOrderModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPurchaseOrderModel.h"

@implementation purchase_state_for_purchaser_or_bidder_model
@end

@implementation YBLPurchaseOrderModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"purchase_pay_types":[YBLPurchaseInfosModel class],
             @"purchase_distributions":[YBLPurchaseInfosModel class]};
    
}

- (void)handleAttText{
    
    NSMutableAttributedString *att_joinRecordString = [YBLMethodTools getJoinVisitAttributedStringWithJoin:self.bidding_count
                                                                                                 visitTime:self.visit_times
                                                                                             componeString:@"/"];
    self.att_text = att_joinRecordString;
}

- (void)handleAttPrice{
    
    self.att_price = [NSString price:[NSString stringWithFormat:@"%.2f",self.price.doubleValue] color:YBLThemeColor font:16];;
}

@end

@implementation singleOutPriceRecords
@end

@implementation spree_order
@end


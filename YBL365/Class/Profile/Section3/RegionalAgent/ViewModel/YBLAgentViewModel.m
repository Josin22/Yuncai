//
//  YBLAgentViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAgentViewModel.h"

@implementation PriceRangeModel



@end

@implementation AgentParaModel


@end

@implementation YBLAgentViewModel

- (NSMutableArray *)priceRangeArray{
    
    if (!_priceRangeArray) {
        _priceRangeArray = [NSMutableArray array];
    }
    return _priceRangeArray;
}

- (NSMutableArray *)titeArray{
    
    if (!_titeArray) {
        _titeArray = [NSMutableArray array];
    }
    return _titeArray;
}

- (RACSignal *)siganlForAgentPrice{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_agent_price_range
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 [SVProgressHUD dismiss];
                                 
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[PriceRangeModel class] json:result[@"price_range"]];
                                 self.priceRangeArray = [dataArray mutableCopy];
                                 if (self.titeArray.count!=0) {
                                     [self.titeArray removeAllObjects];
                                 }
                                 for (PriceRangeModel *model in self.priceRangeArray) {
                                     NSString *firstString = model.price_range[0];
                                     NSString *secondString = model.price_range[1];
                                     NSString *finalString = [NSString stringWithFormat:@"%@-%@",firstString,secondString];
                                     [self.titeArray addObject:finalString];
                                 }
                                 
                                 [subject sendNext:result];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (RACSignal *)siganlForAgent{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"提交中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"company_name"] = self.agentParaModel.company_name;
    para[@"name"] = self.agentParaModel.name;
    para[@"mobile"] = self.agentParaModel.mobile;
    para[@"e_mail"] = self.agentParaModel.e_mail;
//    para[@"province"] = self.agentParaModel.province;
//    para[@"city"] = self.agentParaModel.city;
    para[@"county"] = self.agentParaModel.county;
    para[@"agent_price_range_id"] = self.agentParaModel.agent_price_range_id;
    
    [YBLRequstTools HTTPPostWithUrl:url_agent
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              
                              [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                              [subject sendNext:result];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

@end

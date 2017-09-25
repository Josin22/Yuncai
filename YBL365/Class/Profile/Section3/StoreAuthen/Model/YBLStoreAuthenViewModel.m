//
//  YBLStoreAuthenViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/6/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreAuthenViewModel.h"
#import "YBLCompanyTypesItemModel.h"

@implementation YBLStoreAuthenViewModel

+ (RACSignal *)signalForCompanyTypesWith:(NSString *)types{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"type"] = types;
    [YBLRequstTools HTTPGetDataWithUrl:url_company_types
                               Parames:para
                             commplete:^(id result,NSInteger statusCode) {
                                 
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLCompanyTypesItemModel class] json:result[@"companytypes"]];
                                 [subject sendNext:dataArray];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error,NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    return subject;
}

@end

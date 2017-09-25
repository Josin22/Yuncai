//
//  YBLStaffManageViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStaffManageViewModel.h"

@implementation YBLStaffManageViewModel

- (NSMutableArray *)staffDataArray{
    if (!_staffDataArray) {
        _staffDataArray = [NSMutableArray array];
    }
    return _staffDataArray;
}

- (RACSignal *)straffManageSignal {

    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_salesmen
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLStaffManageModel class] json:result];
                                 self.staffDataArray = [dataArray mutableCopy];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

+ (RACSignal *)signalForUpdateStaffWithID:(NSString *)_id rolse:(NSString *)rolse salesMan:(NSDictionary *)salesMan {

    RACReplaySubject *subject = [RACReplaySubject subject];
 
    [SVProgressHUD showWithStatus:@"保存中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"roles"] = rolse;
    para[@"salesman"] = [salesMan yy_modelToJSONString];
    if (_id) {
        para[@"id"] = _id;
    }
    [YBLRequstTools HTTPPostWithUrl:url_salesmen
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              YBLStaffManageModel *staffModel = [YBLStaffManageModel yy_modelWithJSON:result];
                              if (staffModel) {
                                  [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                      [subject sendNext:staffModel];
                                      [subject sendCompleted];
                                  });
                              } else {
                                  [SVProgressHUD showErrorWithStatus:@"保存失败"];
                              }
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

- (RACSignal *)signalForDeleteStaffWithid:(NSString *)_id {

    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"删除中"];
    
    [YBLRequstTools HTTPDELETEWithUrl:url_salesmen_delete(_id)
                              Parames:[@{@"id":_id} mutableCopy]
                            commplete:^(id result, NSInteger statusCode) {
                                if ([result[@"result"] isEqualToString:@"SUCCESS"]) {
                                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                                    [subject sendNext:result];
                                    [subject sendCompleted];
                                } else {
                                    [SVProgressHUD showErrorWithStatus:@"删除失败"];
                                }
                            }
                              failure:^(NSError *error, NSInteger errorCode) {
                                  [subject sendError:error];
                              }];
    
    return subject;
}

+ (RACSignal *)signalForDeleteStaffWithid:(NSString *)_id {
    return [[self alloc] signalForDeleteStaffWithid:_id];
}



@end

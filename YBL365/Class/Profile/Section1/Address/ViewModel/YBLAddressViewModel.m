//
//  YBLAddressViewModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAddressViewModel.h"

@implementation YBLAddressViewModel

- (YBLAddressModel *)addressInfoModel{
    if (!_addressInfoModel) {
        _addressInfoModel = [YBLAddressModel new];
    }
    return _addressInfoModel;
}

- (NSMutableDictionary *)areaDict{
    
    if (!_areaDict) {
        _areaDict = [NSMutableDictionary dictionary];
    }
    return _areaDict;
}

- (RACSignal *)areaInfoSignalWithId:(NSInteger)Id Index:(NSInteger)index{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    if (index==0) {
        Id = 0;
    }
    NSString *idString = [NSString stringWithFormat:@"%@",@(Id)];
    [YBLRequstTools HTTPGetDataWithUrl:url_address_area(idString)
                               Parames:nil
                             commplete:^(id result,NSInteger statusCode) {
                                 NSArray *areaArray = [NSArray yy_modelArrayWithClass:[YBLAddressAreaModel class] json:result];
                                  [self.areaDict setObject:areaArray forKey:@(index)];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error,NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (RACSignal *)areaListSignalWithId:(NSInteger)Id Index:(NSInteger)index{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSString *idString = [NSString stringWithFormat:@"%@",@(Id)];
    [YBLRequstTools HTTPGetDataWithUrl:url_address_area_list(idString)
                               Parames:nil
                             commplete:^(id result,NSInteger statusCode) {
                                 NSArray *areaInfoArray = [NSArray yy_modelArrayWithClass:[YBLAddressAreaModel class] json:result];
                                 [self.areaDict setObject:areaInfoArray forKey:@(index)];
                                 NSArray *allKey = [self.areaDict allKeys];
                                 for (NSNumber *indexNum in allKey) {
                                     if (indexNum.integerValue>index) {
                                         [self.areaDict removeObjectForKey:indexNum];
                                     }
                                 }
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error,NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

+ (RACSignal *)siganlForAllAddress{
    
    return [[self alloc] getSiganlForIsSelfSelector:NO];
}

- (RACSignal *)getSiganlForIsSelfSelector:(BOOL)isSelf{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    if (isSelf) {
//        [SVProgressHUD showWithStatus:@"加载中..."];
        [YBLLogLoadingView showInWindow];
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (self.addressGenre == AddressGenreShipping||!isSelf) {
        para[@"genre"] = @"shipping";
    } else {
        para[@"genre"] = @"ziti";
    }
    [YBLRequstTools HTTPGetDataWithUrl:url_receiptinfos
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 NSArray *addressArray = [NSArray yy_modelArrayWithClass:[YBLAddressModel class] json:result];
                                 if (isSelf) {
                                     [YBLLogLoadingView dismissInWindow];
                                     self.allAddressArray = [addressArray mutableCopy];
                                     for (YBLAddressModel *selectAddressModel in self.selectAddressArray) {
                                         for (YBLAddressModel *addressModel in self.allAddressArray) {
                                             if ([selectAddressModel.id isEqualToString:addressModel.id]) {
                                                 addressModel.is_select = YES;
                                             }
                                         }
                                     }
                                 } else {
                                     [subject sendNext:addressArray];
                                 }
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;

}

- (RACSignal *)allAddressSignal{

    return [self getSiganlForIsSelfSelector:YES];
}

- (NSMutableArray *)allAddressArray{
    
    if (!_allAddressArray) {
        _allAddressArray = [NSMutableArray array];
    }
    return _allAddressArray;
}

- (RACSignal *)signalForAddAddress{
    
    return [self changeOrAddAddress:NO];
}

- (RACSignal *)signalForChangeAddress{
    
    return [self changeOrAddAddress:YES];
}

- (RACSignal *)changeOrAddAddress:(BOOL)isChangeAddress{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (self.addressInfoModel.id) {
        para[@"id"] = self.addressInfoModel.id;
    }
    para[@"district"] = self.addressInfoModel.district;
    para[@"street_address"] = self.addressInfoModel.street_address;
    para[@"consignee_name"] = self.addressInfoModel.consignee_name;
    para[@"consignee_phone"] = self.addressInfoModel.consignee_phone;
    para[@"desc_address"] = self.addressInfoModel.desc_address;
    CLLocationDegrees lat = [self.addressInfoModel.location[0] doubleValue];
    CLLocationDegrees lng = [self.addressInfoModel.location[1] doubleValue];
    if (lat!=0&&lng!=0) {
        para[@"lat"] = @(lat);
        para[@"lng"] = @(lng);
    } else {
        para[@"lat"] = self.addressInfoModel.lat;
        para[@"lng"] = self.addressInfoModel.lng;
    }
    para[@"default"] = self.addressInfoModel._default;
    if (self.addressGenre == AddressGenreShipping) {
        para[@"genre"] = @"shipping";
    } else {
        para[@"genre"] = @"ziti";
    }
    NSString *paraString = [para yy_modelToJSONString];
    
    [YBLRequstTools HTTPPostWithUrl:url_receiptinfos
                            Parames:[@{@"address":paraString} mutableCopy]
                          commplete:^(id result, NSInteger statusCode) {
                              
                              YBLAddressModel *addressModel = [YBLAddressModel yy_modelWithJSON:result];
                              if (addressModel) {
                                  if (isChangeAddress) {
                                      [SVProgressHUD showSuccessWithStatus:@"修改成功~"];
                                  } else {
                                      [SVProgressHUD showSuccessWithStatus:@"添加成功~"];
                                  }
                                  [subject sendNext:@(YES)];
                              } else {
                                  [subject sendNext:@(NO)];
                                  if (isChangeAddress) {
                                      [SVProgressHUD showErrorWithStatus:@"修改失败~"];
                                  } else {
                                      [SVProgressHUD showErrorWithStatus:@"添加失败~"];
                                  }
                              }
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
    
}


- (RACSignal *)signalForDeleteAddressWithID:(NSString *)_id{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"删除中..."];
    
    [YBLRequstTools HTTPDELETEWithUrl:url_receiptinfos_delete(_id)
                              Parames:nil
                            commplete:^(id result, NSInteger statusCode) {
                                
                                if (statusCode == 200) {
                                    [subject sendNext:@(YES)];
                                    [SVProgressHUD showSuccessWithStatus:@"删除成功~"];
                                }else {
                                    [subject sendNext:@(NO)];
                                    [SVProgressHUD showErrorWithStatus:@"删除失败~"];
                                }
                                [subject sendCompleted];
                            }
                              failure:^(NSError *error, NSInteger errorCode) {
                                  [subject sendError:error];
                              }];
    
    return subject;
}



- (NSMutableArray *)getSelectZitiArray {

    NSMutableArray *selectZitiAddressArray = [NSMutableArray array];;
    for (YBLAddressModel *model in self.allAddressArray) {
        if (model.is_select) {
            [selectZitiAddressArray addObject:model];
        }
    }
    return selectZitiAddressArray;
}

@end

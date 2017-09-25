//
//  YBLMineMillionMessageViewModel.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMineMillionMessageViewModel.h"
#import "YBLMineMillionMessageItemModel.h"

@interface YBLMineMillionMessageViewModel ()

@property (nonatomic, strong) NSArray *colorArray;

@end

@implementation YBLMineMillionMessageViewModel

- (NSArray *)colorArray{
    if (!_colorArray) {
        _colorArray = @[YBLColor(233 , 69, 71 , 1),
                        YBLColor(236 , 103 , 33, 1),
                        YBLColor(227 , 93 , 117, 1),
                        YBLColor(78 , 164 , 219, 1),
                        YBLColor(73 , 103 , 176, 1),
                        YBLColor(177 , 96 , 34, 1),
                        YBLColor(103 , 91 , 166, 1),
                        YBLColor(223 , 48 , 139, 1),
                        YBLColor(231 , 47 , 45, 1),
                        YBLColor(214 , 125 , 176, 1),];
    }
    return _colorArray;
}

- (RACSignal *)signalForMillionCoustomersIsReload:(BOOL)isReload{
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (self.city) {
        para[@"city"] = self.city;
    }
    if (self.genre) {
        para[@"genre"] = self.genre;
    }

    NSString *url = url_customers_mine;
    if (self.millionType == MillionTypePublic) {
        url = url_customers;
    }
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[self siganlForSingleListViewRequestLoadMoreWithPara:para
                                                isReload:isReload
                                                     url:url
                                                 dictKey:@"customers"
                                           jsonClassName:@"YBLMineMillionMessageItemModel"] subscribeNext:^(id  _Nullable x) {
        for (YBLMineMillionMessageItemModel *itemModel in self.selectCustomerArray) {
            [self.singleDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YBLMineMillionMessageItemModel *model = (YBLMineMillionMessageItemModel *)obj;
                if ([model.id isEqualToString:itemModel.id]) {
                    model.is_select = @(YES);
                    *stop = YES;
                }
            }];
        }
        for (YBLMineMillionMessageItemModel *model in self.singleDataArray) {
            if (!model.first_name) {
                NSInteger randomIn = [YBLMethodTools getRandomNumber:0 to:9];
                model.name_bg_color = self.colorArray[randomIn];
                NSString *firstName = [model.name substringToIndex:1];
                model.first_name = model.name.length>0?firstName:@"无";        
            }
        }
        [subject sendNext:x];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}

- (RACSignal *)signalForMillionCustomersId:(NSString *)customerId isFoucs:(BOOL)isFoucs{
    
    RACReplaySubject *subject = [RACReplaySubject subject];

//    NSString *hud = isFoucs == NO?@"关注中...":@"取消关注...";
//    [SVProgressHUD showWithStatus:hud];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"action"] = isFoucs == NO?@"bind":@"unbind";
    para[@"customer_id"] = customerId;

    [YBLRequstTools HTTPPostWithUrl:url_customers_bind
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              
//                              NSString *hud = isFoucs == NO?@"关注成功~":@"取消成功~";
//                              [SVProgressHUD showSuccessWithStatus:hud];
                              
                              [subject sendNext:result];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                if (errorCode == 422) {
                                    [SVProgressHUD dismiss];
                                    [subject sendNext:@(errorCode)];
                                }
                                [subject sendError:error];
                            }];
    
    return subject;
}

- (NSInteger)caculateSelectCount{
    
    NSInteger selectCount = 0;
    for (YBLMineMillionMessageItemModel *model in self.singleDataArray) {
        if (model.is_select.boolValue) {
            selectCount++;
        }
    }
    return selectCount;
}

- (NSMutableArray *)getSelectCustomerArray{
    
    NSMutableArray *selectCustomerArray = @[].mutableCopy;
    
    for (YBLMineMillionMessageItemModel *model in self.singleDataArray) {
        if (model.is_select.boolValue) {
            [selectCustomerArray addObject:model];
        }
    }
    return selectCustomerArray;
}


@end

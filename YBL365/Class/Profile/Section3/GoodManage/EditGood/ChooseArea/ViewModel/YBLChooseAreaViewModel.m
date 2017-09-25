//
//  YBLChooseAreaViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLChooseAreaViewModel.h"
#import "YBLAddressAreaModel.h"

@implementation YBLChooseAreaViewModel

- (NSInteger)countByAreaType{
    
    NSInteger count = 4;
    
    if (self.chooseAreaVCType == ChooseAreaVCTypeGetPart) {
        count = 3;
    }
    
    return count;
}

- (RACSignal *)signalForSaveAreaSetting{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSString *type = nil;
    switch (self.areaType) {
        case AreaTypeSalesArea:
        {
            type = @"sales_area";
        }
            break;
        case AreaTypeDisplayPriceArea:
        {
            type=@"display_price_area";
        }
            break;
            
        default:
            break;
    }
    
    //处理数据
    NSArray *allKey = [self.selectAreaDataDict allKeys];
    NSString *codeString = @"";
    for (NSNumber *idNumber in allKey) {
        codeString = [codeString stringByAppendingString:[NSString stringWithFormat:@",%@",idNumber]];
    }
    codeString = [codeString substringFromIndex:1];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"type"] = type;
    para[@"areas"] = codeString;
    
    [YBLRequstTools HTTPPostWithUrl:url_setareas(self._id)
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              if (result[@"areas"]) {
                                  [subject sendNext:@YES];
                              } else {
                                  [subject sendNext:@NO];
                              }
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
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
                                 if ((self.chooseAreaVCType == ChooseAreaVCTypeGetAll||self.chooseAreaVCType == ChooseAreaVCTypeSetAll)&&index == 0) {
                                     
                                         NSMutableArray *firstAreaDataArray = [NSMutableArray array];
                                         
                                         YBLAddressAreaModel *firstModel = [YBLAddressAreaModel new];
                                         firstModel.text = @"全国";
                                         firstModel.id = @(0);
                                         firstModel.code = 0;
                                         [firstAreaDataArray addObject:firstModel];
                                         
                                         [firstAreaDataArray addObjectsFromArray:areaInfoArray];
                                         
                                         [self.sxAreaDataDict setObject:firstAreaDataArray forKey:@(Id)];
                                     
                                 } else {
                                         
                                         [self.sxAreaDataDict setObject:areaInfoArray forKey:@(Id)];
                                    
                                 }
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error,NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (void)saveModel:(YBLAddressAreaModel *)model{
    if (model.id.integerValue == 0) {
        //全国
        [self.selectAreaDataDict removeAllObjects];
        [self.selectAreaDataDict setObject:model forKey:model.id];
    } else {
        //其他省市县
        if (self.selectAreaDataDict[@(0)]) {
            [self.selectAreaDataDict removeObjectForKey:@(0)];
        }
        //去重
        NSString *idString = [NSString stringWithFormat:@"%@",model.id];
        NSString *string70 = [idString substringFromIndex:2];
        NSString *string50 = [idString substringFromIndex:4];
        NSString *string30 = [idString substringFromIndex:6];
        if ([string70 isEqualToString:@"0000000"]) {
            //新添加为省,删除市级一下地区
            [self handleIdString:idString SubIndex:2 model:model];
            
        } else if ([string50 isEqualToString:@"00000"]) {
            //新添加为市,删除县级一下地区
            [self handleIdString:idString SubIndex:4 model:model];
            
        } else if ([string30 isEqualToString:@"000"]) {
            //新添加为县,删除乡级一下地区
            [self handleIdString:idString SubIndex:6 model:model];
        } else {
            ///第四季不考虑
           [self.selectAreaDataDict setObject:model forKey:model.id];
        }
    }
}

-(void)handleIdString:(NSString *)idString SubIndex:(NSInteger)index model:(YBLAddressAreaModel *)model{
    
    for (NSNumber *keyIDNumber in [self.selectAreaDataDict allKeys]) {
        NSString *keyID = [NSString stringWithFormat:@"%@",keyIDNumber];
        NSString *string2 = [keyID substringToIndex:index];
        NSString *idString2 = [idString substringToIndex:index];
        if ([idString2 isEqualToString:string2]) {
            [self.selectAreaDataDict removeObjectForKey:keyIDNumber];
        }
    }
    [self.selectAreaDataDict setObject:model forKey:model.id];
    return;
}


- (void)deleteModel:(YBLAddressAreaModel *)model{
    if(self.selectAreaDataDict[model.id]){
        [self.selectAreaDataDict removeObjectForKey:model.id];
    }
}

- (NSMutableDictionary *)sxAreaDataDict{
    
    if (!_sxAreaDataDict) {
        _sxAreaDataDict = [NSMutableDictionary dictionary];
        if (self.chooseAreaVCType == ChooseAreaVCTypeGetPart) {
            NSMutableArray *firstAreaDataArray = [NSMutableArray array];
#warning test choose area!!!!!
            YBLAddressAreaModel *firstModel = [YBLAddressAreaModel new];
            NSInteger first_id = 410100000;
            firstModel.text = @"测试-郑州";
            firstModel.id = @(first_id);
            firstModel.code = 0;
            firstModel.isSelect = YES;
            [firstAreaDataArray addObject:firstModel];
            [_sxAreaDataDict setObject:firstAreaDataArray forKey:@(0)];
        }
    }
    return _sxAreaDataDict;
}
- (NSMutableDictionary *)selectAreaDataDict{
    
    if (!_selectAreaDataDict) {
        _selectAreaDataDict = [NSMutableDictionary dictionary];
    }
    return _selectAreaDataDict;
}

@end

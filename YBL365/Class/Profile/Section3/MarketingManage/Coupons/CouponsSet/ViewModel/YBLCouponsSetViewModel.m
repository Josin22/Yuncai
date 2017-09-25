//
//  YBLCouponsSetViewModel.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCouponsSetViewModel.h"
#import "YBLEditItemGoodParaModel.h"

@implementation YBLCouponsSetViewModel

- (NSMutableArray *)cellDataArray{
    if (!_cellDataArray) {
        _cellDataArray = [NSMutableArray array];
        YBLEditItemGoodParaModel *model1 = [YBLEditItemGoodParaModel new];
        model1.title = @"优惠商品";
        model1.isRequired = YES;
        model1.paraString = @"product_id";
        model1.initial_text = @"yhsp";
        model1.editTypeCell = EditTypeCellOnlyClick;
        [_cellDataArray addObject:model1];
        
        YBLEditItemGoodParaModel *model2 = [YBLEditItemGoodParaModel new];
        model2.title = @"购买金额满 :";
        model2.isRequired = YES;
        model2.initial_text = @"gmjem";
        model2.paraString = @"condition";
        model2.keyboardType = UIKeyboardTypeDecimalPad;
        model2.editTypeCell = EditTypeCellOnlyWrite;
        [_cellDataArray addObject:model2];
        
        
        YBLEditItemGoodParaModel *model3 = [YBLEditItemGoodParaModel new];
        model3.title = @"优惠金额减 :";
        model3.isRequired = YES;
        model3.initial_text = @"yhjej";
        model3.paraString = @"value";
        model3.keyboardType = UIKeyboardTypeDecimalPad;
        model3.editTypeCell = EditTypeCellOnlyWrite;
        [_cellDataArray addObject:model3];
        
        YBLEditItemGoodParaModel *model4 = [YBLEditItemGoodParaModel new];
        model4.title = @"优惠券数量 :";
        model4.isRequired = YES;
        model4.initial_text = @"yhqsl";
        model4.paraString = @"quantity";
        model4.keyboardType = UIKeyboardTypePhonePad;
        model4.editTypeCell = EditTypeCellOnlyWrite;
        [_cellDataArray addObject:model4];
        
        YBLEditItemGoodParaModel *model5 = [YBLEditItemGoodParaModel new];
        model5.title = @"优惠时效 : 起";
        model5.isRequired = YES;
        model5.paraString = @"start_time";
        model5.initial_text = @"yhsxq";
        model5.editTypeCell = EditTypeCellOnlyClick;
        [_cellDataArray addObject:model5];
        
        YBLEditItemGoodParaModel *model6 = [YBLEditItemGoodParaModel new];
        model6.title = @"优惠时效 : 止";
        model6.isRequired = YES;
        model6.paraString = @"end_time";
        model6.initial_text = @"yhsxz";
        model6.editTypeCell = EditTypeCellOnlyClick;
        [_cellDataArray addObject:model6];
    }
    return _cellDataArray;
}

- (RACSignal *)siganlForSaveCoupons{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    BOOL isFinish = YES;
    for (YBLEditItemGoodParaModel *model in self.cellDataArray) {
        if (model.paraValueString.length==0) {
            isFinish = NO;
        }
    }
    
    if (!isFinish) {
        [SVProgressHUD showErrorWithStatus:@"您还没填写完整哟~"];
        return subject;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    for (YBLEditItemGoodParaModel *model in self.cellDataArray) {
        para[model.paraString] = model.paraValueString;
    }
    
    [YBLRequstTools HTTPPostWithUrl:url_coupons
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"保存成功~"];
                              [subject sendNext:result];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

@end

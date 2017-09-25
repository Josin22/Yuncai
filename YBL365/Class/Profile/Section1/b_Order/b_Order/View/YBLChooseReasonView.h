//
//  YBLChooseReasonView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBaseView.h"
#import "YBLOrderRefuseReasonModel.h"

typedef void(^ChooseReasonViewDoneBlock)(YBLOrderRefuseReasonModel *selectReason,NSInteger selectIndex);

@interface YBLChooseReasonView : YBLBaseView

+ (void)showChooseReasonInView:(UIViewController *)Vc
                   orderSource:(OrderSource)orderSource
          handleCompeleteBlock:(ChooseReasonViewDoneBlock)handleCompeleteBlock;

+ (void)showChooseReasonInView:(UIViewController *)Vc
                       stateEn:(NSString *)stateEn
                   orderSource:(OrderSource)orderSource
          handleCompeleteBlock:(ChooseReasonViewDoneBlock)handleCompeleteBlock;

@end

//
//  YBLFooterPrintsPopView.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLGoodModel;

typedef void(^FooterPrintsPopViewDidSelectItemBlock)(YBLGoodModel *selectGoodModel);

typedef void(^FooterPrintsPopViewCancelBlock)();

@interface YBLFooterPrintsPopView : UIView

+ (void)showFooterPrintsPopViewWithDataArray:(NSMutableArray *)dataArray
                             completionBlock:(FooterPrintsPopViewDidSelectItemBlock)completionBlock
                                 cancelBlock:(FooterPrintsPopViewCancelBlock)cancelBlock;

@end

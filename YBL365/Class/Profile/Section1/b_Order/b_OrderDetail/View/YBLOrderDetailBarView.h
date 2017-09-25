//
//  YBLOrderDetailBarView.h
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLOrderItemModel;

typedef void(^OrderDetailBarViewClickBlock)(NSString *selectText,YBLOrderPropertyItemModel *selectButtonModel,BOOL isSeller);

@interface YBLOrderDetailBarView : UIView

- (instancetype)initWithFrame:(CGRect)frame orderSource:(OrderSource)orderSource;

@property (nonatomic, strong) YBLOrderItemModel *itemModel;

@property (nonatomic, strong) OrderDetailBarViewClickBlock orderDetailBarViewClickBlock;

@end

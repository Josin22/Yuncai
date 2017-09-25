//
//  YBLAddSubtractView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/18.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLAddSubtractView;

typedef void(^CurrentCountChangeBlock)(NSInteger countValue,YBLAddSubtractView *addSubView,BOOL isClickButton);

typedef void(^CurrentFloatChangeBlock)(float floatValue,YBLAddSubtractView *addSubView,BOOL isClickButton);

typedef NS_ENUM(NSInteger,IntegerOrFloatType) {
    //整数
    IntegerOrFloatTypeInteger = 0,
    //小数
    IntegerOrFloatTypeFloat
};

@interface YBLAddSubtractView : UIView

- (instancetype)initWithFrame:(CGRect)frame integerOrFloatType:(IntegerOrFloatType)integerOrFloatType;

@property (nonatomic, assign) BOOL isEnableButton;
///最小整数值
@property (nonatomic, assign) NSInteger minCount;
///最大整数值
@property (nonatomic, assign) NSInteger maxCount;
///当前整数值
@property (nonatomic, assign) NSInteger currentCount;
///当前整数值回调
@property (nonatomic, copy  ) CurrentCountChangeBlock currentCountChangeBlock;

@property (nonatomic, assign) float minFloat;

@property (nonatomic, assign) float maxFloat;

@property (nonatomic, assign) float currentFloat;

@property (nonatomic, copy  ) CurrentFloatChangeBlock currentFloatChangeBlock;

@end

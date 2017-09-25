//
//  YBLAllPayShipButtonView.h
//  YC168
//
//  Created by 乔同新 on 2017/5/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLPurchaseInfosModel;

typedef void(^AllPayShipButtonViewUpdateHeightBlock)(void);

typedef void(^AllPayShipButtonViewClickBlock)(YBLPurchaseInfosModel *infoModel);

typedef NS_ENUM(NSInteger,SelectType) {
    ///都能选
    SelectTypeAll = 0,
    ///只能选择一个
    SelectTypeOneOfAll
};

@interface YBLAllPayShipButtonView : UIView

@property (nonatomic, copy ) AllPayShipButtonViewUpdateHeightBlock allPayShipButtonViewUpdateHeightBlock;

@property (nonatomic, copy ) AllPayShipButtonViewClickBlock allPayShipButtonViewClickBlock;

@property (nonatomic, strong) NSMutableDictionary *selectDataDict;

@property (nonatomic, strong) NSArray *paraPayShipIdsArray;

@property (nonatomic, strong) NSString *paraPayShipTitles;

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)dataArray;

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)dataArray selectType:(SelectType)selectType;

- (void)getFinalData;

@end

//
//  YBLPayshipmentItemButtonCollectionView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PayShipMentItemButtonType) {
    ///下单选择支付配送方式
    PayShipMentItemButtonTypeTakeOrderChooseMent = 0,
    ///商品设置支付配送方式
    PayShipMentItemButtonTypeGoodSettingMent,
    ///商品展示支付配送方式
    PayShipMentItemButtonTypeGoodShowMent
};

typedef void(^PayshipmentItemButtonCollectionViewButtonClickBlock)(id model,NSInteger index,BOOL isDefault);

@interface YBLPayshipmentItemButtonCollectionView : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
    payShipMentItemButtonType:(PayShipMentItemButtonType)payShipMentItemButtonType;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy  ) PayshipmentItemButtonCollectionViewButtonClickBlock payshipmentItemButtonCollectionViewButtonClickBlock;

@end

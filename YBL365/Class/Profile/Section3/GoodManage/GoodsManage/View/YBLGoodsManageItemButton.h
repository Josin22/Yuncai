//
//  YBLGoodsManageItemButton.h
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GoodsManageItemButtonClickBlock)(NSInteger index);

@interface YBLGoodsManageItemButton : UIView

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, copy  ) GoodsManageItemButtonClickBlock goodsManageItemButtonClickBlock;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;

@end

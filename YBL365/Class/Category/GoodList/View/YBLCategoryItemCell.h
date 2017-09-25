//
//  YBLCategoryItemCell.h
//  YBL365
//
//  Created by 乔同新 on 16/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLGoodModel.h"

@interface YBLCategoryItemCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * goodImageView;
@property (nonatomic, retain) UILabel     * goodNameLabel;
@property (nonatomic, retain) UILabel     * priceLabel;
@property (nonatomic, retain) UILabel     * saleCountLabel;
@property (nonatomic, strong) UIButton    * moreButton;
/**
 0：列表视图，1：格子视图
 */
@property (nonatomic, assign) BOOL        isListType;

@end

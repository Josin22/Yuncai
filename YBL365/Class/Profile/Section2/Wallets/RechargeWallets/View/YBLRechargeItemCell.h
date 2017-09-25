//
//  YBLRechargeItemCell.h
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLRechargeWalletsModel,TextImageButton;

@interface YBLRechargeItemCell : UICollectionViewCell

@property (nonatomic, strong) TextImageButton *itemButton;

- (void)updateItemModel:(YBLRechargeWalletsModel *)model;

@end
